#!/bin/bash

echo "=== INSTALACIÓN COMPLETA DE PREREQUISITOS PARA APPIUM ==="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}$1${NC}"
    else
        echo -e "${RED}$1${NC}"
        exit 1
    fi
}

# Verificar si es Ubuntu/Debian
if ! command -v apt-get >/dev/null 2>&1; then
    echo -e "${RED}Este script solo funciona en sistemas basados en Debian/Ubuntu${NC}"
    exit 1
fi

echo -e "${YELLOW}Actualizando sistema...${NC}"
sudo apt update && sudo apt upgrade -y
print_status "Sistema actualizado"

# Instalar herramientas esenciales
echo -e "${YELLOW}Instalando herramientas base...${NC}"
sudo apt install -y \
    git curl wget unzip \
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    software-properties-common
print_status "Herramientas base instaladas"

# Instalar Java 8 (compatible con Android SDK)
echo -e "${YELLOW}Instalando Java JDK 8...${NC}"
sudo apt install -y openjdk-8-jdk
print_status "Java JDK 8 instalado"

# Configurar Java 8 como predeterminado
sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
print_status "Java 8 configurado como predeterminado"

# Instalar ADB
echo -e "${YELLOW}Instalando Android Platform Tools (ADB)...${NC}"
sudo apt install -y adb
print_status "ADB instalado"

# Instalar Ruby via RVM (más confiable que la versión del sistema)
echo -e "${YELLOW}Instalando Ruby y Bundler...${NC}"
sudo apt install -y gnupg2
gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 3.2.5
rvm use 3.2.5 --default
print_status "Ruby 3.2.5 instalado"

# Instalar Bundler
gem install bundler
print_status "Bundler instalado"

# Instalar Node.js 18 (LTS)
echo -e "${YELLOW}Instalando Node.js 18...${NC}"
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
print_status "Node.js 18 instalado"

# Configurar npm para instalaciones globales sin sudo
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

# Agregar npm global al PATH
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
print_status "npm configurado para instalaciones globales"

# Instalar Appium 1.x (más estable)
echo -e "${YELLOW}Instalando Appium 1.22.3...${NC}"
npm install -g appium@1.22.3
print_status "Appium 1.22.3 instalado"

# Instalar drivers de Appium
echo -e "${YELLOW}Instalando drivers de Appium...${NC}"
npm install -g appium-uiautomator2-driver
npm install -g appium-doctor
print_status "Drivers de Appium instalados"

# Configurar Android SDK
echo -e "${YELLOW}Configurando Android SDK...${NC}"
mkdir -p ~/Android/Sdk
cd ~/Android/Sdk

# Descargar Command Line Tools
wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
unzip -q commandlinetools-linux-*.zip
rm commandlinetools-linux-*.zip
mkdir -p cmdline-tools/latest
mv cmdline-tools/* cmdline-tools/latest/
rmdir cmdline-tools/tools 2>/dev/null || true

print_status "Android SDK instalado"

# Configurar variables de entorno
echo -e "${YELLOW}⚙Configurando variables de entorno...${NC}"
cat >> ~/.bashrc << 'EOF'

# Android SDK Configuration
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator

# Java Configuration
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Appium and NPM Configuration
export PATH=$PATH:$HOME/.npm-global/bin

# Ruby RVM Configuration
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
EOF

source ~/.bashrc
print_status "Variables de entorno configuradas"

# Aceptar licencias e instalar componentes de Android
echo -e "${YELLOW}Aceptando licencias de Android...${NC}"
yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses
print_status "Licencias aceptadas"

echo -e "${YELLOW}Instalando componentes de Android...${NC}"
$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager \
    "platform-tools" \
    "platforms;android-33" \
    "build-tools;33.0.0" \
    "emulator" \
    "system-images;android-33;google_apis;x86_64"
print_status "Componentes de Android instalados"

# Crear AVD para emulador (opcional)
echo -e "${YELLOW}Creando Android Virtual Device...${NC}"
echo "no" | $ANDROID_HOME/cmdline-tools/latest/bin/avdmanager create avd \
    -n pixel_android_33 \
    -k "system-images;android-33;google_apis;x86_64" \
    -d pixel_4
print_status "AVD creado: pixel_android_33"

# Instalar dependencias del proyecto
echo -e "${YELLOW}Instalando dependencias del proyecto...${NC}"
cd ~/Escritorio/test-ml-mobile-physical

if [ -f "Gemfile" ]; then
    bundle install
    print_status "Gemas Ruby instaladas"
else
    echo -e "${YELLOW}No se encontró Gemfile, creando uno básico...${NC}"
    cat > Gemfile << 'EOF'
source 'https://rubygems.org'

gem 'appium_lib', '~> 11.0'
gem 'cucumber', '~> 7.0'
gem 'rspec', '~> 3.8'
gem 'selenium-webdriver'
EOF
    bundle install
    print_status "Gemas Ruby básicas instaladas"
fi

# Verificar instalaciones
echo -e "${YELLOW}Verificando instalaciones...${NC}"
echo "Ruby: $(ruby -v)"
echo "Bundler: $(bundle -v)"
echo "Node.js: $(node -v)"
echo "npm: $(npm -v)"
echo "Appium: $(appium -v)"
echo "ADB: $(adb version | head -1)"
echo "Java: $(java -version 2>&1 | head -1)"

# Verificar con Appium Doctor
echo -e "${YELLOW}Ejecutando Appium Doctor...${NC}"
appium-doctor --android

echo -e "${GREEN}"
echo "=================================================="
echo "INSTALACIÓN COMPLETADA EXITOSAMENTE"
echo "=================================================="
echo ""
echo "Resumen de lo instalado:"
echo "   -Java JDK 8"
echo "   -Android SDK y herramientas"
echo "   -ADB y platform-tools"
echo "   -Ruby 3.2.5 con RVM"
echo "   -Node.js 18 y npm"
echo "   -Appium 1.22.3 con drivers"
echo "   -Dependencias del proyecto"
echo ""
echo "Para usar las herramientas, cierra y reabre la terminal"
echo "   o ejecuta: source ~/.bashrc"
echo ""
echo "Para verificar el dispositivo: adb devices"
echo "Para verificar Appium: appium-doctor --android"
echo -e "${NC}"