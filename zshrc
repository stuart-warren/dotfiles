set -o ignoreeof # https://superuser.com/q/479600 - ignore ctrl+d

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"
#export LANG="en_GB.UTF-8"
export EDITOR="nvim"
export AWS_PAGER=""

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    dotenv
    sudo
)

export GOPATH="${HOME}"
export GITROOT="${HOME}/src"
mkdir -p "${GITROOT}"
export PROJECT_HOME=${GITROOT}
export VIRTUAL_ENV_DISABLE_PROMPT=0
export PY_USER_BIN=$(python3 -c 'import site; print(site.USER_BASE + "/bin")')

path=(
  "${GOPATH}/bin"
  "${HOME}/bin"
  "${HOME}/.local/bin"
  "${HOME}/.cargo/bin"
  "${PY_USER_BIN}"
  $path
)

[[ -f "${PY_USER_BIN}/pipx" ]] && "${PY_USER_BIN}/pipx" ensurepath # should be same as ${PY_USER_BIN}

# setup oh-my-zsh
[[ -f $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh
# asdf language tool plugins
[[ -f ${HOME}/.asdf/asdf.sh ]] && source ${HOME}/.asdf/asdf.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f $HOME/.p10k.zsh ]] && source $HOME/.p10k.zsh

# setup fzf
[[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -f $HOME/.fzf.zsh ]] && source $HOME/.fzf.zsh
bindkey "ç" fzf-cd-widget

# awscli
[[ -f "${PY_USER_BIN}/aws_zsh_completer.sh" ]] && source "${PY_USER_BIN}/aws_zsh_completer.sh"

# aliases
[[ -f $HOME/.aliases ]] && source $HOME/.aliases
# Local config
[[ -f $HOME/.zshrc.local ]] && source $HOME/.zshrc.local
