# cd on steroids, made by Grant & Lukas
function jmp {
  # remove the -H from fd to omit hidden files
  cd "$(cat <(fd --base-directory=$HOME -E archives/coronado_archives -E venv --type d -c never | awk '{print "~/"$0}' | sort) <(echo "~") | fzf $([ -z "$1" ] || echo "-q$1") --tac | sed "s#~#$HOME#g")"
}

bindkey '^ ' autosuggest-accept
FZF_ALT_C_COMMAND= source <(fzf --zsh)
