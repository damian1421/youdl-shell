#!/data/data/com.termux/files/usr/bin/zsh

#Author: l0gg3r
#Source: https://github.com/damian1421/youdl-shell
clear
LOG="$PREFIX/var/log/youdl/youdl.log"
#Complete the following line with the path to download the media:
export OUTFOLDER=/data/data/com.termux/files/home/storage/shared/YouDL

if [ -s $LOG ]
then
	echo "[OK] Log exists"
else
	echo "[--] Initializing Log ..."
	mkdir -p $PREFIX/var/log/youdl && touch $LOG
fi

#Verifica la ruta de descargas y crea un soft-link en $HOME apuntando a la ruta de descargas en /sdcard/YouDL
[ -d $OUTFOLDER ] || md $OUTFOLDER ; ln -s $OUTFOLDER $HOME/YouDL

DIA=`date +"%d/%m/%Y"`
HORA=`date +"%H:%M"`

#Set colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BROWN='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LGREY='\033[0;37m'
DGREY='\033[1;30m'
LRED='\033[1;31m'
LGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LBLUE='\033[1;34m'
LPURPLE='\033[1;35m'
LCYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' #No color

Title(){ #Sección título
echo ${YELLOW}"Descargar video/música de YOUTUBE (...y muchos sitios más)"${NC}
}

Menu(){ #Muestra opciones del menú, para elegir el formato de descarga
echo Elegir una opción para la descarga:
echo 1 = MP4 Descarga el video
echo 2 = MP3 Descarga solo el audio
echo 3 = MP3 Playlist: Descarga sólo la canción actual
echo 4 = MP3 Playlist: Descarga la playlist completa
echo 5 = Actualizar aplicación
echo 6 = Instalar YouDL
echo --help = Ver ayuda
echo q = Salir
}

InfoAyuda(){ #Sección info ayuda, informa como abrir la ayuda
echo ${LGREY}"--help = Muestra la ayuda"${LBLUE}
}

#Help
if [ -z "$1" ]
then
	clear
	Title
	InfoAyuda
	echo Escribir el link del video:
	read link
else
	case $1 in
	--help)
		clear
		Title
		echo ""
		echo "*Para utilizar el modo ágil:"
		echo "Primero, registrar el alias en .bashrc"
		echo "alias youdl='$HOME/.you-dl.sh'"
		echo "Segundo, ejecutar el comando de este modo"
		echo "----------------------"
		echo "youdl 'link' 'formato'"
		echo "----------------------"
		echo "Formatos:"
		Menu
		sleep 20
		;;
	[qQ])
		clear
		echo "Se ha cancelado la descarga"
		echo "Saliendo..."
		exit 0
		;;
	esac
fi

#Verifica el formato indicado para realizar la descarga
if [ -z "$2" ]
then
	clear
	Title
	link=$1
	Menu
	read INPUT
	case $INPUT in
		[qQ])
			clear
			echo "Saliendo del programa..."
			echo "Se ha cancelado la descarga!"
			exit 0
	esac
else
	link=$1
	INPUT=$2
fi

#Procede a realizar la descarga según el $INPUT indicado
clear
case $INPUT in
	1)
		cd $OUTFOLDER
		echo "Download: MP4 of -> $1"
		youtube-dl $link -i --recode-video mp4 -o "%(title)s.%(ext)s"
		;;
	2)
		cd $OUTFOLDER
		echo "Download: MP3 of -> $1"
		youtube-dl $link -i --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s"
		;;
	3)
		cd $OUTFOLDER
		echo "Download: Only current song in MP3 of Playlist -> $1"
		youtube-dl $link --no-playlist -i  --extract-audio --audio-format mp3 --audio-quality 0 -o "%(title)s.%(ext)s"
		;;
	4)
		cd $OUTFOLDER
		echo "Download:  all songs in MP3 of Playlist -> $1"
		youtube-dl $link --yes-playlist -i  --extract-audio --audio-format mp3 --audio-quality 0 -o "%(title)s.%(ext)s"
		;;
	5)
		clear
		echo "Updating Youtube Downloader"
		pip3 install --upgrade youtube-dl || youtube-dl -U
		;;
	6)
		clear
		echo "Installing Youtube Downloader"
		echo "Installing all prerrequisites"
		STEP="Prerrequisites"
		apt-get -y install zsh python ffmpeg python git wget
		echo [$?] $STEP
		echo [$?] $STEP >> $LOG
		STEP="Install youtube-dl"
		pip install youtube-dl
		echo [$?] $STEP
		echo [$?] $STEP >> $LOG
		echo "Cloning repository of YouDL"
        	STEP="Clone repository YouDL"
		git clone https://github.com/damian1421/youdl-shell
		echo [$?] $STEP
		echo [$?] $STEP >> $LOG
		echo "Setting up alias"
		STEP="Setting up .zshrc"
		echo "alias youdl=`pwd`/youdl-shell/you-dl.sh" >> $HOME/.zshrc
		echo [$?] $STEP
		echo [$?] $STEP >> $LOG
		STEP="Setting up .bashrc"
		echo "alias youdl=`pwd`/youdl-shell/you-dl.sh" >> $HOME/.bashrc
		echo [$?] $STEP
		echo [$?] $STEP >> $LOG
		echo "Installation finished!"
		;;
esac
