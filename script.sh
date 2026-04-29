#!/bin/bash

set -e

echo "==> Atualizando sistema..."
sudo pacman -Syu --noconfirm

echo "==> Instalando dependências e pacotes oficiais..."
sudo pacman -S --needed --noconfirm \
    base-devel git linux-headers \
    fastfetch flatpak vim btop docker ranger

# Ativar docker
echo "==> Configurando Docker..."
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

# Configurar flatpak
echo "==> Configurando Flatpak (Flathub)..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Verifica se yay já está instalado
if command -v yay &> /dev/null; then
    echo "==> yay já está instalado."
else
    echo "==> Instalando yay..."
    cd /tmp
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
fi

echo "==> Instalando pacotes AUR..."

PACOTES_AUR=(
    visual-studio-code-bin
    zen-browser-bin
    brave-bin
    lazygit
    lazydocker
    zoxide
    niri
    noctalia-shell
)

yay -S --needed --noconfirm "${PACOTES_AUR[@]}"

echo "==> Instalando pacotes Flatpak..."

PACOTES_FLATPAK=(
    com.discordapp.Discord
    org.onlyoffice.desktopeditors
    org.musescore.MuseScore
    net.sourceforge.GrandOrgue
    org.kde.okular
    com.calibre_ebook.calibre
    com.slack.Slack
)

flatpak install -y flathub "${PACOTES_FLATPAK[@]}"

echo "==> Limpeza..."
yay -Yc --noconfirm

echo "==> Concluído!"
echo "⚠️ Reinicie ou faça logout para aplicar o grupo docker."
