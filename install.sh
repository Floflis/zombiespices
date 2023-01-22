#!/bin/sh

echo "Installing 'zombiespices' syswide..."

#sudo cp -f ethgas /usr/bin/ethgas

if [ ! -e /usr/lib/zombiespices ]; then sudo mkdir /usr/lib/zombiespices; fi
sudo cp -f zombiespices /usr/bin/
sudo cp -f installer.sh /usr/lib/zombiespices/
sudo cp -f README.md /usr/lib/zombiespices/

#installfail(){
#   echo "Installation has failed."
#   exit 1
#}

if [ -f /usr/bin/zombiespices ];then
   echo "- Turning 'zombiespices' into an executable..."
   sudo chmod +x /usr/bin/zombiespices
#   if ethgas babyisalive; then echo "Done! Running 'ethgas' command as example to use it:" && (ethgas &);exit 0; else installfail; fi
#   else
#      installfail
fi

if [ -f /usr/lib/zombiespices/installer.sh ];then
   echo "- Turning zombiespices' installer.sh into an executable..."
   sudo chmod +x /usr/lib/zombiespices/installer.sh
fi
