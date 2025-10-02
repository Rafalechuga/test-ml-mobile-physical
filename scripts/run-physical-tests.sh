#!/bin/bash

echo "=== PRUEBAS EN ANDROID ==="

# Detectar el primer dispositivo conectado
DEVICE_UDID=$(adb devices | grep -w "device" | grep -v "List" | awk '{print $1}')

if [ -z "$DEVICE_UDID" ]; then
  echo "ERROR: No se detectó ningún dispositivo Android conectado"
  echo "Conecta un dispositivo y habilita Debugging USB"
  exit 1
fi

echo "Dispositivo detectado: $DEVICE_UDID"

# Obtener modelo y versión Android
DEVICE_MODEL=$(adb -s $DEVICE_UDID shell getprop ro.product.model | tr -d '\r')
PLATFORM_VERSION=$(adb -s $DEVICE_UDID shell getprop ro.build.version.release | tr -d '\r')

echo "Modelo: $DEVICE_MODEL"
echo "Versión Android: $PLATFORM_VERSION"

# Verificar App instalada
echo "Verificando Mercado Libre instalado..."
if adb -s $DEVICE_UDID shell pm list packages | grep -q "com.mercadolibre"; then
    echo "Mercado Libre está instalado"
    
    # Obtener versión
    VERSION=$(adb -s $DEVICE_UDID shell dumpsys package com.mercadolibre | grep versionName | head -1 | cut -d= -f2)
    echo "Versión de Mercado Libre: $VERSION"
else
    echo "Mercado Libre no está instalado"
    exit 1
fi

# Verificar permisos
echo "Verificando permisos..."
adb -s $DEVICE_UDID shell pm grant com.mercadolibre android.permission.ACCESS_FINE_LOCATION 2>/dev/null || true
adb -s $DEVICE_UDID shell pm grant com.mercadolibre android.permission.CAMERA 2>/dev/null || true

# Limpiar procesos anteriores
echo "Limpiando procesos anteriores..."
pkill -f "appium" 2>/dev/null || true
sleep 3

# Iniciar Appium
echo "Iniciando Appium..."
appium --log-level info --relaxed-security --allow-insecure adb_shell --session-override &
APPIUM_PID=$!

echo "Esperando que Appium inicie (15 segundos)..."
sleep 15

# Verificar Appium
if curl -s http://localhost:4723/wd/hub/status >/dev/null; then
    echo "Appium funcionando en puerto 4723"
else
    echo "Appium no responde, reiniciando..."
    kill $APPIUM_PID 2>/dev/null
    sleep 2
    appium --log-level info --relaxed-security &
    APPIUM_PID=$!
    sleep 10
fi

# Instalar gemas si es necesario
echo "Verificando gemas..."
if [ ! -f "Gemfile.lock" ]; then
    bundle install
fi

# Exportar variables para que env.rb las use
export DEVICE_UDID
export DEVICE_NAME="$DEVICE_MODEL"
export PLATFORM_VERSION

# Ejecutar pruebas
echo "Ejecutando pruebas en dispositivo real..."
echo "================================================"

bundle exec cucumber features/search_and_filters.feature

TEST_RESULT=$?

echo "================================================"

# Resultado final
if [ $TEST_RESULT -eq 0 ]; then
    echo "¡TODAS LAS PRUEBAS PASARON EN EL DISPOSITIVO!"
else
    echo "Algunas pruebas fallaron"
fi

# Limpiar
echo "Limpiando..."
kill $APPIUM_PID 2>/dev/null

exit $TEST_RESULT

