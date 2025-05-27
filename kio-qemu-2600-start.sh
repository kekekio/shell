#!/bin/bash
filename=$1
command=(
  "qemu-system-arm"" "
    "-M ast2600-evb"
    " "
    "-nographic"" "
    " "
    "-drive file="
      "./$filename,"
      "format=raw,if=mtd"
    " "
    "-device tmp421,id=sensor_4e,address=0x4e"
  )
$(IFS=; echo "${command[*]}")
