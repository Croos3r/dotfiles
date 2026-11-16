#!/usr/bin/env bash
# Claude Code status line: two lines, Nerd Font icons, bar charts.
input=$(cat)

IFS=$'\t' read -r model effort dir cost dur_ms added removed ctx h5 d7 < <(
  jq -r '[
    (.model.display_name // "Claude"),
    (.effort.level // .model.effort // .effort // "" | if type=="string" then . else "" end),
    (.workspace.current_dir // .cwd // ""),
    (.cost.total_cost_usd // 0),
    (.cost.total_duration_ms // 0),
    (.cost.total_lines_added // 0),
    (.cost.total_lines_removed // 0),
    (.context_window.used_percentage // -1),
    (.rate_limits.five_hour.used_percentage // -1),
    (.rate_limits.seven_day.used_percentage // -1)
  ] | map(tostring | if . == "" then "-" else . end) | join("\t")' <<<"$input" 2>/dev/null
)
[ "$effort" = "-" ] && effort=""

R=$'\e[0m'; DIM=$'\e[2m'; B=$'\e[1m'
c() { printf '\e[38;5;%sm' "$1"; }
MAUVE=$(c 141); BLUE=$(c 75); GREEN=$(c 114); YELLOW=$(c 221); RED=$(c 203)
ORANGE=$(c 215); GREY=$(c 245); CYAN=$(c 80)

I_BOT=$'\U000f06a9'; I_DIR=$''; I_GIT=$''; I_CTX=$'\U000f035b'
I_COST=$''; I_TIME=$'\U000f13ab'; I_LIM=$'\U000f04c5'; I_CLOCK=$''
SEP="  "

# color by percentage threshold
heat() { local p=${1%.*}; if [ "$p" -ge 80 ]; then printf %s "$RED"; elif [ "$p" -ge 50 ]; then printf %s "$YELLOW"; else printf %s "$GREEN"; fi; }
# bar <pct> <width>
bar() {
  local p=${1%.*} w=$2 filled i out=""
  filled=$(( (p * w + 50) / 100 )); [ "$filled" -gt "$w" ] && filled=$w
  [ "$p" -gt 0 ] && [ "$filled" -eq 0 ] && filled=1
  for ((i = 0; i < w; i++)); do [ "$i" -lt "$filled" ] && out+="▰" || out+="▱"; done
  printf '%s%s%s' "$(heat "$p")" "$out" "$R"
}

# ---- line 1: model, directory, git, diff
l1="${MAUVE}${B}${I_BOT} ${model}${R}"
[ -n "$effort" ] && l1+=" ${DIM}(${effort})${R}"

short=${dir/#$HOME/\~}
l1+="${SEP}${BLUE}${I_DIR} ${short}${R}"

if [ -n "$dir" ] && branch=$(git -C "$dir" --no-optional-locks symbolic-ref --short -q HEAD 2>/dev/null ||
                             git -C "$dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null); then
  g="${ORANGE}${I_GIT} ${branch}${R}"
  dirty=$(git -C "$dir" --no-optional-locks status --porcelain 2>/dev/null | wc -l)
  [ "$dirty" -gt 0 ] && g+=" ${YELLOW}●${dirty}${R}"
  if ab=$(git -C "$dir" --no-optional-locks rev-list --left-right --count '@{u}...HEAD' 2>/dev/null); then
    read -r behind ahead <<<"$ab"
    [ "$ahead" -gt 0 ] && g+=" ${GREEN}↑${ahead}${R}"
    [ "$behind" -gt 0 ] && g+=" ${RED}↓${behind}${R}"
  fi
  l1+="${SEP}${g}"
fi

if [ "$added" != 0 ] || [ "$removed" != 0 ]; then
  l1+="${SEP}${GREEN}+${added}${R} ${RED}-${removed}${R}"
fi

# ---- line 2: context, cost, duration, rate limits, clock
l2=""
if [ "${ctx%.*}" -ge 0 ] 2>/dev/null; then
  l2+="${GREY}${I_CTX}${R} $(bar "$ctx" 10) $(heat "$ctx")${ctx%.*}%${R}${SEP}"
fi

l2+="${CYAN}${I_COST}$(printf '%.2f' "$cost")${R}"

s=$(( ${dur_ms%.*} / 1000 ))
if [ "$s" -ge 3600 ]; then d="$((s / 3600))h$(( (s % 3600) / 60 ))m"; elif [ "$s" -ge 60 ]; then d="$((s / 60))m"; else d="${s}s"; fi
l2+="${SEP}${GREY}${I_TIME} ${d}${R}"

lim=""
[ "${h5%.*}" -ge 0 ] 2>/dev/null && lim+="${DIM}5h${R} $(bar "$h5" 5) $(heat "$h5")${h5%.*}%${R}"
if [ "${d7%.*}" -ge 0 ] 2>/dev/null; then
  [ -n "$lim" ] && lim+="  "
  lim+="${DIM}7d${R} $(bar "$d7" 5) $(heat "$d7")${d7%.*}%${R}"
fi
[ -n "$lim" ] && l2+="${SEP}${GREY}${I_LIM}${R} ${lim}"

l2+="${SEP}${DIM}${I_CLOCK} $(date +%H:%M)${R}"

printf '%s\n%s\n' "$l1" "$l2"
