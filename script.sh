#!/bin/bash

set -e
set -u

# Nom de la VM
VM_NAME="SnowCrash"
VM_LOCATION="$HOME/goinfre/snow-crash"
ISO_NAME="SnowCrash.iso"
ISO_PATH="$HOME/goinfre/$ISO_NAME"
ISO_URL="https://cdn.intra.42.fr/isos/SnowCrash.iso"
VM_RAM=512

# --------------------------
# 📡 Configuration réseau : host-only avec IP 192.168.x.x
# --------------------------

echo "🔍 Recherche d'un adaptateur host-only avec une IP en 192.168.*..."

HOSTONLY_IFACE=""
while IFS= read -r iface; do
	ip=$(VBoxManage list hostonlyifs | grep -A 10 "$iface" | grep "IPAddress:" | awk '{print $2}')
	if [[ "$ip" == 192.168.* ]]; then
		HOSTONLY_IFACE="$iface"
		echo "✅ Adaptateur trouvé : $iface ($ip)"
		break
	fi
done < <(VBoxManage list hostonlyifs | grep "^Name:" | awk '{print $2}')

# S'il n'existe pas, on le crée
if [ -z "$HOSTONLY_IFACE" ]; then
	echo "⚠️ Aucun adaptateur host-only avec IP 192.168.* trouvé. Création en cours..."
	CREATE_OUTPUT=$(VBoxManage hostonlyif create 2>&1)
	HOSTONLY_IFACE=$(echo "$CREATE_OUTPUT" | grep -oE "vboxnet[0-9]+")
	if [ -z "$HOSTONLY_IFACE" ]; then
		echo "❌ Impossible de récupérer le nom de l'interface après création." >&2
		exit 1
	fi
	echo "✅ Nouvel adaptateur : $HOSTONLY_IFACE"
	VBoxManage hostonlyif ipconfig "$HOSTONLY_IFACE" --ip 192.168.56.1

	# Activation du serveur DHCP pour cet adaptateur
	echo "🔧 Configuration du serveur DHCP sur $HOSTONLY_IFACE..."
	VBoxManage dhcpserver add --ifname "$HOSTONLY_IFACE" \
		--ip 192.168.56.100 \
		--netmask 255.255.255.0 \
		--lowerip 192.168.56.101 \
		--upperip 192.168.56.254 \
		--enable

	echo "✅ DHCP activé sur $HOSTONLY_IFACE (plage : 192.168.56.101 → 192.168.56.254)"
fi

# DL iso
if [ ! -f "$ISO_PATH" ]; then
	echo "📥 Téléchargement de l'ISO depuis $ISO_URL..."
	wget -O "$ISO_PATH" "$ISO_URL" || {
		echo "❌ Erreur de téléchargement de l'ISO." >&2
		exit 1
	}
	echo "✅ ISO téléchargée dans $ISO_PATH"
else
	echo "✔️ ISO déjà présente : $ISO_PATH"
fi

# Vérifie si la VM existe déjà
if VBoxManage list vms | grep -q "\"$VM_NAME\""; then
	echo "⚠️ La VM $VM_NAME existe déjà, suppression pour recréation..."
	VBoxManage unregistervm "$VM_NAME" --delete
fi

echo "🔨 Création de la VM '$VM_NAME'..."

# Création du dossier de la VM
mkdir -p "$VM_LOCATION"

# Récupération du dossier machine par défaut
DEFAULT_MACHINE_FOLDER=$(VBoxManage list systemproperties | grep "Default machine folder" | cut -d ':' -f2 | xargs)
if [ -z "$DEFAULT_MACHINE_FOLDER" ]; then
    echo "❌ Le dossier machine par défaut est vide, quelque chose ne vas pas !" >&2
    exit 1
else
    echo "📋 Dossier machine par défaut: '$DEFAULT_MACHINE_FOLDER'"
fi

# Restaure le dossier machine par défaut
_restore_default_machine_folder() {
    echo "🔄 Rétablissement du dossier machine par défaut à '$DEFAULT_MACHINE_FOLDER'"
    VBoxManage setproperty machinefolder "$DEFAULT_MACHINE_FOLDER"
    echo "✅ Dossier machine par défaut rétabli."
}

_cleanup_error() {
    echo "❌ Une erreur est survenue." >&2
    _restore_default_machine_folder
    exit 1
}

# Trap INT (Ctrl-C), and ERR to run _cleanup_error
trap _cleanup_error INT ERR

echo "🔧 Définition du dossier machine par défaut à '$VM_LOCATION'"
VBoxManage setproperty machinefolder "$VM_LOCATION"

# Création VM
VBoxManage createvm --name "$VM_NAME" --register

_restore_default_machine_folder

# Remove trap INT (Ctrl-C), and ERR
trap - INT ERR

# Config VM
VBoxManage modifyvm "$VM_NAME" --memory "$VM_RAM" --nic1 hostonly --hostonlyadapter1 "$HOSTONLY_IFACE" --boot1 dvd

# Configure stockage IDE
VBoxManage storagectl "$VM_NAME" --name "IDE Controller" --add ide

# Attache l'ISO
VBoxManage storageattach "$VM_NAME" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$ISO_PATH"

echo "🚀 Lancement de la VM '$VM_NAME'..."

# Démarre la VM en GUI
VBoxManage startvm "$VM_NAME" --type gui

echo "🎉 VM '$VM_NAME' lancée avec l'adaptateur host-only '$HOSTONLY_IFACE'."
