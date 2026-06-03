#!/bin/bash

# Download the latest version of MacSploit from api.macsploit.dev

curl -# https://api.macsploit.dev/main/version.json -o ./version.json
curl -# https://api.macsploit.dev/main/macsploit.dylib -o ./macsploit_x86_64.dylib
curl -# https://api.macsploit.dev/arm/macsploit.dylib -o ./macsploit_arm64.dylib

curl -# https://api.macsploit.dev/main/ms-app.zip -o ./ms-app.zip
unzip -o -q ./ms-app.zip -d .
rm ./ms-app.zip
mv ./ms-app.app ./MacSploit.app
zip -r ./MacSploit_x86_64.zip ./MacSploit.app
rm -r ./MacSploit.app

curl -# https://api.macsploit.dev/arm/ms-app.zip -o ./ms-app.zip
unzip -o -q ./ms-app.zip -d .
rm ./ms-app.zip
mv ./ms-app.app ./MacSploit.app
zip -r ./MacSploit_arm64.zip ./MacSploit.app
rm -r ./MacSploit.app

curl -# https://api.macsploit.dev/main/scripts.zip -o ./scripts.zip
unzip -o -q ./scripts.zip -d .
rm ./scripts.zip
rm -r ./scripts/__MACOSX
zip -r ./scripts.zip ./scripts/*
rm -r ./scripts
rm -r ./__MACOSX