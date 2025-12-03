#!/usr/bin/env bash

cat << EOF >> ~/.zprofile

eval "$$(/opt/homebrew/bin/brew shellenv)"
alias upgrade="brew update && brew upgrade"
# Verifica se o arquivo existe
HORA_AJUSTADA=$$(printf "%02d" $(( $$(date +%-H) / 6 * 6 )))
LOCKFILE="/tmp/brew.update.once-$(date +"%Y%m%d")$${HORA_AJUSTADA}.pid"
[[ -e "$${LOCKFILE}" ]] || { touch "$${LOCKFILE}"; upgrade; }

export NVM_DIR="$${HOME}/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


export PATH="$${HOME}/.jenv/bin:$${PATH}"
eval "$$(jenv init -)"

eval "$$(rbenv init - zsh)"

# Dart binaries
export PATH="$${PATH}":"$${HOME}/.pub-cache/bin"

EOF
