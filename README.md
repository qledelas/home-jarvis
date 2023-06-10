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
## Home assistant

### Installation via docker

Mettre en place un docker compose en suivant la documentation <https://www.home-assistant.io/installation/raspberrypi#install-home-assistant-container>

Attention à bien ajouter les connecteurs USB (zigbee, RFlink) <https://www.home-assistant.io/installation/raspberrypi#exposing-devices>

### Configuration

Première configuration : <https://www.home-assistant.io/getting-started/onboarding>

### Connection à Google Home

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

## Accéder au système depuis internet

Afin d'accéder à vos différents outils depuis interne, vous aller devoir configurer votre BOX. 

### DyDNS
Tous d'abord il vous faut soit un IP fix, soit un nom de domaine dynamique lié à l'IP de votre Box. 
Vous pouvez utiliser le service https://www.noip.com/ par exemple qui est gratuit moyenne une validation tous les mois. 
Une fois votre Dynamic DNS créé vous pouvez renseigner les informations dans votre Box, section DynDNS.
Par exemple : 
![Screenshot 2023-05-24 11 13 27](https://github.com/qledelas/home-jarvis/assets/48330020/fae33371-d954-4c05-93fd-605b4d9e1412)

### règle NAT
Il faut ensuite indiqué à votre box vers quelle IP elle doit rediriger le traffic utilisant tel ou tel port.
Rendez vous dans la section NAT :
![Screenshot 2023-05-24 11 22 00](https://github.com/qledelas/home-jarvis/assets/48330020/641b6409-7651-4e0e-a037-5c016acd1d4a)
