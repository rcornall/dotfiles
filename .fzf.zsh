# Setup fzf
# ---------
if [[ ! "$PATH" == */home/rcornall/.fzf/bin* ]]; then
  export PATH="$PATH:/home/rcornall/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/rcornall/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/rcornall/.fzf/shell/key-bindings.zsh"

