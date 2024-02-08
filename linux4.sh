#!/bin/bash
echo "Entrada de datos"
echo 

echo "instalar las cosas necesarias para hacerlo"
apt update
sudo apt install isc-dhcp-server
sudo apt install net-tools

"----------------------------------------------------------------------------------"
read -p "Ingresa la ip Asignada al servidor (usar ip a): " $DHCPaddr
read -p "Ingrese el rango inicial de IP: " initialIP
read -p "Ingrese el rango final de IP: " finalIP
read -p "Ingrese la mascara de red: " netmask
read -p "Ingrese la direccion del router: " router
read -p "Ingrese el DNS 1: " dns1
read -p "Ingrese el broadcast: " broadcast
read -p "Ingrese la sub red: " subnet
read -p "Ingrese la mascara de sub red: " subnetmask
read -p "Ingrese el nombre de dominio: " dominio
read -p "Ingrese el time out: " timeout

sudo ifconfig enp0s8 $DHCPaddr
echo "----------------------------------------------------------------------------------"
echo "Verificación de datos"
echo "IP inicial = $initialIP"
echo "IP final = $finalIP"
echo "DNS 1 = $dns1"
echo "DNS 2 = $dns2"
echo "timeout = $timeout"
read -p "Presione Enter para continuar..."


sudo cp /etc/dhcp/dhcpd.conf
sudo bash -c "cat <<EOF>> /etc/dhcp/dhcpd.conf
subnet $subnet netmask $netmask {
    range $initialIP $finalIP;
    option domain-name \"$dominio\";
    option routers $router;
    option subnet-mask $subnetmask;
    option broadcast-address $broadcast;
    option domain-name-servers $dns1;
    default-lease-time $timeout;
    max-lease-time 3600;
}
EOF"



sudo systemctl restart isc-dhcp-server

sudo netplan apply

echo "Proceso completado"

exit