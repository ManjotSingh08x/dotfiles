function fish_user_key_bindings
    # Load default fzf bindings first
    fzf_key_bindings

    # 1. Remap File Search: CTRL-T -> CTRL-F
    bind -e \ct # Erase default Ctrl-T
    bind \cf fzf-file-widget # Bind Ctrl-F to File Search

    # 2. Remap Directory Search: ALT-C -> ALT-F
    bind -e \ec # Erase default Alt-C (\ec is Alt-C in fish)
    bind \ef fzf-cd-widget # Bind Alt-F to Directory Search

    # 3. Remap History: CTRL-R -> CTRL-H
    bind -e \cr # Erase default Ctrl-R
    bind \ch fzf-history-widget # Bind Ctrl-H to History Search
end
