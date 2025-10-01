#!/bin/bash

echo "=== DEPURADOR AUTOMÁTICO PARA PRUEBAS MOBILE ==="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para imprimir con color
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 1. Limpiar procesos
print_status "Limpiando procesos..."
sudo pkill -f adb
sudo pkill -f appium
sudo pkill -f "node.*appium"

# 2. Liberar puertos
print_status "Liberando puertos..."
sudo fuser -k 4723/tcp 2>/dev/null || true
sudo fuser -k 5037/tcp 2>/dev/null || true

# 3. Reiniciar servicios USB
print_status "Reiniciando servicios USB..."
sudo service udev restart
sudo modprobe -r usbserial 2>/dev/null || true
sudo modprobe usbserial 2>/dev/null || true

# 4. Reiniciar ADB
print_status "Reiniciando ADB..."
adb kill-server
sleep 2
adb start-server
sleep 3

# 5. Verificar estado
print_status "Verificando estado final..."
echo "--- Dispositivos ADB:"
adb devices

echo "--- Puertos en uso:"
netstat -tulpn | grep -E ":(4723|5037)" || echo "Puertos libres"

echo "--- Procesos activos:"
pgrep -l adb || echo "No hay procesos ADB"
pgrep -l node || echo "No hay procesos Node"

print_status "Depuración completada. Ejecuta el script de pruebas nuevamente."
