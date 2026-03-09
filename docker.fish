#!/usr/bin/env fish

function install_docker
    # Detecta yay ou paru
    set aur_helper ""
    if type -q yay
        set aur_helper "yay"
    else if type -q paru
        set aur_helper "paru"
    else
        echo "❌ Nenhum AUR helper (yay/paru) encontrado. Instale um deles e rode novamente."
        exit 1
    end

    echo "🔧 Instalando Docker e Compose V2 usando $aur_helper..."
    $aur_helper -S --needed --noconfirm docker docker-compose

    echo "⚙️ Habilitando e iniciando o serviço Docker..."
    sudo systemctl enable docker
    sudo systemctl start docker

    echo "👤 Adicionando usuário $USER ao grupo docker..."
    sudo usermod -aG docker $USER

    echo ""
    echo "✅ Docker e Compose V2 instalados e configurados!"
    echo "➡️ Teste com:"
    echo "   docker version"
    echo "   docker compose version"
    echo ""
    echo "⚠️ É necessário sair e entrar novamente na sessão (ou reiniciar) para aplicar a permissão do grupo docker."
end

install_docker
