#!/usr/bin/env fish

# Lista de aplicações a serem instaladas via AUR helper
set apps \
  brave-bin \
  cursor-bin \
  neovim \
  zed \
  mise

# Lista de apps para instalar apenas pelos repositórios oficiais
set repo_apps \
  aws-cli-v2 \
  terraform \
  podman

# Lista de aplicações Flatpak a serem instaladas
set flatpak_apps \
  app.zen_browser.zen \
  io.dbeaver.DBeaverCommunity

# Detecta o AUR helper disponível: yay ou paru
set AUR_HELPER ""
if type -q yay
    set AUR_HELPER yay
else if type -q paru
    set AUR_HELPER paru
else
    echo "❌ Nenhum AUR helper encontrado. Por favor, instale o 'yay' ou 'paru'."
    exit 1
end

# Verifica se flatpak está instalado
if not type -q flatpak
    echo "❌ flatpak não está instalado. Instalando flatpak..."
    sudo pacman -S flatpak --noconfirm
end

# Atualiza os pacotes
echo "🔄 Atualizando pacotes com $AUR_HELPER..."
$AUR_HELPER -Syu --noconfirm

# Instala cada aplicação via AUR helper
for app in $apps
    if $AUR_HELPER -Qi $app > /dev/null
        echo "✅ $app já está instalado."
    else
        echo "📦 Instalando $app..."
        $AUR_HELPER -S $app --noconfirm
    end
end

# Instala pacotes dos repositórios oficiais
for app in $repo_apps
    if $AUR_HELPER -Qi $app > /dev/null
        echo "✅ $app já está instalado (repo)."
    else
        echo "📦 Instalando $app dos repositórios oficiais..."
        sudo pacman -S $app --noconfirm
    end
end

# Instala os pacotes Flatpak
for app in $flatpak_apps
    if flatpak list | grep -q $app
        echo "✅ $app já está instalado via Flatpak."
    else
        echo "📦 Instalando $app via Flatpak..."
        flatpak install flathub $app -y
    end
end

echo "✅ Instalação concluída!"
