#!/bin/bash
# Função para exibir a ajuda
function show_help() {
  echo "Bem vindo ao password-generator! Versão 1.0, (c) 2024, Fulano de Tal, DIMAp, UFRN"
  echo "Uso: ./password-generator.sh [OPÇÕES]"
  echo "Opções:"
  echo "  -l [COMPRIMENTO] : comprimento da senha"
  echo "  -u               : incluir letras maiúsculas"
  echo "  -d               : incluir números"
  echo "  -s               : incluir símbolos"
  echo "  -h               : exibir essa mensagem de ajuda"
  exit 0
}

# Definir variáveis padrão
LENGTH=8
USE_UPPERCASE=false
USE_DIGITS=false
USE_SYMBOLS=false

# Parsear argumentos
while getopts "l:udsh" opt; do
  case ${opt} in
    l )
      LENGTH=$OPTARG
      ;;
    u )
      USE_UPPERCASE=true
      ;;
    d )
      USE_DIGITS=true
      ;;
    s )
      USE_SYMBOLS=true
      ;;
    h )
      show_help
      ;;
    \? )
      echo "Opção inválida: -$OPTARG" 1>&2
      show_help
      ;;
    : )
      echo "Opção -$OPTARG requer um argumento." 1>&2
      show_help
      ;;
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

# Verificar se há caracteres disponíveis
if [ -z "$CHARS" ]; then
  echo "Erro: Nenhum conjunto de caracteres selecionado." 1>&2
  exit 1
fi

# Gerar a senha
PASSWORD=$(tr -dc "$CHARS" </dev/urandom | head -c "$LENGTH")

# Exibir a senha gerada
echo "Senha gerada: $PASSWORD"

# Opcional: salvar a senha em um arquivo criptografado
echo "$PASSWORD" | openssl enc -aes-256-cbc -salt -out password.txt.enc -pass pass:senha-secreta
