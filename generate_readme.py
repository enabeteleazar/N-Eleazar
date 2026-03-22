#!/usr/bin/env python3
import os
import random
from datetime import datetime
from github import Github
import subprocess

# ==========================
# CONFIGURATION
# ==========================
GITHUB_USERNAME = "enabeteleazar"  # ton nom d'utilisateur GitHub
GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")  # token personnel GitHub
README_PATH = "/mnt/usb-storage/N-Eleazar/README.md"
WORDS_FILE = "/mnt/usb-storage/N-Eleazar/words.txt"

if not GITHUB_TOKEN:
    raise Exception("Définis la variable d'environnement GITHUB_TOKEN !")

if not os.path.isfile(README_PATH):
    raise Exception(f"Le fichier {README_PATH} n'existe pas.")

if not os.path.isfile(WORDS_FILE):
    raise Exception(f"Le fichier {WORDS_FILE} n'existe pas.")

# ==========================
# Lire les mots depuis words.txt
# ==========================
with open(WORDS_FILE, "r", encoding="utf-8") as f:
    words = [line.strip() for line in f if line.strip()]

# ==========================
# Connexion à GitHub et récupération des projets
# ==========================
g = Github(GITHUB_TOKEN)
user = g.get_user(GITHUB_USERNAME)
repos = user.get_repos()

projects_md = "# Mes projets GitHub\n\nVoici la liste de mes projets avec une brève description :\n\n"

for repo in repos:
    # Ignore les forks si nécessaire
    if repo.fork:
        continue

    name = repo.name
    url = repo.html_url
    desc = repo.description or "Pas de description fournie."

    # Tenter d'obtenir la première ligne du README
    try:
        contents = repo.get_readme()
        readme_lines = contents.decoded_content.decode("utf-8").strip().splitlines()
        first_line = readme_lines[0] if readme_lines else ""
    except:
        first_line = ""

    # Combiner description GitHub + première ligne README
    if first_line and first_line not in desc:
        full_desc = f"{desc} — {first_line}"
    else:
        full_desc = desc

    projects_md += f"### [{name}]({url})\n> {full_desc}\n\n"

# ==========================
# Lire le README actuel et supprimer les 3 dernières lignes si possible
# ==========================
with open(README_PATH, "r", encoding="utf-8") as f:
    lines = f.readlines()

if len(lines) >= 3:
    lines = lines[:-3]  # supprime les 3 dernières lignes

# ==========================
# Ajouter le contenu généré des projets
# ==========================
lines.append("\n")
lines.append(projects_md)

# ==========================
# Ajouter date de mise à jour et mot aléatoire
# ==========================
now = datetime.now()
date_str = now.strftime("%A %d %B %Y")  # format français
# Pour afficher en français
try:
    import locale
    locale.setlocale(locale.LC_TIME, "fr_FR.UTF-8")
    date_str = now.strftime("%A %d %B %Y")
except:
    pass  # si locale français non dispo, reste en anglais

random_word = random.choice(words)
lines.append("\nDernière mise à jour le " + date_str + "\n")
lines.append(f"🤖 Ce README.md est mis à jour avec {random_word}.\n")

# ==========================
# Écrire le README
# ==========================
with open(README_PATH, "w", encoding="utf-8") as f:
    f.writelines(lines)

print(f"README mis à jour avec succès : {README_PATH}")

# ==========================
# Commit + push automatique
# ==========================
def git_command(cmd):
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result

try:
    # Vérifier si c'est un dépôt Git
    subprocess.run("git rev-parse --is-inside-work-tree", shell=True, check=True, stdout=subprocess.DEVNULL)
    # Ajouter et commit
    status = git_command("git status --porcelain").stdout.strip()
    if status:
        git_command("git add .")
        git_command('git commit -m "Mise à jour automatique README"')
        git_command("git push origin main")
        print("Modifications commitées et push effectués.")
    else:
        print("Aucune modification à commiter.")
except subprocess.CalledProcessError:
    print("Ce répertoire n'est pas un dépôt Git valide. Git non exécuté.")
