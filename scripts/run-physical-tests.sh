#!/bin/bash

echo "=== PRUEBAS EN SAMSUNG A15 (ANDROID 15) ==="

# Verificar conexión ADB
echo "Verificando conexión con Samsung A15..."
adb devices

# Verificar específicamente nuestro dispositivo
if ! adb devices | grep -q "RF8X10AAL8X"; then
    echo "ERROR: Samsung A15 no detectado"
    echo "Por favor:"
    echo "1. Conecta el dispositivo via USB"
    echo "2. Habilita Debugging USB en Opciones de desarrollador"
    echo "3. Acepta el diálogo de confianza en el dispositivo"
    echo "4. Verifica que el cable USB permite transferencia de datos"
    exit 1
fi

echo "Samsung A15 detectado: RF8X10AAL8X"

# Verificar App instalada
echo "Verificando Mercado Libre instalado..."
if adb shell pm list packages | grep -q "com.mercadolibre"; then
    echo "Mercado Libre está instalado"
    
    # Obtener versión
    VERSION=$(adb shell dumpsys package com.mercadolibre | grep versionName | head -1 | cut -d= -f2)
    echo "Versión de Mercado Libre: $VERSION"
else
    echo "Mercado Libre no está instalado"
    exit 1
fi

# Verificar permisos
echo "Verificando permisos..."
adb shell pm grant com.mercadolibre android.permission.ACCESS_FINE_LOCATION 2>/dev/null || true
adb shell pm grant com.mercadolibre android.permission.CAMERA 2>/dev/null || true

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
    echo "Appium no responde"
    echo "Intentando reiniciar..."
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

# Ejecutar pruebas
echo "Ejecutando pruebas en dispositivo real..."
echo "================================================"

bundle exec cucumber features/search.feature
TEST_RESULT=$?

echo "================================================"

# Resultado final
if [ $TEST_RESULT -eq 0 ]; then
    echo "¡TODAS LAS PRUEBAS PASARON EN EL DISPOSITIVO<!"
else
    echo "Algunas pruebas fallaron"
fi

# Limpiar
echo "Limpiando..."
kill $APPIUM_PID 2>/dev/null

exit $TEST_RESULT
