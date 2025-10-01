#!/bin/bash

echo "Probando actividad SplashActivity..."

# Cerrar app primero
adb shell am force-stop com.mercadolibre
sleep 2

# Abrir con la actividad correcta
echo "Abriendo: com.mercadolibre/.splash.SplashActivity"
adb shell am start -n "com.mercadolibre/.splash.SplashActivity" -a android.intent.action.MAIN -c android.intent.category.LAUNCHER

echo "Esperando 5 segundos..."
sleep 5

# Verificar actividad actual
echo "Actividad actual después de abrir:"
adb shell "dumpsys window windows | grep -E 'mCurrentFocus|mFocusedApp'"