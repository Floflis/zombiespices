#!/bin/bash -e

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

spicetype=$(jq -r '.type' manifest.json)
zombiespicename=$(jq -r '.name' content/metadata.json)
zombiespiceuuid=$(jq -r '.uuid' content/metadata.json)
zombiespicehost=$(jq -r '.host' manifest.json)

mkdir /tmp/zombiespices
cd /tmp/zombiespices

echo "Welcome to zombiespices"
echo "Preparing to install zombie-$spicetype '$zombiespicename' ($zombiespiceuuid)..."

echo "Installing zombie-$spicetype host '$zombiespicehost'..."
wget -N https://cinnamon-spices.linuxmint.com/files/"$spicetype""s"/$zombiespicehost.zip
# from https://serverfault.com/a/379060/923518
unzip $zombiespicehost.zip
sudo rsync -av "$zombiespicehost"/. /usr/share/cinnamon/"$spicetype""s"/$zombiespicehost
rm -r "$zombiespicehost"

echo "Installing zombie-$spicetype '$zombiespicename' ($zombiespiceuuid)..."
cd "$PWD" #from https://unix.stackexchange.com/a/52918/470623

if [ ! -e /usr/share/cinnamon/"$spicetype""s"/"$zombiespiceuuid" ]; then mkdir /usr/share/cinnamon/"$spicetype""s"/"$zombiespiceuuid"; fi
sudo rsync -av content/. /usr/share/cinnamon/"$spicetype""s"/$zombiespiceuuid

echo "(Sym)Linking from host $spicetype..."
while IFS="" read -r p || [ -n "$p" ]
do
  ln -s /usr/share/cinnamon/"$spicetype""s"/"$zombiespicehost"/"$p" /usr/share/cinnamon/"$spicetype""s"/"$zombiespiceuuid"/"$p"
done < symlink.txt
# from https://stackoverflow.com/a/1521498/5623661

if [ ! -e /tmp/cubicmode ]; then
   flouser=$(jq -r '.name' /1/config/user.json)
   echo "Installing $zombiespicename's presets..."
   mkdir /home/${flouser}/.cinnamon/configs/"$zombiespiceuuid"
   cp include/data/*.json /home/${flouser}/.cinnamon/configs/"$zombiespiceuuid"/
fi

rm -r /tmp/zombiespices
