#!/bin/bash

# Chemin vers le script de mise à jour
UPDATE_SCRIPT="./update_file.sh"

# Exécuter le script de mise à jour
echo "Exécution du script de mise à jour..."
$UPDATE_SCRIPT

# Vérifier s'il y a des modifications
if [[ $(git status --porcelain) ]]; then
    # Il y a des modifications à commiter
    echo "Des modifications détectées. Commit et push en cours..."
    
    # Ajouter tous les fichiers modifiés au staging
    git add .

    # Commit avec un message
    git commit -m "Mise à jour automatique via script"

    # Push vers le repository distant (origin)
    git push origin main  # Assurez-vous de remplacer 'main' par votre branche principale si elle est différente
else
    # Aucune modification détectée
    echo "Aucune modification à commiter. Fin du script."
fi
