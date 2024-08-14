#!/bin/bash
# Função para exibir a ajuda
function show_help() {
  echo "Bem vindo ao password-generator! Versão 1.0, (c) 2024, Fulano de Tal, DIMAp, UFRN"
  echo "Uso: ./password-generator.sh [OPÇÕES]"
  echo "Opções:"
  echo "  -l [COMPRIMENTO] : comprimento da senha"
  echo "  -u               : Inclui letras maiúsculas"
  echo "  -d               : Inclui números"
  echo "  -s               : Inclui símbolos"
  echo "  -h               : Exibe essa mensagem de ajuda"
  echo "  -o               : Salva a senha gerada em um arquivo"
  echo "  -n NAME          : Adiciona um nome a senha gerada"
  echo "  -p               : Exibe senhas geradas"
  exit 0
}

function list_passwords() {
  echo "Lista de senhas:"
  cat ./password_list.txt
  exit 0
}

function save_password() {
  NAME_AND_PASSWORD=$PASSWORD

  if [ "$USE_NAME" = true ]; then
    NAME_AND_PASSWORD="$NAME $PASSWORD"
  fi

  
  if [ ! -e "password_list.txt" ] && $SAVE_IN_FILE; then
    touch "password_list.txt"  
  fi
  
  if [ "$SAVE_IN_FILE" = true ]; then
    echo "$NAME_AND_PASSWORD" >> "password_list.txt"
    echo "$NAME_AND_PASSWORD"
    echo "Senha salva em password_list.txt"
  else
    echo "$NAME_AND_PASSWORD"
  fi   
}

# Definir variáveis padrão
LENGTH=8
USE_UPPERCASE=false
USE_DIGITS=false
USE_SYMBOLS=false

SAVE_IN_FILE=false
USE_NAME=false
NAME=""

# Parsear argumentos
while getopts "l:udshon:p" opt; do
  case ${opt} in
    l) LENGTH=$OPTARG ;;
    u) USE_UPPERCASE=true ;;
    d) USE_DIGITS=true ;;
    s) USE_SYMBOLS=true;;
    h) show_help;;
    o) SAVE_IN_FILE=true;;
    n) 
      USE_NAME=true
      NAME=$OPTARG;;
    p) list_passwords ;; 
    \?)
      echo "Opção inválida: -$OPTARG" 1>&2
      show_help;;
    :)
      echo "Opção -$OPTARG requer um argumento." 1>&2
      show_help ;;
  esac
done

# Definir conjuntos de caracteres
LOWERCASE="abcdefghijklmnopqrstuvwxyz"
UPPERCASE="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
DIGITS="0123456789"
SYMBOLS="!@#$%^&*()-_=+[]{}|;:,.<>?/~"

# Construir a lista de caracteres permitidos
CHARS=$LOWERCASE

if [ "$USE_UPPERCASE" = true ]; then
  CHARS+=$UPPERCASE
fi
if [ "$USE_DIGITS" = true ]; then
  CHARS+=$DIGITS
fi
if [ "$USE_SYMBOLS" = true ]; then
  CHARS+=$SYMBOLS
fi

# Gerar a senha
PASSWORD=$(tr -dc "$CHARS" </dev/urandom | head -c "$LENGTH")

save_password