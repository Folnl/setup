#!/usr/bin/env fish

function setup_git_identity
    read -P "👤 Nome: " name
    read -P "📧 Email: " email
    read -P "🔑 Nome do arquivo da chave (ex: id_ed25519_pessoal): " keyfile
    read -P "📂 Diretório de trabalho (ex: ~/workspace/pessoal): " workdir
    read -P "🌐 Host (apelido para o GitHub, ex: github-pessoal): " host

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

    echo "⚙️ Criando configuração Git separada em ~/.gitconfig-$host"
    echo "
[user]
    name = $name
    email = $email
[core]
    sshCommand = ssh -i ~/.ssh/$keyfile -F /dev/null
" > ~/.gitconfig-$host

    echo "⚙️ Adicionando includeIf no ~/.gitconfig"
    git config --global includeIf."gitdir:$workdir/".path "~/.gitconfig-$host"

    echo "✅ Configuração finalizada para $name em $workdir"
end

echo "=== Configurando primeira conta ==="
setup_git_identity

echo "=== Configurando segunda conta ==="
setup_git_identity

echo "🎉 Pronto! Agora o Git escolhe a identidade certa automaticamente dependendo do diretório."
