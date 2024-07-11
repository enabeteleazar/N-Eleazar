#!/bin/bash

# Nom du fichier en argument
FILENAME=README.md

# Vérifier si le fichier existe
if [[ ! -f $FILENAME ]]; then
    echo "Le fichier $FILENAME n'existe pas."
    exit 1
fi

# Vérifier si le fichier words.txt existe
WORDS_FILE="words.txt"
if [[ ! -f $WORDS_FILE ]]; then
    echo "Le fichier $WORDS_FILE n'existe pas."
    exit 1
fi

# Lire les mots depuis le fichier words.txt dans un tableau
mapfile -t WORDS < $WORDS_FILE

# Compter le nombre de lignes dans le fichier
NUM_LINES=$(wc -l < "$FILENAME")

# Vérifier si le fichier a moins de 3 lignes
if (( NUM_LINES < 3 )); then
    echo "Le fichier $FILENAME a moins de 3 lignes, impossible de supprimer les 3 dernières lignes."
    exit 1
fi

# Supprimer les 3 dernières lignes du fichier
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
