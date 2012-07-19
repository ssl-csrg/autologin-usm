#!/bin/bash

# Script de conección a la red USM Santiago San Joaquín
# Pablo Albornoz, 2012. (pablo@cronobit.net).
# github.com/ssl-csrg/AutoLoginUSM

# Dependencias:
#	* networkmanager

# Opcionales:
#   * libnotify

# Ejecución Automática:
# Copia este script a la carpeta dispatcher.d de NetworkManager
# usualmente en la siguiente ruta: /etc/NetworkManager/dispatcher.d/
# luego dale permisos de ejecución: $ sudo chmod u+x 99-login_usm.sh

# IMPORTANTE
# Completa esta información

USM_USER=""
USM_PASS=""
USM_DOMAIN="alumnos" #Cambialo a "sansanos" si fuese necesario.

DI_USER=""
DI_PASS=""

# Si tu interfaz de red inalámbrica no es 'wlan0', cambia esta variable.
WLAN="wlan0"

# Si haces alguna modificación a partir de este punto, porfavor
# no dudes en compartirla :)

# obteniendo las variables de dispatcher.d
IF=$1
STATUS=$2

# Obtiene el SSID de la red...
if [ "$IF" = "$WLAN" ] && [ "$STATUS" = "up" ]
then
    #espera a que esté conectado al wifi
    CURRENT_SSID="off/any"
    while [ "$CURRENT_SSID" = "off/any" ]
    do
        CURRENT_SSID=`iwconfig $WLAN | grep ESSID | cut -d : -f 2 | cut -d \" -f 2`
    done
    
    # Espera 30 segundos a que haya internet
    COUNT=0
    MAX_COUNT=10
    PING=""
    while [ "$PING" != "data." ] && [ $COUNT -lt $MAX_COUNT ]
    do
	    PING=$(ping -c1 google.com | awk '/data/ {print $7}')
	    if [ "$PING" != "data." ]
	    then
	        sleep 3
	        COUNT=$((COUNT+1))
	    fi
    done
elif [ "$STATUS" = "down" ]
then
    exit $?
else
    USM_NET=0
fi

# Evalúa el estado de la conexión y luego envia la información de inicio de sesión.
if [ $COUNT -eq $MAX_COUNT ]
then
	USM_NET=0
else
	if [ `echo $CURRENT_SSID | grep usm_` ]
	then
		USM_NET=1
		curl --silent --insecure -d username=$USM_USER%40$USM_DOMAIN.usm.cl -d password=$USM_PASS -d buttonClicked=4 https://1.1.1.1/login.html > /dev/null	
	# Esta parte aún no funciona, pero está aquí para demostrar el concepto
	# hasta que pueda descubrir como pasar por el formulario del DI.
	#elif [ "$CURRENT_SSID" == "di" ]
	#then
	#	USM_NET=2
	#	curl --silent -d auth_user=$DI_USER -d auth_pass=$DI_PASS -d http://10.6.43.2:8000/ > /dev/null
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
0)
	USM_MESSAGE="Ocurrió un error conectando a la red";;
esac

# Revisa si existe libnotify
if type notify-send > /dev/null
then
# Muestra una notificación por pantalla
    #Obtiene la pantalla del servidor X"
    if [ -z "$DISPLAY" ]
    then
        console=`fgconsole`
        dispnum=`ps t tty$console | sed -n -re 's,.*/X(org)? .*:([0-9]+).*,\2,p'`
        export DISPLAY=":$dispnum"
    fi
    #Obtiene el usuario de esa pantalla
    GUI_user="$( who | grep ' tty' | grep $DISPLAY | cut -d ' ' -f 1 )"
    
    #Envia la notificación a través de ese usuario
    su $GUI_user -c "notify-send \"LoginUSM\" \"$USM_MESSAGE\" -t 5000"
else
    echo $USM_MESSAGE
fi

