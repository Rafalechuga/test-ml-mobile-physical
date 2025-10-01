#!/bin/bash

echo "=== INSTALACIÓN DE APPIUM INSPECTOR ==="

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN} $1${NC}"
    else
        echo -e "${RED} $1${NC}"
    fi
}

# Crear directorio
mkdir -p ~/Apps/appium-inspector
cd ~/Apps/appium-inspector

echo -e "${YELLOW}Buscando la última versión de Appium Inspector...${NC}"

# Determinar arquitectura correcta
ARCH=$(uname -m)
echo -e "${YELLOW}Arquitectura del sistema: $ARCH${NC}"

# Mapear arquitectura a patrones de búsqueda
case $ARCH in
    "x86_64")
        ARCH_PATTERNS=("x64" "x86_64" "amd64")
        ;;
    "aarch64"|"arm64")
        ARCH_PATTERNS=("arm64" "aarch64")
        ;;
    "i386"|"i686")
        ARCH_PATTERNS=("i386" "i686" "x86")
        ;;
    *)
        ARCH_PATTERNS=("x64" "x86_64")  # Por defecto, intentar x86_64
        echo -e "${YELLOW}Arquitectura $ARCH no reconocida, intentando x86_64${NC}"
        ;;
esac

# Obtener la última release
API_RESPONSE=$(curl -s https://api.github.com/repos/appium/appium-inspector/releases/latest)
LATEST_TAG=$(echo "$API_RESPONSE" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_TAG" ]; then
    echo -e "${RED}No se pudo obtener la última versión${NC}"
    echo -e "${YELLOW}Visitando manualmente: https://github.com/appium/appium-inspector/releases${NC}"
    exit 1
fi

echo -e "${YELLOW}Versión encontrada: $LATEST_TAG${NC}"

# Buscar archivos descargables para la arquitectura correcta
DOWNLOAD_URL=""
for pattern in "${ARCH_PATTERNS[@]}"; do
    echo -e "${YELLOW}Buscando para arquitectura: $pattern${NC}"
    URL=$(echo "$API_RESPONSE" | grep "browser_download_url" | grep -i "linux" | grep -i "$pattern" | sed -E 's/.*"([^"]+)".*/\1/' | head -1)
    
    if [ -n "$URL" ]; then
        DOWNLOAD_URL="$URL"
        echo -e "${GREEN}Encontrado: $URL${NC}"
        break
    fi
done

# Si no encontramos por arquitectura específica, buscar cualquier Linux
if [ -z "$DOWNLOAD_URL" ]; then
    echo -e "${YELLOW}No se encontró versión específica, buscando cualquier versión Linux...${NC}"
    DOWNLOAD_URL=$(echo "$API_RESPONSE" | grep "browser_download_url" | grep -i "linux" | grep -v "arm64" | sed -E 's/.*"([^"]+)".*/\1/' | head -1)
fi

# Si todavía no encontramos, mostrar todas las opciones
if [ -z "$DOWNLOAD_URL" ]; then
    echo -e "${RED}No se encontraron archivos para Linux${NC}"
    echo -e "${YELLOW}Archivos disponibles:${NC}"
    echo "$API_RESPONSE" | grep "browser_download_url" | sed -E 's/.*"([^"]+)".*/\1/'
    exit 1
fi

FILENAME=$(basename "$DOWNLOAD_URL")
echo -e "${YELLOW}Descargando: $FILENAME${NC}"
echo -e "${YELLOW}Desde: $DOWNLOAD_URL${NC}"

# Descargar
wget -q --show-progress "$DOWNLOAD_URL"
print_status "Descargado: $FILENAME"

# Verificar que el archivo se descargó correctamente
if [ ! -f "$FILENAME" ]; then
    echo -e "${RED}El archivo no se descargó correctamente${NC}"
    exit 1
fi

# Procesar según la extensión
echo -e "${YELLOW}🔧 Procesando archivo...${NC}"

if [[ "$FILENAME" == *.tar.gz ]]; then
    echo -e "${YELLOW}Extrayendo tar.gz...${NC}"
    tar -xzf "$FILENAME"
    print_status "Archivo extraído"
    
    # Buscar el ejecutable
    EXECUTABLE=$(find . -name "Appium-Inspector" -type f | head -1)
    if [ -z "$EXECUTABLE" ]; then
        EXECUTABLE=$(find . -name "appium-inspector" -type f | head -1)
    fi
    
elif [[ "$FILENAME" == *.AppImage ]]; then
    echo -e "${YELLOW}Configurando AppImage...${NC}"
    chmod +x "$FILENAME"
    EXECUTABLE="./$FILENAME"
    print_status "AppImage configurado"
    
elif [[ "$FILENAME" == *.deb ]]; then
    echo -e "${YELLOW}Instalando paquete .deb...${NC}"
    sudo dpkg -i "$FILENAME" || sudo apt-get install -f -y
    EXECUTABLE="appium-inspector"
    print_status "Paquete .deb instalado"
    
elif [[ "$FILENAME" == *.zip ]]; then
    echo -e "${YELLOW}Extrayendo zip...${NC}"
    unzip -q "$FILENAME"
    print_status "Archivo extraído"
    EXECUTABLE=$(find . -type f -executable | head -1)
    
else
    echo -e "${YELLOW}Intentando extraer archivo genérico...${NC}"
    tar -xzf "$FILENAME" 2>/dev/null || unzip -q "$FILENAME" 2>/dev/null || {
        echo -e "${RED}No se pudo extraer el archivo${NC}"
        echo -e "${YELLOW}El archivo podría ser un binario directo${NC}"
        # Intentar usar el archivo directamente
        if [ -x "$FILENAME" ]; then
            EXECUTABLE="./$FILENAME"
        else
            chmod +x "$FILENAME"
            EXECUTABLE="./$FILENAME"
        fi
    }
    if [ -z "$EXECUTABLE" ]; then
        EXECUTABLE=$(find . -type f -executable | head -1)
    fi
fi

# Verificar que tenemos un ejecutable
if [ -n "$EXECUTABLE" ] && [ -f "$EXECUTABLE" ]; then
    echo -e "${YELLOW}Ejecutable encontrado: $EXECUTABLE${NC}"
    chmod +x "$EXECUTABLE"
    
    # Verificar que es realmente ejecutable
    if [ -x "$EXECUTABLE" ]; then
        echo -e "${GREEN}Ejecutable verificado${NC}"
    else
        echo -e "${RED}El archivo no es ejecutable${NC}"
        exit 1
    fi
    
    # Crear acceso directo
    echo -e "${YELLOW}Creando acceso directo...${NC}"
    cat > ~/Desktop/Appium-Inspector.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Appium Inspector
Comment=Appium Inspector for Mobile App Testing
Exec=$PWD/$EXECUTABLE
Icon=appium
Categories=Development;
Terminal=false
EOF
    
    chmod +x ~/Desktop/Appium-Inspector.desktop
    print_status "Acceso directo creado en el escritorio"
    
else
    echo -e "${YELLOW}Buscando ejecutable manualmente...${NC}"
    find . -type f -executable | while read file; do
        echo "  $file"
    done
    
    echo -e "${YELLOW}Ejecuta manualmente el archivo apropiado${NC}"
    # Si no encontramos ejecutable, salir con error
    exit 1
fi

# Mostrar estructura de archivos
echo -e "${YELLOW}Estructura de archivos:${NC}"
ls -la

# Verificar el tipo de archivo del ejecutable
echo -e "${YELLOW}Verificando tipo de archivo ejecutable:${NC}"
file "$EXECUTABLE"

echo -e "${GREEN}"
echo "=================================================="
echo "APPIUM INSPECTOR INSTALADO"
echo "=================================================="
echo ""
echo "Ubicación: ~/Apps/appium-inspector/"
echo "Acceso directo: ~/Desktop/Appium-Inspector.desktop"
echo "Ejecutable: $EXECUTABLE"
echo ""
echo "Para usar:"
echo "   1. Conecta tu dispositivo Android"
echo "   2. Ejecuta: appium --relaxed-security"
echo "   3. Abre Appium Inspector desde el escritorio"
echo "   4. Configura las capabilities:"
echo ""
echo "   Platform Name: Android"
echo "   Platform Version: 15"
echo "   Device Name: SM_A155M"
echo "   Automation Name: UiAutomator2"
echo "   App Package: com.mercadolibre"
echo "   App Activity: .splash.SplashActivity"
echo "   UDID: RF8X10AAL8X"
echo ""
echo -e "${NC}"