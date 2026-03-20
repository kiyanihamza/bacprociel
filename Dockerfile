FROM ubuntu:22.04

# Éviter les questions interactives lors de l'installation
ENV DEBIAN_FRONTEND=noninteractive

# Installation des outils
RUN apt-get update && apt-get install -y \
    systemd \
    systemd-sysv \
    nginx \
    vim \
    procps \
    iproute2 \
    && apt-get clean

# --- SECTION SABOTAGE (6 ERREURS) ---

# 1. Erreur de syntaxe dans nginx.conf (worker_connexions au lieu de worker_connections)
RUN sed -i 's/worker_connections/worker_connexions/' /etc/nginx/nginx.conf

# 2. Faute de frappe sur le nom de l'utilisateur (www-data devient www-datu)
RUN sed -i 's/user www-data;/user www-datu;/' /etc/nginx/nginx.conf

# 3. Port non standard : Changement du port 80 par 8080
RUN sed -i 's/listen 80 default_server;/listen 8080 default_server;/' /etc/nginx/sites-available/default

# 4. Erreur de chemin : On pointe vers un mauvais répertoire racine (/var/www/htm au lieu de /var/www/html)
RUN sed -i 's/root \/var\/www\/html;/root \/var\/www\/htm;/' /etc/nginx/sites-available/default

# 5. Erreur de structure : Ajout d'une accolade fermante '}' parasite à la fin du fichier default
RUN echo "}" >> /etc/nginx/sites-available/default

# 6. Erreur de Permissions : On change le propriétaire et on retire les droits de lecture sur le dossier web
# On rend le dossier la propriété de 'root' et on met des droits 700 (seul root peut lire)
RUN chown -R root:root /var/www/html && chmod -R 700 /var/www/html

# --- FIN DU SABOTAGE ---

STOPSIGNAL SIGRTMIN+3
CMD ["/lib/systemd/systemd"]
