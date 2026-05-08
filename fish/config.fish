if status is-interactive
    starship init fish | source
    set fish_greeting
    pyenv init - fish | source
	fish_vi_key_bindings
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
