#!/usr/bin/env bash

read -r -d '' CONTENT << 'EOF'
##<DEV-ENVIRONMENT

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

##DEV-ENVIRONMENT>
EOF



arquivo="~/.zprofile"
texto="DEV-ENVIRONMENT"

PARAM=$1

case "$PARAM" in
    "install")
        if [ -f "$arquivo" ] && grep -q "$texto" "$arquivo"; then # replace
            echo "Atualizando o arquivo '$arquivo'"
            perl -0777 -pi -e 's/##<DEV-ENVIRONMENT.*?##DEV-ENVIRONMENT>/$ENV{CONTENT}/gs' $arquivo
        elif # append
            echo "Configurando o arquivo '$arquivo'"
            cat < $CONTENT >> $arquivo
        fi
        ;;
    "uninstall")
        if [ -f "$arquivo" ] && grep -q "$texto" "$arquivo"; then # replace
            echo "Removendo conteudo do arquivo '$arquivo'"
            perl -0777 -pi -e 's/##<DEV-ENVIRONMENT.*?##DEV-ENVIRONMENT>/##REMOVED/gs' $arquivo
        else
            echo "nada a fazer no arquivo '$arquivo'" >&2
        fi
        ;;
    *)
        echo "Opção inválida" >&2
        exit 127
        ;;
esac
