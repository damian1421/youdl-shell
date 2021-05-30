#!/data/data/com.termux/files/usr/bin/zsh
clear
log=$HOME/.log
if [ -f $log ]
then
	 touch $log
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

#Sección título
Title(){
echo ${YELLOW}"Descargar video/música de YOUTUBE (...y muchos sitios más)"${NC}
}
#Sección info ayuda, informa como abrir la ayuda
InfoAyuda(){
echo ${LGREY}"--help = Muestra la ayuda"${LBLUE}
}

#Help
if [ "$1" = "--help" ]
        then
        clear
	Title
        echo ""
        echo *Para utilizar el modo ágil:
        echo Primero, registrar el alias en .bashrc
        echo alias youdl="$HOME/.you-dl.sh"
        echo Segundo, ejecutar el comando de este modo
        echo ----------------------
        echo youdl "link" "opción"
        echo ----------------------
        echo Formatos:
        echo 1 = Descarga el video en MP4
        echo 2 = Descarga solo el audio en MP3
        echo 3 = Playlist: Descarga solo la cancion actual
        echo 4 = Playlist: Descarga la playlist completa
		echo 5 = Actualizar
		echo 6 = Instalar
	    sleep 20
fi

#verify argument (link) included in string
if [ -z "$1" ]
then
	clear
	Title
	InfoAyuda
	echo Escribir el link del video:
	read link
	case $link in
	[qQ])
		clear
		echo "Se ha cancelado la descarga"
		exit 0
		;;
	esac
else
	link=$1
fi
#Verify argument (format) included in string
if [ -z "$2" ]
then
	clear
	Title
	echo Elegir una opcion:
	echo 1 = Descarga el video en MP4
	echo 2 = Descarga solo el audio en MP3
	echo 3 = Playlist: Descarga solo la cancion actual
	echo 4 = Playlist: Descarga la playlist completa
	echo 5 = Actualizar aplicación
	echo --help = Ver ayuda
	read INPUT
else
	INPUT=$2
fi
#Proceed to download link in selected format
if [ ${INPUT} = "1" ];
	then
    youtube-dl $link -i --recode-video mp4
fi
if [ ${INPUT} = "2" ];
       	then
	youtube-dl $link -i --extract-audio --audio-format mp3
fi
if [ ${INPUT} = "3" ];
	then
	youtube-dl $link --no-playlist -i  --extract-audio --audio-format mp3 --audio-quality 0
fi
if [ ${INPUT} = "4" ];
	then
	youtube-dl $link --yes-playlist -i  --extract-audio --audio-format mp3 --audio-quality 0
fi
if [ ${INPUT} = "5" ];
	then
	clear
	echo "Updating Youtube Downloader"
	youtube-dl -U
fi
if [ ${INPUT} = "6" ];
	then
	clear
	touch $HOME/.log
	echo "Installing Youtube Downloader"
	echo "Copying youtube-dl to your $PREFIX/bin path"
	cp youtube-dl $PREFIX/bin/
	Status
	read -p "What's your shell interpreter? bash / zsh" interpreter
	rc=rc
	Status
	echo export youdl="$HOME/.you-dl.sh" >> .$interpreter$rc
	Status
	echo "Deleting installer..."
	rm youtube-dl
	Status
	echo "Installation finished!"
fi

Status(){
step="!!"; echo [$?] $step
}
