# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME=joebadmo

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/local/bin:/bin:/usr/sbin:/sbin:/usr/bin:/usr/X11/bin:/usr/local/share/npm/bin:~/.bin:~/.bin/terraform:~/npm/bin:~/.cargo/bin:

# More extensive tab completion
autoload -U compinit
compinit

# case-insensitive tab completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# turn off autocorrect
unsetopt correct_all

# vi mode
bindkey -v
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
KEYTIMEOUT=1

# emacs keybindings in vi mode

### (ins mode)
bindkey -M viins '^?'   backward-delete-char
bindkey -M viins '^H'   backward-delete-char
bindkey -M viins '^a'   beginning-of-line
bindkey -M viins '^e'   end-of-line
bindkey -M viins '\e^?' backward-kill-word

### (cmd mode)
bindkey -M vicmd '^a'   beginning-of-line
bindkey -M vicmd '^e'   end-of-line
bindkey -M vicmd '^w'   backward-kill-word
bindkey -M vicmd '/'    vi-history-search-forward
bindkey -M vicmd '?'    vi-history-search-backward
bindkey -M vicmd '\ef'  forward-word                      # Alt-f
bindkey -M vicmd '\eb'  backward-word                     # Alt-b
bindkey -M vicmd '\ed'  kill-word                         # Alt-d

# reverse search in vi mode
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward

# local machine only
if [ $(uname) = "Darwin" ]; then

  # boxen
  [ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh

  alias vim="nvim"
  alias vi="nvim"
  alias vim.="nvim -c 'Unite -start-insert file_rec/async'"


fi

# rationalise dot

rationalise-dot() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

# aliases

alias ll="ls -lah"
alias ag="ag -i"

DISABLE_AUTO_UPDATE=true

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# FZF

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND='ag --hidden -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# autojump

[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

# per directory git config

zstyle ':chpwd:profiles:/Users/jmoon/work(|/|/*)'       profile work
# zstyle ':chpwd:profiles:(|/|/*)'       profile play

chpwd_profile_work() {
  [[ ${profile} == ${CHPWD_PROFILE} ]] && return 1
  print "Switched to $profile git user/email"

  export GIT_AUTHOR_NAME='Joe Moon'
  export GIT_AUTHOR_EMAIL='jmoon@appnexus.com'
  export GIT_COMMITTER_NAME='joe moon'
  export GIT_COMMITTER_EMAIL='jmoon@appnexus.com'
}

chpwd_profile_default() {
  [[ ${profile} == ${CHPWD_PROFILE} ]] && return 1
  print "Switched back to $profile git user/email"

  unset GIT_AUTHOR_NAME
  unset GIT_AUTHOR_EMAIL
  unset GIT_COMMITTER_NAME
  unset GIT_COMMITTER_EMAIL
}

function chpwd_profiles() {
  local profile context
  local -i reexecute

  context=":chpwd:profiles:$PWD"
  zstyle -s "$context" profile profile || profile='default'
  zstyle -T "$context" re-execute && reexecute=1 || reexecute=0

  if (( ${+parameters[CHPWD_PROFILE]} == 0 )); then
    typeset -g CHPWD_PROFILE
    local CHPWD_PROFILES_INIT=1
    (( ${+functions[chpwd_profiles_init]} )) && chpwd_profiles_init
  elif [[ $profile != $CHPWD_PROFILE ]]; then
    (( ${+functions[chpwd_leave_profile_$CHPWD_PROFILE]} )) \
      && chpwd_leave_profile_${CHPWD_PROFILE}
  fi
  if (( reexecute )) || [[ $profile != $CHPWD_PROFILE ]]; then
    (( ${+functions[chpwd_profile_$profile]} )) && chpwd_profile_${profile}
  fi

  CHPWD_PROFILE="${profile}"
  return 0
}

# Add the chpwd_profiles() function to the list called by chpwd()!
chpwd_functions=( ${chpwd_functions} chpwd_profiles )
