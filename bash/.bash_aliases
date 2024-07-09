alias cp='cp -i'
alias ectool='~/code/EmbeddedController/build/hx20/util/ectool'
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gcan='git commit --amend --no-edit --date now'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias gfp='git fetch --prune'
alias gl='git pull'
alias glog='git log --oneline --graph'
alias gloga='git log --oneline --graph --all'
alias gp='git push'
alias gpf='git push --force'
alias grb='git rebase'
alias gst='git status'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias mv='mv -i'
alias rm='rm -i'

boop () {
  local last="$?"
  if [[ "$last" == '0' ]]; then
    sfx good
  else
    sfx bad
  fi
  $(exit "$last")
}
