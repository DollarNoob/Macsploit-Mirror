#!/bin/bash

# Download the latest version of MacSploit from git.raptor.fun

curl -# https://git.raptor.fun/main/version.json -o ./version.json
curl -# https://git.raptor.fun/main/macsploit.dylib -o ./macsploit_x86_64.dylib
curl -# https://git.raptor.fun/arm/macsploit.dylib -o ./macsploit_arm64.dylib

rm -rf MacSploit.zip
mkdir macsploit
cd macsploit
curl -# https://git.raptor.fun/main/macsploit.zip -o ./macsploit.zip
unzip -o -q ./macsploit.zip -d .
zip -r ../MacSploit.zip ./MacSploit.app # since app is a folder in macos
cd ..
rm -r macsploit