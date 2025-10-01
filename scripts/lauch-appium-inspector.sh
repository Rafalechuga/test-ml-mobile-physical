#!/bin/bash

echo "SESIÓN COMPLETA APPIUM - CORREGIDO"

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Configuración
APPIUM_PORT="4723"

cleanup() {
    echo -e "${YELLOW}🧹 Limpiando procesos...${NC}"
    pkill -f "appium" 2>/dev/null || true
    pkill -f "appium-inspector" 2>/dev/null || true
    exit 0
}
trap cleanup SIGINT

echo -e "${BLUE}Verificando entorno...${NC}"

# Verificar ADB
if ! command -v adb >/dev/null 2>&1; then
    echo -e "${RED}ADB no encontrado${NC}"
    exit 1
fi

# Verificar Appium
if ! command -v appium >/dev/null 2>&1; then
    echo -e "${RED}Appium no encontrado${NC}"
    exit 1
fi

# Verificar dispositivo
echo -e "${BLUE}Verificando dispositivo...${NC}"
if ! adb devices | grep -q "device$"; then
    echo -e "${RED}No hay dispositivos conectados${NC}"
    echo -e "${YELLOW}Conecta tu dispositivo y habilita Debugging USB${NC}"
    exit 1
fi

DEVICE=$(adb devices | grep "device$" | head -1 | cut -f1)
echo -e "${GREEN}Dispositivo detectado: $DEVICE${NC}"

# Paso 1: Iniciar servidor Appium
echo -e "${BLUE}Paso 1: Iniciando servidor Appium...${NC}"
appium \
    --log-level info \
    --relaxed-security \
    --allow-insecure adb_shell \
    --session-override \
    --port $APPIUM_PORT &
APPIUM_PID=$!

# Esperar que el servidor inicie
echo -e "${YELLOW}Esperando que Appium inicie (10 segundos)...${NC}"
sleep 10

# Verificar servidor
if curl -s http://localhost:$APPIUM_PORT/wd/hub/status >/dev/null; then
    echo -e "${GREEN}Appium Server funcionando en puerto $APPIUM_PORT${NC}"
else
    echo -e "${RED}Appium Server no responde${NC}"
    exit 1
fi

# Paso 2: Iniciar Appium Inspector - CORREGIDO
echo -e "${BLUE}Paso 2: Iniciando Appium Inspector...${NC}"
cd ~/Apps/appium-inspector

# BUSCAR EJECUTABLE - MÚLTIPLES ESTRATEGIAS
EXECUTABLE=""

# Estrategia 1: Buscar el binario en el directorio con espacio
if [ -f "./Appium Inspector-2025.8.2-linux-x64/appium-inspector" ]; then
    EXECUTABLE="./Appium Inspector-2025.8.2-linux-x64/appium-inspector"
    echo -e "${GREEN}Encontrado ejecutable en directorio con espacio${NC}"

# Estrategia 2: Buscar cualquier archivo appium-inspector
elif INSPECTOR_BIN=$(find . -name "appium-inspector" -type f 2>/dev/null | head -1); then
    EXECUTABLE="$INSPECTOR_BIN"
    echo -e "${GREEN}Encontrado ejecutable: $INSPECTOR_BIN${NC}"

# Estrategia 3: Buscar AppImage
elif INSPECTOR_APPIMAGE=$(ls -t Appium-Inspector-*.AppImage 2>/dev/null | head -1); then
    EXECUTABLE="./$INSPECTOR_APPIMAGE"
    echo -e "${GREEN}Encontrado AppImage: $INSPECTOR_APPIMAGE${NC}"

# Estrategia 4: Buscar cualquier ejecutable
else
    EXECUTABLE=$(find . -type f -executable -name "*appium*" -o -name "*inspector*" 2>/dev/null | head -1)
    if [ -n "$EXECUTABLE" ]; then
        echo -e "${GREEN}Encontrado ejecutable genérico: $EXECUTABLE${NC}"
    fi
fi

# EJECUTAR APPIUM INSPECTOR
if [ -n "$EXECUTABLE" ] && [ -f "$EXECUTABLE" ]; then
    echo -e "${GREEN}Ejecutando: $EXECUTABLE${NC}"
    chmod +x "$EXECUTABLE"
    
    # Verificar arquitectura
    echo -e "${YELLOW}Verificando arquitectura...${NC}"
    file "$EXECUTABLE"
    
    # Ejecutar
    "$EXECUTABLE" &
    INSPECTOR_PID=$!
    echo -e "${GREEN}Appium Inspector iniciado (PID: $INSPECTOR_PID)${NC}"
    
else
    echo -e "${YELLOW}Appium Inspector no encontrado automáticamente${NC}"
    echo -e "${YELLOW}Buscando manualmente...${NC}"
    find . -type f \( -name "*appium*" -o -name "*inspector*" \) 2>/dev/null
    
    echo -e "${YELLOW}Opciones manuales:${NC}"
    echo -e "${YELLOW}   1. Ejecuta desde el escritorio: Appium Inspector${NC}"
    echo -e "${YELLOW}   2. Ejecuta manualmente: cd ~/Apps/appium-inspector && ./Appium\\\\ Inspector-2025.8.2-linux-x64/appium-inspector${NC}"
    echo -e "${YELLOW}   3. Usa versión web: https://inspector.appiumpro.com/${NC}"
fi

# Mostrar información de configuración
echo -e "${GREEN}"
echo "=================================================="
echo "CONFIGURACIÓN PARA APPIUM INSPECTOR"
echo "=================================================="
echo ""
echo "Una vez que Appium Inspector se abra:"
echo ""
echo "1. Configuración de conexión:"
echo "   - Remote Host: 127.0.0.1"
echo "   - Remote Port: $APPIUM_PORT"
echo "   - Remote Path: /wd/hub"
echo ""
echo "2. Capabilities (copia y pega):"
cat << EOF
{
  "platformName": "Android",
  "appium:platformVersion": "15",
  "appium:deviceName": "SM_A155M",
  "appium:automationName": "UiAutomator2",
  "appium:appPackage": "com.mercadolibre",
  "appium:appActivity": ".splash.SplashActivity",
  "appium:udid": "RF8X10AAL8X",
  "appium:noReset": false,
  "appium:autoGrantPermissions": true,
  "appium:newCommandTimeout": 300
}
EOF
echo ""
echo "3. Click 'Start Session'"
echo ""
echo -e "${NC}"

# Información adicional de debugging
echo -e "${YELLOW}Información de debugging:${NC}"
echo -e "${YELLOW}   - Appium PID: $APPIUM_PID${NC}"
if [ -n "$INSPECTOR_PID" ]; then
    echo -e "${YELLOW}   - Inspector PID: $INSPECTOR_PID${NC}"
fi
echo -e "${YELLOW}   - Servidor: http://localhost:$APPIUM_PORT/wd/hub/status${NC}"

echo -e "${YELLOW}Sesión iniciada. Revisa si Appium Inspector se abrió...${NC}"
echo -e "${YELLOW}Si no se abre, usa una de las opciones manuales mencionadas${NC}"
echo -e "${YELLOW}Presiona Ctrl+C para cerrar todo cuando termines${NC}"

# Verificar estado cada 5 segundos
while true; do
    if ! ps -p $APPIUM_PID > /dev/null 2>&1; then
        echo -e "${RED}Appium Server se detuvo${NC}"
        break
    fi
    if [ -n "$INSPECTOR_PID" ] && ! ps -p $INSPECTOR_PID > /dev/null 2>&1; then
        echo -e "${YELLOW}Appium Inspector se cerró${NC}"
    fi
    sleep 5
done

# Limpieza final
cleanup