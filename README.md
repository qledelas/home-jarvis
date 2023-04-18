# home-jarvis

Installation domotique sur Raspberry PI

![image](https://user-images.githubusercontent.com/48330020/231480806-cca2138e-82c3-4636-a959-6ef20c072cfc.png)

## Raspberry PI

### Installation de l'OS

Suivre la documentation pour installer l'OS raspberry pi light <https://www.raspberrypi.com/documentation/computers/getting-started.html#installing-the-operating-system>

Lien vers les images : <https://www.raspberrypi.com/software/operating-systems/#raspberry-pi-os-32-bit>

## Home assistant

### Installation via docker

Mettre en place un docker compose en suivant la documentation <https://www.home-assistant.io/installation/raspberrypi#install-home-assistant-container>

Attention à bien ajouter les connecteurs USB (zigbee, RFlink) <https://www.home-assistant.io/installation/raspberrypi#exposing-devices>

### Configuration

Première configuration : <https://www.home-assistant.io/getting-started/onboarding>

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
