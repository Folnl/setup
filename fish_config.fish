#!/usr/bin/env fish

set -l SRC_ALIASES (pwd)/fish/aliases.fish
set -l CONFIG_DIR ~/.config/fish
set -l CONFIG_FILE $CONFIG_DIR/config.fish
set -l DEST_ALIASES $CONFIG_DIR/aliases.fish
set -l INCLUDE_LINE 'source ~/.config/fish/aliases.fish'
set -l STARSHIP_INIT 'starship init fish | source'

echo "🐟 Configurando Fish Shell com Starship e aliases..."

# 1. Garante que o diretório existe
mkdir -p $CONFIG_DIR

# 2. Copia o arquivo aliases.fish, se existir na pasta atual
if test -f $SRC_ALIASES
    echo "📋 Copiando $SRC_ALIASES para $DEST_ALIASES..."
    cp $SRC_ALIASES $DEST_ALIASES
else
    echo "❌ Arquivo aliases.fish não encontrado na pasta atual!"
end

# 3. Garante que o config.fish existe
if not test -f $CONFIG_FILE
    touch $CONFIG_FILE
end

# 4. Adiciona inicialização do starship ao config.fish
if not grep -Fxq $STARSHIP_INIT $CONFIG_FILE
    echo "➡️ Adicionando Starship ao $CONFIG_FILE..."
    echo $STARSHIP_INIT >> $CONFIG_FILE
end

# 5. Faz o vínculo para carregar os aliases
if not grep -Fxq $INCLUDE_LINE $CONFIG_FILE
    echo "➡️ Adicionando include dos aliases ao $CONFIG_FILE..."
    echo $INCLUDE_LINE >> $CONFIG_FILE
else
    echo "ℹ️ Include dos aliases já está presente em $CONFIG_FILE."
end

echo "🎉 Configuração concluída!"
