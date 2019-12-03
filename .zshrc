# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration
LS_COLORS="ow=01;36;40" && export LS_COLORS

prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
   # prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
  fi
}

build_prompt_() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_context
  prompt_dir
  prompt_end
  #git-radar --zsh --fetch
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sjanssen/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/sjanssen/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/sjanssen/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/sjanssen/google-cloud-sdk/completion.zsh.inc'; fi
