if status is-interactive
    starship init fish | source
    set fish_greeting
    pyenv init - fish | source
end
