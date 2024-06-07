#!/bin/bash
#
# \brief ucompress all filetypes
# разархивировать все типы архивов
# args: 
#       \param[in] $1 - filename

extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.zst)	tar	--zstd -xvf 	$1 ;;
           *.tzst)	tar	--zstd -xvf 	$1 ;;
           *.zst)	unzstd 			$1 ;;
           *.tar.xz)	tar	-Jxvf 		$1 ;;
           *.txz)	tar	-Jxvf 		$1 ;;
           *.xz)	xz	--decompress	$1 ;;
           *.tar.bz2)	tar	xvjf 		$1 ;;
           *.tbz2)	tar 	xvjf 		$1 ;;
           *.bz2)	bunzip2			$1 ;;
           *.tar.gz)	tar	xvzf 		$1 ;;
           *.tgz)	tar 	xvzf 		$1 ;;
           *.gz)	gunzip 			$1 ;;
           *.rar)	unrar	x 		$1 ;;
           *.tar)	tar 	xvf 		$1 ;;
           *.zip)	unzip 			$1 ;;
           *.Z)		uncompress 		$1 ;;
           *.7z)	7z 	x 		$1 ;;
           *)	echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
 }
extract $1
