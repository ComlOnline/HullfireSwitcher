# HullfireSwitcher
This is a liquid soap Script and Front end for switching sources it is mainly used for HullfireRadio so some stuff I have not yet made original.

Its frontend GUI (the one php File) is a large adaption of The LiquidSoap-Recuester by Quinn Ebert
https://github.com/QuinnEbert/Liquidsoap-Requester/

## To Do:
- [X] Remove passwords from inital script
- [ ] Make the script use a Variables file
- [X] Upload script
- [ ] Remove curseing from PHP ~~and Upload~~(oops).

## How to Install liquidsoap

It is tested as working on Ubuntu Server LTS 16.04.2 If you follow this script to the letter you will also install webmin 1.831, if you dont want that then just remove that.

```
sudo apt-get update && sudo apt-get -y dist-upgrade
sudo apt-get -y install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python autoconf libtool libxml-dom-perl festival automake g++ ocaml samba

wget http://prdownloads.sourceforge.net/webadmin/webmin_1.831_all.deb
sudo dpkg --install webmin_1.831_all.deb

sudo add-apt-repository --yes ppa:avsm/ppa
sudo apt-get update -qq
sudo apt-get install -y opam
opam init (answer yes you do want to set up the files)

eval $(opam config env)
opam install depext
opam depext taglib mad lame vorbis cry fdkaac ssl soundtouch samplerate liquidsoap
opam install taglib mad lame vorbis cry fdkaac ssl soundtouch samplerate liquidsoap
```
