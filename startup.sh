#!/bin/bash

# Functions

add_var_to_bashrc(){
  var_name=$1
  if [[ $(cat ~/.profile | grep "export "$1 -c) -eq 0 ]]; then
    echo 'export' $1 >> ~/.profile
    echo "$1 added"
  else
    echo $1" already added"
  fi
  source ~/.profile
}

add_var_to_path(){
  var_name=$1
  if [[ $(cat ~/.profile | grep "export PATH+=:"$1 -c) -eq 0 ]]; then
    echo 'export PATH+=:'$1 >> ~/.profile
    echo "$1 added to PATH"
  else
    echo $1 "already added to PATH"
  fi
  source ~/.profile
}

# End of functions section

echo "############ 1 - Installing Android Studio ############"
# 1- Android Studio
if [ ! -d "$HOME/android-studio" ]; then
  mkdir ~/android-studio
  curl https://dl.google.com/dl/android/studio/ide-zips/3.5.3.0/android-studio-ide-191.6010548-linux.tar.gz --output ~/android-studio_3.5.3.0.tar
  tar -xf  ~/android-studio_3.5.3.0.tar
  echo "Android Studio installed in $HOME/android-studio"
else
  echo "Android studio already installed. No installation needed."
fi

echo "############ 2 - Installing JDK and JRE 8 ############"
# 2- Java Open JDK e JRE 8+
yes | sudo apt-get install openjdk-8-jre
yes | sudo apt-get install openjdk-8-jdk

echo "############ 3 - Installing Nodejs ############"
# 3- Node JS
# 3.1 - python3 utils is required to install node at first time
yes | sudo apt-get install python3-distutils
add_var_to_path "$HOME/local/bin"
mkdir -p ~/local
mkdir -p ~/node-latest-install
cd ~/node-latest-install
curl http://nodejs.org/dist/node-latest.tar.gz | tar xz --strip-components=1
./configure --prefix=~/local
#make install # ok, fine, this step probably takes more than 30 minutes...
curl https://www.npmjs.org/install.sh | sh

echo "############ Adding Vars to profile and path ############"
add_var_to_bashrc "ANDROID_HOME=$HOME/Android/Sdk"

add_var_to_path "$ANDROID_HOME/bin"
add_var_to_path "$ANDROID_HOME/tools"
add_var_to_path "$ANDROID_HOME/platform-tools"
add_var_to_path "$ANDROID_HOME/lib"
add_var_to_path "$ANDROID_HOME/tools/lib"
add_var_to_path "$ANDROID_HOME/emulator"
add_var_to_bashrc "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64"
add_var_to_path "$JAVA_HOME"
add_var_to_path "$JAVA_HOME/bin"
add_var_to_path "/usr/local/node/bin"
add_var_to_path "$HOME/android-studio/bin"

sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
echo "############ 4 - Installing Appium  ############"
npm install -u appium
echo "############ 5 - Installing Appium Doctor ############"
npm install -u appium-doctor

appium-doctor --android
