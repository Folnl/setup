#!/usr/bin/env fish

# Lista de aplicações a serem instaladas
set apps \
  brave-bin \
  cursor-bin \
  neovim \
  zed \
  mise

# Lista de apps para instalar apenas pelos repositórios oficiais
set repo_apps \
  aws-cli-v2 \
  terraform

# Lista de aplicações Flatpak a serem instaladas
set flatpak_apps \
  app.zen_browser.zen \
  io.dbeaver.DBeaverCommunity

# Verifica se yay está instalado
if not type -q yay
    echo "❌ yay não está instalado. Por favor, instale o yay antes de executar este script."
    exit 1
end

if not type -q flatpak
    echo "❌ flatpak não está instalado. Instalando flatpak..."
    sudo pacman -S flatpak --noconfirm
end

# Atualiza os repositórios
echo "🔄 Atualizando pacotes..."
yay -Syu --noconfirm

# Instala cada aplicação
for app in $apps
    if yay -Qi $app > /dev/null
        echo "✅ $app já está instalado."
    else
        echo "📦 Instalando $app..."
        yay -S $app --noconfirm
    end
end

# Instala pacotes dos repositórios oficiais
for app in $repo_apps
    if yay -Qi $app > /dev/null
        echo "✅ $app já está instalado (repo)."
    else
        echo "📦 Instalando $app dos repositórios oficiais..."
        yay -S --repo $app --noconfirm
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
