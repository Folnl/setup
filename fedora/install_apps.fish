#!/usr/bin/env fish

# Apps instalados via DNF
set dnf_apps \
    neovim \
    zed \
    mise \
    bat \
    eza \
    ripgrep \
    fd-find \
    tmux \
    starship \
    tealdeer \
    zellij \
    awscli \
    git \
    curl \
    wget \
    jq \
    podman \
    podman-compose \
    podman-docker

# Dependências comuns de desenvolvimento
set dev_deps \
    gcc \
    gcc-c++ \
    make \
    openssl-devel \
    zlib-devel \
    bzip2 \
    readline-devel \
    sqlite

# Apps instalados via Flatpak
set flatpak_apps \
    app.zen_browser.zen \
    io.dbeaver.DBeaverCommunity

echo "🔄 Atualizando sistema..."
sudo dnf upgrade --refresh -y

echo "🛠 Instalando grupo Development Tools..."
sudo dnf groupinstall -y "Development Tools"

# Instala apps do repositório
for app in $dnf_apps
    if rpm -q $app >/dev/null
        echo "✅ $app já está instalado."
    else
        echo "📦 Instalando $app..."
        sudo dnf install -y $app
    end
end

# Instala dependências de desenvolvimento
for dep in $dev_deps
    if rpm -q $dep >/dev/null
        echo "✅ $dep já está instalado."
    else
        echo "📦 Instalando $dep..."
        sudo dnf install -y $dep
    end
end

# Brave Browser
if not type -q brave-browser
    echo "📦 Instalando Brave..."
    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo dnf install -y brave-browser
else
    echo "✅ Brave já está instalado."
end

# Terraform
if not type -q terraform
    echo "📦 Instalando Terraform..."
    sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
    sudo dnf install -y terraform
else
    echo "✅ Terraform já está instalado."
end

# Visual Studio Code
if not type -q code
    echo "📦 Instalando Visual Studio Code..."
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

    sudo sh -c 'echo -e "[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

    sudo dnf install -y code
else
    echo "✅ Visual Studio Code já está instalado."
end

# Cursor
if not type -q cursor
    echo "📦 Instalando Cursor..."
    mkdir -p ~/.local/bin
    curl -L https://cursor.sh/install -o /tmp/cursor-install.sh
    bash /tmp/cursor-install.sh
end

# Flatpak
if not type -q flatpak
    echo "📦 Instalando Flatpak..."
    sudo dnf install -y flatpak
end

# Adiciona Flathub
if not flatpak remote-list | grep -q flathub
    echo "🔗 Adicionando Flathub..."
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
end

# Instala apps Flatpak
for app in $flatpak_apps
    if flatpak list | grep -q $app
        echo "✅ $app já está instalado via Flatpak."
    else
        echo "📦 Instalando $app via Flatpak..."
        flatpak install flathub $app -y
    end
end

echo ""
echo "🐳 Teste do Podman:"
echo "   podman run hello-world"
echo ""
echo "📦 Usando Compose:"
echo "   podman compose up -d"
echo ""
echo "💻 Abrir VS Code:"
echo "   code ."

echo ""
echo "✅ Instalação concluída!"
