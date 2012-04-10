#!/bin/bash

# Script de conección a la red USM Santiago San Joaquín
# Pablo Albornoz, 2012. (pablo@cronobit.net).
# github.com/Bhran/AutoLoginUSM

# Completa esta información
USM_USER=""
USM_PASS=""

DI_USER=""
DI_PASS=""

# Este script fue escrito con la intención de trabajar con NetworkManager
# Pero también funciona corriendolo de forma manual.

# Para ingresar automáticamente cuando te conectes, guarda este
# archivo en /etc/NetworkManager/dispatcher.d/login_usm
# luego escribe sudo chmod u+x /etc/NetworkManager/dispatcher.d/login_usm

# Si haces alguna modificación a partir de este punto, porfavor
# no dudes en compartirla :)

CURRENT_SSID=`iwconfig wlan0 | grep ESSID | cut -d \" -f 2`

NM_PID=`pgrep nm-applet`

while [ -z "$NM_PID" ]
do
	sleep 3
	NM_PID=`pgrep nm-applet`
done

ZENITY=`which zenity`

if [ `echo $CURRENT_SSID | grep usm_` ]
then
	curl --insecure -d username=$USM_USER%40alumnos.usm.cl -d password=$USM_PASS -d buttonClicked=4 https://1.1.1.1/login.html > /dev/null
	$ZENITY --notification --text="Ingresaste con éxito a la red USM" &
# Esta parte aún no funciona, pero está aquí para demostrar el concepto
# hasta que pueda descubrir como pasar por el formulario del DI.
elif [ "$CURRENT_SSID" == "di" ]
then
	curl -d auth_user=$DI_USER -d auth_pass=$DI_PASS http://10.6.43.2:8000/
	$ZENITY --notification --text="Ingresaste con éxito a la red del Departamento de Informática" &
fi
