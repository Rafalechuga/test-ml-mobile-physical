#!/bin/bash

echo "Buscando actividad principal de Mercado Libre..."

# Cerrar la app primero
adb shell am force-stop com.mercadolibre
sleep 2

# Abrir la app
adb shell monkey -p com.mercadolibre -c android.intent.category.LAUNCHER 1
sleep 5

# Capturar la actividad actual
echo "Actividad actual:"
adb shell "dumpsys window windows | grep -E 'mCurrentFocus|mFocusedApp'"

echo ""
echo "Actividades MAIN disponibles:"
adb shell dumpsys package com.mercadolibre | grep -B5 -A5 "android.intent.category.LAUNCHER"

echo ""
echo "Todas las actividades:"
adb shell dumpsys package com.mercadolibre | grep "com.mercadolibre" | grep "Activity"
