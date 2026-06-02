function ne --wraps='nvm current | tee .node-version .nvmrc' --description 'alias ne=nvm current | tee .node-version .nvmrc'
    nvm current | tee .node-version .nvmrc $argv
end
