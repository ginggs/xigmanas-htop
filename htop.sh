#!/bin/sh
# filename:     htop.sh
# author:       Graham Inggs
# date:         2018-12-29 ; Initial release for XigmaNAS 11.2.0.4
# date:         2019-10-29 ; Updated for XigmaNAS 12.0.0.4
# date:         2019-11-25 ; Updated for XigmaNAS 12.1.0.4
# date:         2021-04-03 ; Updated for XigmaNAS 12.2.0.4
# date:         2023-03-19 ; Fetch files with 'pkg fetch', exact filenames not needed, thanks Nivigor!
# purpose:      Install htop on XigmaNAS (embedded version).
# Note:         Check the end of the page.
#
#----------------------- Set variables ------------------------------------------------------------------
DIR=`dirname $0`;
#----------------------- Set Errors ---------------------------------------------------------------------
_msg() { case $@ in
  0) echo "The script will exit now."; exit 0 ;;
  1) echo "No route to server, or file do not exist on server"; _msg 0 ;;
  2) echo "Can't find ${PKG}-*.pkg on ${DIR}/All"; _msg 0 ;;
  3) echo "htop installed and ready! (ONLY USE DURING A SSH SESSION)"; exit 0 ;;
  4) echo "Always run this script using the full path: /mnt/.../directory/htop.sh"; _msg 0 ;;
esac ; exit 0; }
#----------------------- Check for full path ------------------------------------------------------------
if [ ! `echo $0 |cut -c1-5` = "/mnt/" ]; then _msg 4; fi
cd $DIR;
#----------------------- Download and decompress htop files if needed -----------------------------------
PKG="htop"
if [ ! -d ${DIR}/usr/local/bin ]; then
  if [ ! -e ${DIR}/All/${PKG}-*.pkg ]; then pkg fetch -o ${DIR} -y ${PKG} || _msg 1; fi
  if [ -f ${DIR}/All/${PKG}-*.pkg ]; then tar xzf ${DIR}/All/${PKG}-*.pkg || _msg 2;
    rm ${DIR}/+*; rm -R ${DIR}/usr/local/man; rm -R ${DIR}/usr/local/share; fi
  if [ ! -d ${DIR}/usr/local/bin ] ; then _msg 4; fi
fi
#----------------------- Create symlinks ----------------------------------------------------------------
for i in `ls $DIR/usr/local/bin/`
  do if [ ! -e /usr/local/bin/${i} ]; then ln -s ${DIR}/usr/local/bin/$i /usr/local/bin; fi; done
_msg 3 ; exit 0;
#----------------------- End of Script ------------------------------------------------------------------
# 1. Keep this script in its own directory.
# 2. chmod the script u+x,
# 3. Always run this script using the full path: /mnt/.../directory/htop.sh
# 4. You can add this script to WebGUI: Advanced: Command Scripts as a PostInit command (see 3).
# 5. To run htop from shell type 'htop'.
