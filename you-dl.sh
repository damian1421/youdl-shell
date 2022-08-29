#!/data/data/com.termux/files/usr/bin/zsh

#Author: l0gg3r
#Description: Download videos from Youtube, Facebook & more sites...!
#Source: https://github.com/damian1421/youdl-shell
clear
LOG=$HOME/.youdl.log
if [ -f $LOG ]
then
	 touch $LOG
fi
#Define la ruta desde la cual se ha invocado youdl.
PREVFOLDER=`pwd`
#Verificar si se ha declarado la ruta de descarga "$OUTFOLDER". || En caso que no se haya definido anteriormente, lo hace.
if [ -f $HOME/.youdl.conf ]
then
	echo "No se ha detectado el archivo de configuración"
	echo "¿Cuál es tu sistema operativo?"
	echo "1- Termux"
	echo "2- Linux: Ubuntu, Debian, ..."
	echo "3- Windows + WSL"
	read OS
		case $OS in
			1)
			clear
			echo "Tus descargas se guardarán en:"
			OUTFOLDER="/data/data/com.termux/files/home/storage/shared/YouDL"
			if [ -d $OUTFOLDER ]; then mkdir $OUTFOLDER; fi
			echo $OUTFOLDER >> $HOME/.youdl.conf
			echo $OUTFOLDER >> $HOME/.*.hrc
			;;
			2)
			clear
			USER=`whoami`
			echo "Tus descargas se guardarán en:"
			OUTFOLDER="/home/$USER/YouDL"
			if [ -d $OUTFOLDER ]; then mkdir $OUTFOLDER; fi
			echo $OUTFOLDER >> $HOME/.youdl.conf
			echo $OUTFOLDER >> $HOME/.*.hrc
			;;
			3)
			clear
			USER=`whoami`
			echo "Tus descargas se guardarán en:"
			OUTFOLDER="/mnt/c/Users/$USER/YouDL"
			if [ -d $OUTFOLDER ]; then mkdir $OUTFOLDER; fi
			echo $OUTFOLDER >> $HOME/.youdl.conf
			echo $OUTFOLDER >> $HOME/.*.hrc
			;;
		esac
fi
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
        echo "1 = Descarga el video en MP4"
        echo "2 = Descarga solo el audio en MP3"
        echo "3 = Playlist: Descarga solo la canción actual"
        echo "4 = Playlist: Descarga la playlist completa"
	echo "5 = Actualizar"
	echo "6 = Instalar"
	echo "q = Salir"
	sleep 20
	;;
	[qQ])
		clear
		echo "Se ha cancelado la descarga"
		echo "Saliendo..."
		exit 0
		;;
	*)
		link=$1
		;;
	esac
fi

#Verifies format included when you'd launched the program
if [ -z "$2" ]
then
	clear
	Title
	echo Elegir una opción:
	echo 1 = Descarga el video en MP4
	echo 2 = Descarga solo el audio en MP3
	echo 3 = Playlist: Descarga solo la canción actual
	echo 4 = Playlist: Descarga la playlist completa
	echo 5 = Actualizar aplicación
	echo 6 = Instalar YouDL
	echo --help = Ver ayuda
	echo q = Salir
	read INPUT
	case $INPUT in
		[qQ])
			clear
			echo "Saliendo del programa..."
			echo "Se ha cancelado la descarga!"
			exit 0
			;;
	1)INPUT=1
	;;
	2)INPUT=2
        ;;
	3)INPUT=3
        ;;
	4)INPUT=4
        ;;
	esac
else
	INPUT=$2
fi

#Proceed to download link in selected format

case $INPUT in
	1)
		yt-dlp -o '/data/data/com.termux/files/home/YouDL/%(title)s.%(ext)s' $link -i --recode-video mp4
		;;
	2)
		yt-dlp -o '/data/data/com.termux/files/home/YouDL/%(title)s.%(ext)s' $link -i --extract-audio --audio-format mp3
		;;
	3)
		yt-dlp -o '/data/data/com.termux/files/home/YouDL/%(title)s.%(ext)s' $link --no-playlist -i  --extract-audio --audio-format mp3 --audio-quality 0
		;;
	4)
		yt-dlp -o '/data/data/com.termux/files/home/YouDL/%(title)s.%(ext)s' $link --yes-playlist -i  --extract-audio --audio-format mp3 --audio-quality 0
		;;
	5)
		clear
		echo "Updating Youtube Downloader"
		yt-dlp -U
		;;
	6)
		clear
		echo "Installing Youtube Downloader"
		echo "Installing all prerrequisites"
		apt-get -y install zsh python ffmpeg git wget
		STEP="Prerrequisites"
		echo [$?] $STEP
		echo [$?] $STEP >> $LOG
		pip uninstall youtube-dl
		pip install yt-dlp
		STEP="Install yt-dlp"
		echo [$?] $STEP
		echo [$?] $STEP >> $LOG
		echo "Cloning repository of YouDL"
        	git clone https://github.com/damian1421/youdl-shell
		STEP="Clone repository YouDL"
		echo [$?] $STEP
		echo [$?] $STEP >> $LOG
		echo "Setting up alias"
		echo "alias youdl=$PREVFOLDER/you-dl.sh >> $HOME/.*shrc"
		STEP="Setting up .zshrc"
		echo [$?] $STEP
		echo [$?] $STEP >> $LOG
		echo "alias youdl=$PREVFOLDER/you-dl.sh >> $HOME/.*shrc"
		STEP="Setting up .bashrc"
		echo [$?] $STEP
		echo [$?] $STEP >> $LOG
		echo "Installation finished!"
		;;
esac
