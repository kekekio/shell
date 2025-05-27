#!/bin/bash
# \brief flash the last modified file in the folder
# прошить последний изменённый файл

FILE_NAME="$(ls -t | head -n 1)"
sudo flashrom -N -p ft2232_spi:type=arm-usb-ocd-h,port=A,divisor=8 -c MT25QL512 -w $FILE_NAME
