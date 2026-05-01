#!/usr/bin/env sh
#
# requires: ncsel https://github.com/manfredguentner/ncsel
#           mpv   Probably in any distro as package available
#
# This is a demo  how to build a small curses UPnP browser
# 
# 

path="."
tput clear

while true
do
  key=$(upnpls "${path}" | ncsel -vb - )
  line=$(printf "${key}" | awk '{printf "%d", $1}')

  if [ "${line}" -eq 0 ]; then exit 0; fi
  if [ "${line}" -lt 0 ]; then 
    path=$(printf "${path}" | awk '{gsub(/.[0-9]+$/,"",$0); print $0}')
    if [ "${path}" = "" ]; then
      path="."
    fi
  fi
  if [ "${line}" -gt 0 ]; then
    item=$(printf "${key}" | awk '{print $3}')
    path=$(printf "${key}" | awk '{print $2}')

    case ${item} in
      \*) upnpls -o f=url "${path}" | mpv --quiet --volume=50 --playlist=-
          path=$(printf "${path}" | awk '{gsub(/.[0-9]+$/,"",$0); print $0}')
          if [ "${path}" = "" ]; then
            path="."
          fi
          ;;
    esac
  fi
done
