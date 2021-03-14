#!/bin/bash
#script para instalar rclone en linux
#para crear los IDs de google-drive https://youtu.be/mnDYJ2ZpdxU?t=278

#Colores
greenColor="\e[0;32m\033[1m"
redColor="\e[0;31m\033[1m"
yellowColor="\e[0;33m\033[1m"
endColor="\033[0m\e[0m"

#Variable Globales
URL="https://downloads.rclone.org/rclone-current-linux-amd64.zip"
ZIP="rclone-current-linux-amd64.zip"

#Traps
trap ctrl_c INT
function ctrl_c(){
        echo -e "\n${redColor}Programa Terminado ${endColor}"
        exit 0
}

trap "rm -r $ZIP rclone-*-linux-amd64" EXIT 

#Inicio
echo -e "${yellowColor}Instalando dependencias ${endColor}"
sudo apt update; sudo apt install -y curl

echo -e "${yellowColor}Descargando + Descomprimiendo rclone ${endColor}"
curl -s -O "$URL" && unzip "$ZIP" 

echo -e "${yellowColor}Moviendo el binario ${endColor}"
sudo cp rclone-*-linux-amd64/rclone /usr/bin/ && sudo chown root:root /usr/bin/rclone && sudo chmod 755 /usr/bin/rclone

echo -e "${yellowColor}Creando carpeta donde montar ${endColor}"
mkdir ~/google-drive

echo -e "${yellowColor}Iniciando configuración de rclone ${endColor}"
rclone config

echo -e "${yellowColor}Copiando el servicio rclone para el montaje automatico al inicio de sesion ${endColor}"
sudo cp rclone.service /etc/systemd/system/

echo -e "${yellowColor}Editando el archivo /etc/fuse.conf para evitar conflictos ${endColor}"
sudo sed -i 's/^#user_allow_other/user_allow_other/' /etc/fuse.conf

echo -e "${yellowColor}Recargando el servicio ${endColor}"
sudo systemctl daemon-reload

echo -e "${greenColor}Iniciando el servicio ${endColor}"
sudo systemctl enable rclone.service --now


