#!/bin/bash

# Script de conección a la red USM Santiago San Joaquín
# Pablo Albornoz, 2012. (pablo@cronobit.net).
# github.com/Bhran/AutoLoginUSM

# Dependencias:
#	* bash
#	* iwconfig
# Opcionales:
#	* zenity (GNOME)
#	* kdialog (KDE)

# Ejecución Automática:
# Incluye la ruta hacia el script a tu archivo de inicio de sesión,
# ya sea ~/.bashrc, ~/.xsession, ~/.kde/Autostart, etc.
# En el caso de GNOME, debes usar la utilidad gnome-session-properties

# IMPORTANTE
# Completa esta información

USM_USER=""
USM_PASS=""

DI_USER=""
DI_PASS=""

# Si tu interfaz de red inalámbrica no es 'wlan0', cambia esta variable.
WLAN="wlan0"

# Si haces alguna modificación a partir de este punto, porfavor
# no dudes en compartirla :)

# Obtiene el SSID de la red...
CURRENT_SSID=`iwconfig $WLAN | grep ESSID | cut -d : -f 2 | cut -d \" -f 2`

# Espera hasta 30 segundos que la red esté lista...
COUNT=0
MAX_COUNT=10
PING=$(ping -c1 google.com | awk '/data/ {print $7}')
while [ "$CURRENT_SSID" != "off/any" ] && [ "$PING" != "data." ]&& [ $COUNT -lt 10 ]
do	
	sleep 3
	CURRENT_SSID=`iwconfig $WLAN | grep ESSID | cut -d : -f 2 | cut -d \" -f 2`
	PING=$(ping -c1 google.com | awk '/data/ {print $7}')
	COUNT=$((COUNT+1))
done

# Evalúa el estado de la conexión y luego envia la información de inicio de sesión.
if [ $COUNT -eq 10 ]
then
	USM_NET=0
else
	if [ `echo $CURRENT_SSID | grep usm_` ]
	then
		USM_NET=1
		curl --silent --insecure -d username=$USM_USER%40alumnos.usm.cl -d password=$USM_PASS -d buttonClicked=4 https://1.1.1.1/login.html > /dev/null	
	# Esta parte aún no funciona, pero está aquí para demostrar el concepto
	# hasta que pueda descubrir como pasar por el formulario del DI.
	elif [ "$CURRENT_SSID" == "di" ]
	then
		USM_NET=2
		curl --silent -d auth_user=$DI_USER -d auth_pass=$DI_PASS http://10.6.43.2:8000/ > /dev/null
	else
		USM_NET=3
	fi
fi

# Evalúa que conexión se utilizó.
case $USM_NET in
1)
	USM_MESSAGE="Ingresaste con éxito a la red USM";;
2)
	USM_MESSAGE="Ingresaste con éxito a la red del DI";;
3)
	USM_MESSAGE="La red inalámbrica no es USM";;
*)
	USM_MESSAGE="Ocurrió un error conectando a la red";;
esac

# Muestra una notificación por pantalla
if [ "$DESKTOP_SESSION" = "gnome" ] && type zenity > /dev/null
then
	zenity --notification --text="$USM_MESSAGE" --title="AutoLogin USM" &
elif [ "$DESKTOP_SESSION" = "kde" ] && type kdialog > /dev/null
then
	kdialog --passivepopup "$USM_MESSAGE" 5 --title="AutoLogin USM" &
else
	echo $USM_MESSAGE
fi

