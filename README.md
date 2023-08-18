# home-jarvis

Installation domotique sur Raspberry PI

![image](https://user-images.githubusercontent.com/48330020/231480806-cca2138e-82c3-4636-a959-6ef20c072cfc.png)

## Raspberry PI

### Installation de l'OS

Suivre la documentation pour installer l'OS raspberry pi light <https://www.raspberrypi.com/documentation/computers/getting-started.html#installing-the-operating-system>

Installer Raspberry PI Imager, selectionner une image sans Desktop, puis dans les options avancé activé la connection ssh et votre connection Wifi. 
Enfin lancé l'ecriture sur votre carte SD.

Une fois l'écriture terminé, inséret la carte SD dans votre RasPI puis branché le au secteur. 
Patiente quelque seconde, vous devrier voir votre RasPI se connecter a votre Wifi, vous aller alors pouvoir récuper son adresse IP.
Ensuite connecté vous à votre RasPI par ssh. 

```bash
ssh mon_user@mon_ip
```

## Docker

Tous les outils serons installer via docker compose. La première étape est donc d'installer docker. 
Suivre les étapes suivante => <https://docs.docker.com/engine/install/debian/#install-using-the-repository>

Puis suivre les étapes suivante pour lancer docker en non root => <https://docs.docker.com/engine/install/linux-postinstall/>

Et enfin suivre ces étapes pour que docker démarre automatiquement => <https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot-with-systemd>

## Home assistant

### Installation via docker

Dans le fichier docker-compose.yml de se projet vous trouverez qui permet de démarrer homeassisant core.
Attention à bien ajouter les vos connecteurs USB si vous en avez (zigbee, RFlink). 
Pour avoir la liste des périphérique usb connecté utilisé la commande : 

```bash
sudo blkid
```

Documentation Officiel 
- <https://www.home-assistant.io/installation/raspberrypi#install-home-assistant-container>
- <https://www.home-assistant.io/installation/raspberrypi#exposing-devices>

### Configuration

Pour le premier démarrage de homeassistant vous pouvez suivrer les étapes du tuto : <https://www.home-assistant.io/getting-started/onboarding>
Accéder au site via l'IP de votre raspberry pi <http://192.168.0.x:8123>

### Ajout du https

Par default homeassistant est accessible en http avec le port 8123. Pour certain cas ( comme la connection à google home ),
il doit être exposé sur internet en https.
Tous d'abord rediriger via votre box le port 80 et 443 vers l'ip de votre raspberry pi. cf
[Accéder au système depuis interne](#accéder-au-système-depuis-internet)

Ensuite suivre les étapes suivantes :

1. Ajouté à votre docker-compose le service swag ( cf docker-compose.yml du projet).
2. Modifier le fichier swag/homeassistant.subdomain.conf pour mettre votre nom de domaine et l'ip local de votre raspberry.
3. Ajouter ces paramêtres à votre fichier de homeassisant/configuration.yml

```yaml
homeassistant:
  external_url: https://MON-NOM-DE-DOMAINE
#  internal_url: "http://MON-NOM-DE-DOMAINE:8123"

http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 192.168.0.0/24
    - 172.18.0.0/24
```

4. redémarré homeassistant puis démarrer le conteneur swag. 

```bash
docker compose restart homeassistant
docker compose start swag

<https://community.home-assistant.io/t/remote-access-with-docker/314345>
```

### Connection à Google Home

Prérequis : homeassistant doit être accessible en https depuis internet. 
Suivre le tuto : https://www.home-assistant.io/integrations/google_assistant/#manual-setup

## Zigbee to Mqtt

### Installation via docker

Installer via docker-compose : <https://www.zigbee2mqtt.io/guide/getting-started>

### Ajout à Home assistant

Ajout de zigbeeToMQtt : <https://github.com/zigbee2mqtt/hassio-zigbee2mqtt#installation>

## RFlink

### Contruire le connecteur

tuto pas à pas : <https://opendomotech.com/fabriquer-rflink-alternative-diy-du-rfxcom>

### Ajout à Home assistant

Ajout de RFlink : <https://www.home-assistant.io/integrations/rflink/>

## NAS - SMB

### Installation

Installer openmediavault via : <https://docs.openmediavault.org/en/stable/installation/on_debian.html>

Puis suivre les étapes de : <https://www.raspberrypi.com/tutorials/nas-box-raspberry-pi-tutorial/#installing-openmediavault>

## Transmission

### Installation via docker

Installer via docker-composer : <https://hub.docker.com/r/linuxserver/transmission>

### Configuration du routeur

## Plex

### Connnection au SMB

### Configuration du routeur

## Video surveillance

Afin de mettre en place un système de vidéo surveillance nous allons utiliser motioneye. 

Il va permettre de se connecter à plusieur caméra et de gérer la détection de mouvement. 

### Installation via Docker

Installer via docker-compose (cf fichier docker-compose.yml).

Puis accéder à http://192.168.0.x:8765/

### Ajout à Home assistant

Voici les étapes à suivre pour ajouter vos caméras dans Home assistant :

1. Dans les integrations ajouter motioneye avec admin et user comme utilisateur (laisser mdp à vide).
2. Dans les automations y créer une nouvelle qui se base sur un webhook. Il faut alors configurer ce webhook dans motioneye (onglet motion detection notification)
L'action pourra être par exemple d'envoyer une notification.

## Accéder au système depuis internet

Afin d'accéder à vos différents outils depuis interne, vous aller devoir configurer votre BOX. 

### DyDNS
Tous d'abord il vous faut soit une IP fix, soit un nom de domaine dynamique lié à l'IP de votre Box. 
Vous pouvez utiliser le service https://www.noip.com/ par exemple qui est gratuit moyennenent une validation tous les mois. 
Une fois votre Dynamic DNS créé vous pouvez renseigner les informations dans votre Box, section DynDNS.
Par exemple : 
![Screenshot 2023-05-24 11 13 27](https://github.com/qledelas/home-jarvis/assets/48330020/fae33371-d954-4c05-93fd-605b4d9e1412)

### règle NAT
Il faut ensuite indiqué à votre box vers quelle IP elle doit rediriger le traffic utilisant tel ou tel port.
Rendez vous dans la section NAT :
![Screenshot 2023-05-24 11 22 00](https://github.com/qledelas/home-jarvis/assets/48330020/641b6409-7651-4e0e-a037-5c016acd1d4a)
