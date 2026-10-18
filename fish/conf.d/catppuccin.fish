# Catppuccin Mocha for fish syntax highlighting (themes/catppuccin-mocha.theme)
# and fzf (https://github.com/catppuccin/fzf; bg left unset to keep terminal transparency).
if status is-interactive
    fish_config theme choose catppuccin-mocha
end

set -gx FZF_DEFAULT_OPTS "\
--color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a,border:#6c7086,label:#cdd6f4"
