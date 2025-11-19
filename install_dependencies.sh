#!/bin/bash

echo "🔧 Installation des dépendances Flutter..."
echo ""

cd /Users/chloe2/Documents/mds2/flutter/nomos_app

echo "📦 Exécution de flutter pub get..."
flutter pub get

echo ""
echo "✅ Installation terminée !"
echo ""
echo "🚀 Pour lancer l'application :"
echo "   flutter run"
echo ""
echo "📝 N'oubliez pas d'ajouter les permissions pour la caméra et la galerie !"
echo "   Voir le fichier FIX_IMAGE_PICKER_ERROR.md"

