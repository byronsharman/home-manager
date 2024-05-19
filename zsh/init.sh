# cd on steroids, made by Grant & Lukas
function jmp {
  # remove the -H from fd to omit hidden files
  cd "$(cat <(fd -H --base-directory=$HOME -E .cache -E .config/discord -E .config/google-chrome --type d -c never | awk '{print "~/"$0}' | sort) <(echo "~") | fzf $([ -z "$1" ] || echo "-q$1") --tac | sed "s#~#$HOME#g")"
}

bindkey '^ ' autosuggest-accept
