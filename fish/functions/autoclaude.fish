function autoclaude --wraps='claude --permission-mode bypassPermissions' --description 'alias autoclaude=claude --permission-mode bypassPermissions'
    claude --permission-mode bypassPermissions $argv
end
