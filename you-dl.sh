clear
echo Descargar video de YOUTUBE con youtube-dl
echo
#Help
if [ "$1" = "--help" ]
	then
	clear; echo
	echo Descargar video de YOUTUBE con youtube-dl en Linux; echo
	echo *Para utilizar el modo ágil:
	echo Primero, registrar el alias en .bashrc
	echo alias youdl="$HOME/.you-dl.sh"
	echo Segundo, ejecutar el comando de este modo
	echo ----------------------
	echo youdl "link" "formato"
	echo ----------------------
	echo Formatos:
	echo 1 = Descarga el video en MP4
    echo 2 = Descarga solo el audio en MP3
    echo 3 = Playlist: Descarga solo la cancion actual
    echo 4 = Playlist: Descarga la playlist completa; echo; echo; echo
	echo Consultas? ... ya veremos que hacemos con eso!
	sleep 25
fi
#verify arguments included in command
if [ -z "$1" ]
	then
	echo Escribir el link del video:
	read link
	else
		link=$1
if [ -z "$2" ]
	then
	clear; echo
	echo Elegir una opcion:
	echo 1 = Descarga el video en MP4
	echo 2 = Descarga solo el audio en MP3
	echo 3 = Playlist: Descarga solo la cancion actual
	echo 4 = Playlist: Descarga la playlist completa
	read INPUT
	else
		INPUT=$2
		if [ ${INPUT} = "1" ];
		    then
		        youtube-dl $link -i --recode-video mp4

		elif [ ${INPUT} = "2" ];
			then
			youtube-dl $link -i --extract-audio --audio-format mp3
		elif [ ${INPUT} = "3" ];
			then
			youtube-dl $link --no-playlist -i  --extract-audio --audio-format mp3 --audio-quality 0
		elif [ ${INPUT} = "4" ];
			then
			youtube-dl $link --yes-playlist -i  --extract-audio --audio-format mp3 --audio-quality 0
		fi
fi
fi
