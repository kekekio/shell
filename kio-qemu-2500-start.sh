#!/bin/bash
filename=$1
command=(
  "qemu-system-arm"" "
    "-m 512 -M ast2500-evb"
      ",fmc-model=n25q512a"
    " "
    "-nographic"" "
    "-nic tap,ifname=tap0,script=no,downscript=no"" "
    "-net user,"
      "hostfwd=:127.0.0.1:2222-:22,"
      "hostfwd=:127.0.0.1:2443-:443,"
      "hostfwd=udp:127.0.0.1:2623-:623,"
      "hostfwd=udp:127.0.0.1:1414-:1414,"
      "hostname=qemu"
    " "
    "-drive file="
      "./$filename,"
      "format=raw,if=mtd"
    " "
    "-device tmp421,id=sensor_4e,address=0x4e"
  )
$(IFS=; echo "${command[*]}")
