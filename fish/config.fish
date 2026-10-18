if status is-interactive
    starship init fish | source
    set fish_greeting
    pyenv init - fish | source
	fish_vi_key_bindings
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# nvim
set --export EDITOR nvim

# pnpm
set -gx PNPM_HOME '/home/dorian/.local/share/pnpm'
if not string match -q -- "$PNPM_HOME/bin" $PATH
  set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end

# opencode
fish_add_path /home/dorian/.opencode/bin
