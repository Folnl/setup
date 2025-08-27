#!/usr/bin/env fish

function setup_git_identity --argument name email keyfile host
    echo "🔑 Gerando chave SSH para $name..."
    ssh-keygen -t ed25519 -C $email -f ~/.ssh/$keyfile -N ""

    echo "📂 Configurando SSH para $name..."
    echo "
Host $host
    HostName github.com
    User git
    IdentityFile ~/.ssh/$keyfile
    IdentitiesOnly yes
" >> ~/.ssh/config

    echo "✅ Adicionando chave ao ssh-agent..."
    eval (ssh-agent -c)
    ssh-add ~/.ssh/$keyfile
end

# ==========================
# Perguntar dados no terminal
# ==========================

echo "=== Conta Pessoal ==="
read -P "Nome pessoal: " personal_name
read -P "Email pessoal: " personal_email

echo "=== Conta Trabalho ==="
read -P "Nome trabalho: " work_name
read -P "Email trabalho: " work_email

# ==========================
# Configuração das contas
# ==========================

# Conta Pessoal -> global
setup_git_identity $personal_name $personal_email "id_ed25519_pessoal" "github-pessoal"
git config --global user.name $personal_name
git config --global user.email $personal_email

# Conta Trabalho -> somente chave + helper
setup_git_identity $work_name $work_email "id_ed25519_trabalho" "github-trabalho"

# ==========================
# Helper para repositórios de trabalho
# ==========================
function git-work-identity
    echo "⚙️ Configurando identidade de trabalho neste repositório..."
    git config user.name "$work_name"
    git config user.email "$work_email"
    echo "✅ Agora este repositório usa sua conta de trabalho!"
end

echo ""
echo "⚡️ Finalizado!"
echo ""
echo "➡️ Para repositórios pessoais (default):"
echo "   git clone git@github-pessoal:usuario/repositorio.git"
echo ""
echo "➡️ Para repositórios de trabalho:"
echo "   git clone git@github-trabalho:empresa/repositorio.git"
echo "   cd repositorio && git-work-identity"
