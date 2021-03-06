#Auto Login USM
Una colección de proyectos para implementar autenticación automática en las redes de la Universidad Técnica Federico Santa María.
##Proyecto
La intención de este repositorio es recojer todos los scripts o programas que permitan autenticación automática en la USM, independientes del sistema operativo, de la plataforma o método de conexión.
##Scripts
Hasta ahora, los métodos de conexión soportados son las siguientes:
###GNU/Linux
* **Bash** es un script para GNU/Linux que puede configurarse para correr al iniciar sesión. Soporta notificaciones de escritorio a través de libnotify o salida estandar.

* **NetworkManager** es para aquellos que utilizan NetworkManager como administrador de conexiones inalámbricas. A diferencia del script de Bash, este saca ventaja del NetworkManager Dispatcher y puede correr cuando se realiza una conexión, en vez de cuando se inicia una sesión.

Ambos scripts pueden convivir. Revisa el código de cada uno para las instrucciones sobre como instalarlos.

##Aportando
Conectarse a la red de la U desde fuera del navegador no es un proceso complicado, pero sí una tarea repetitiva que se puede automatizar. Si necesitas inspiración para un nuevo método solo revisa el código de otras implementaciones. Para aportar al proyecto, haz un fork del repositorio, agrega tu método en un directorio por separado que tenga el nombre de la plataforma o método utilizado y luego envía un Pull Request para agregarlo a la rama maestra.

##Agradecimientos
A [camitox](https://github.com/camitox) por escribir la [aplicación para iPhone](https://github.com/camitox/USM-Login-iPhone) que fue en parte lo que inspiró este proyecto.
