# Créer un caméra wifi pour 15€

## Liste achat sur Aliexpress 

## Configurer la caméra avec Tasmota

télécharger tasmota32-webcam.bin sur <http://ota.tasmota.com/tasmota32/release/>
télécharger le driver CH340 >https://www.wch.cn/downloads/CH341SER_ZIP.html>

flacher la carte avec <https://github.com/Jason2866/ESP_Flasher/releases/tag/v.1.4.1>

avec votre téléphone connecté vous au réseaux wifi indiqué puis taper l'adress IP fourni dans votre navigateur

ensuite sur l'interface de Tasmota configurer votre réseaux wifi.

Dans les logs sur le logiciel ESP_Flasher, il vous indiquera s'il a réussi à se connecter correctement. 

Vous pouvez ensuite sur votre PC accèder à la nouvelle adresse IP fourni.

Sur l'interface de tasmota aller dans configuration=>auto-configuration, selectionner Ai-Thinkercam puis cliquer sur Apply