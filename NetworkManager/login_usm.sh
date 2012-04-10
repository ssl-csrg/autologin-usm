#!/bin/bash

# Script de conección a la red USM Santiago San Joaquín
# Pablo Albornoz, 2012. (pablo@cronobit.net).
# github.com/Bhran/AutoLoginUSM

# Completa esta información
USERNAME=""
PASSWORD=""

USERNAMEDI=""
PASSWORDDI=""

# Este script fue escrito con la intención de trabajar con NetworkManager
# Para ingresar automáticamente cuando te conectes, guarda este
# archivo en /etc/NetworkManager/dispatcher.d/login_usm
# luego escribe sudo chmod u+x /etc/NetworkManager/dispatcher.d/login_usm

# Si haces alguna modificación a partir de este punto, porfavor
# no dudes en compartirla :)

CURRENT_SSID=`iwconfig wlan0 | grep ESSID | cut -d \" -f 2`

NMP=`pgrep nm-applet`

while [ -z "$NMP" ]
do
	sleep 3
	NMP=`preg nm-applet`
done

if [ `echo $CURRENT_SSID | grep usm_` ]
then
	curl --insecure -d username=$USERNAME%40alumnos.usm.cl -d password=$PASSWORD -d buttonClicked=4 https://1.1.1.1/login.html > /dev/null
	zenity --notification --text="Ingresaste con éxito a la red USM" &
#Esta parte aún no funciona, pero está aquí para demostrar el concepto
elif [ `echo $CURRENT_SSID` == "di" ]
then
	curl -d auth_user=$USERNAMEDI -d auth_pass=$PASSWORDDI http://10.6.43.2:8000/
	zenity --notification --text="Ingresaste con éxito a la red del Departamento de Informática" &
fi

