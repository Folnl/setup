#!/usr/bin/env fish

set SRC_FILE mise/config.toml
set DEST_DIR ~/.config/mise
set DEST_FILE $DEST_DIR/config.toml
set FISH_CONFIG ~/.config/fish/config.fish
set ACTIVATE_LINE 'mise activate fish | source'

# 1. Verifica se o arquivo de origem existe
if not test -f $SRC_FILE
    echo "❌ Arquivo $SRC_FILE não encontrado."
    exit 1
end

# 2. Cria diretório de destino, se não existir
if not test -d $DEST_DIR
    echo "📂 Criando diretório $DEST_DIR..."
    mkdir -p $DEST_DIR
end

# 3. Copia o arquivo apenas se houver diferença
if test -f $DEST_FILE
    if cmp -s $SRC_FILE $DEST_FILE
        echo "ℹ️  $SRC_FILE e $DEST_FILE são idênticos. Nenhuma cópia necessária."
    else
        echo "📋 Arquivos diferem. Copiando $SRC_FILE para $DEST_FILE..."
        cp $SRC_FILE $DEST_FILE
    end
else
    echo "📋 Destino inexistente. Copiando $SRC_FILE para $DEST_FILE..."
    cp $SRC_FILE $DEST_FILE
end

# 4. Aplica as mudanças com mise install
echo "⚙️  Executando mise install..."
mise install

# 5. Adiciona linha de ativação ao config.fish se ainda não existir
if not grep -Fxq $ACTIVATE_LINE $FISH_CONFIG
    echo "➡️  Adicionando ativação do mise ao $FISH_CONFIG..."
    echo $ACTIVATE_LINE >> $FISH_CONFIG
else
    echo "ℹ️  Ativação do mise já presente em $FISH_CONFIG."
end

# 6. Ativa mise na sessão atual imediatamente
echo "🔄 Ativando mise nesta sessão..."
eval $ACTIVATE_LINE

echo "✅ Mise configurado e ativado com sucesso!"
