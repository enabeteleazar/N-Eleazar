#!/bin/bash

# Chemin absolu vers le fichier README.md
FILENAME="/mnt/usb-storage/N-Eleazar/README.md"

# Vérifier si le fichier README.md existe
if [[ ! -f $FILENAME ]]; then
    echo "Le fichier $FILENAME n'existe pas."
    exit 1
fi

# Vérifier si le fichier words.txt existe
WORDS_FILE="/mnt/usb-storage/N-Eleazar/words.txt"
if [[ ! -f $WORDS_FILE ]]; then
    echo "Le fichier $WORDS_FILE n'existe pas."
    exit 1
fi

# Lire les mots depuis le fichier words.txt dans un tableau
mapfile -t WORDS < "$WORDS_FILE"

# Compter le nombre de lignes dans le fichier README.md
NUM_LINES=$(wc -l < "$FILENAME")

# Vérifier si le fichier a moins de 3 lignes
if (( NUM_LINES < 3 )); then
    echo "Le fichier $FILENAME a moins de 3 lignes, impossible de supprimer les 3 dernières lignes."
    exit 1
fi

# Supprimer les 3 dernières lignes du fichier README.md
sed -i '$d' "$FILENAME"
sed -i '$d' "$FILENAME"
sed -i '$d' "$FILENAME"

# Définir la locale pour les jours de la semaine en français
export LC_TIME=fr_FR.UTF-8

# Ajouter "Dernière mise à jour le" suivi de la date actuelle en français
echo -n "Dernière mise à jour le " >> "$FILENAME"
date '+%A %e %B %Y' >> "$FILENAME"

echo "" >> "$FILENAME"

# Choisir un mot aléatoirement depuis le tableau WORDS
RANDOM_WORD=${WORDS[$RANDOM % ${#WORDS[@]}]}

# Ajouter la phrase avec le mot aléatoire
echo "🤖 Ce README.md est mis à jour avec $RANDOM_WORD." >> "$FILENAME"

echo "Mise à jour du fichier $FILENAME effectuée avec succès."

# Vérifier si nous sommes dans un dépôt Git valide
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    # Si oui, vérifier s'il y a des modifications dans le répertoire de travail
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
else
    # Si nous ne sommes pas dans un dépôt Git valide
    echo "Attention : ce répertoire n'est pas un dépôt Git valide. Aucune opération Git ne sera effectuée."
fi
