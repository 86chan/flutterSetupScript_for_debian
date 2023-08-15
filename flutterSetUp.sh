#!/bin/bash

APTCMD=apt-get
if which apt-fast >/dev/null 2>&1; then APTCMD=apt-fast; fi

# apt update and Install
echo 
echo '------------------------------------------------------------------------------------------'
echo 'apt update and Install...'
echo '------------------------------------------------------------------------------------------'
sudo apt-get update
sudo $APTCMD -y dist-upgrade
sudo $APTCMD -y install bash \
                        curl \
                        file \
                        git \
                        unzip \
                        xz-utils \
                        zip \
                        clang \
                        cmake \
                        ninja-build \
                        pkg-config \
                        libgtk-3-dev \
                        openjdk-17-jdk \
                        --ignore-missing

# sudo mkdir -p /etc/apt/keyrings;
# curl -sL https://packages.adoptium.net/artifactory/api/gpg/key/public \
#     | sudo tee /etc/apt/keyrings/adoptium.asc

# echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/ {print$2}' /etc/os-release) main" \
#     | sudo tee /etc/apt/sources.list.d/adoptium.list

# sudo apt update
# sudo $APTCMD -y install temurin-11-jdk

# readlink -f $(which java) | sed 's:/bin/java::'


# set Path Android SDK and Flutter SDK
echo 
echo '------------------------------------------------------------------------------------------'
echo 'set Path Android SDK and Flutter SDK...'
echo '------------------------------------------------------------------------------------------'

# bashrc
BASHRC_PATH=${HOME}/.bashrc

# flutter_env
FLUTTERENV_PATH=${HOME}/.flutter_env

# root
DEVROOT_PATH=${HOME}/dev

# flutter
_p_flutter_path=FLUTTER_ROOT=${DEVROOT_PATH}/flutter

# Android SDK
_p_android_home=ANDROID_HOME=${DEVROOT_PATH}/android

eval ${_p_flutter_path}
eval ${_p_android_home}

_p_android_sdk=${ANDROID_HOME}/sdk
_p_android_avd=${ANDROID_HOME}/avd


_p_android_sdk_home=ANDROID_SDK_HOME=${_p_android_sdk}
_p_android_sdk_root=ANDROID_SDK_ROOT=${_p_android_sdk}
_p_android_avd_home=ANDROID_AVD_HOME=${_p_android_avd}

# set env
eval ${_p_android_sdk_home}
eval ${_p_android_sdk_root}
eval ${_p_android_avd_home}

# set env PATH
_p_flutter_bin='${PATH}:${FLUTTER_ROOT}/bin'
_p_android_cmdtools_bin='${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin'
_p_android_pftools='${PATH}:${ANDROID_SDK_ROOT}/platform-tools'
_p_android_emu='${PATH}:${ANDROID_SDK_ROOT}/emulator'

# set env
export PATH=$(eval echo ${_p_flutter_bin})
export PATH=$(eval echo ${_p_android_cmdtools_bin})
export PATH=$(eval echo ${_p_android_pftools})
export PATH=$(eval echo ${_p_android_emu})

# set ~/.bashrc
echo > ${FLUTTERENV_PATH}

# flutter
echo '# flutter' >> ${FLUTTERENV_PATH}
echo 'export '$(eval echo ${_p_flutter_path}) >> ${FLUTTERENV_PATH}
echo >> ${FLUTTERENV_PATH}

# android SDK
echo '# Android SDK' >> ${FLUTTERENV_PATH}
echo 'export '$(eval echo ${_p_android_home}) >> ${FLUTTERENV_PATH}
echo 'export '$(eval echo ${_p_android_sdk_home}) >> ${FLUTTERENV_PATH}
echo 'export '$(eval echo ${_p_android_sdk_root}) >> ${FLUTTERENV_PATH}
echo 'export '$(eval echo ${_p_android_avd_home}) >> ${FLUTTERENV_PATH}
echo >> ${FLUTTERENV_PATH}

# Set PATHs
echo '# set PATH' >> ${FLUTTERENV_PATH}
echo 'export PATH='${_p_flutter_bin} >> ${FLUTTERENV_PATH}
echo 'export PATH='${_p_android_cmdtools_bin} >> ${FLUTTERENV_PATH}
echo 'export PATH='${_p_android_pftools} >> ${FLUTTERENV_PATH}
echo 'export PATH='${_p_android_emu} >> ${FLUTTERENV_PATH}

# flat to PATH
export PATH=$(printf %s "${PATH}" | awk -v RS=: -v ORS=: '!arr[$0]++')

# print Paths
echo '    FLUTTER_ROOT: '${FLUTTER_ROOT}
echo '    ANDROID_HOME: '${ANDROID_HOME}
echo 'ANDROID_SDK_HOME: '${ANDROID_SDK_HOME}
echo 'ANDROID_SDK_ROOT: '${ANDROID_SDK_ROOT}
echo 'ANDROID_AVD_HOME: '${ANDROID_AVD_HOME}
echo '            PATH: '${PATH}

# make directory
echo 
echo '------------------------------------------------------------------------------------------'
echo 'make directory...'
echo '------------------------------------------------------------------------------------------'
MVCMDTL=${ANDROID_SDK_HOME}/cmdline-tools/latest

mkdir -p ${MVCMDTL}
mkdir -p ${FLUTTER_ROOT}
mkdir -p ${ANDROID_HOME}
mkdir -p ${ANDROID_SDK_HOME}
mkdir -p ${ANDROID_SDK_ROOT}
mkdir -p ${ANDROID_AVD_HOME}
mkdir -p ${ANDROID_AVD_HOME}

# set Downloader
DLCMD='curl -L'
if which axel >/dev/null 2>&1; then DLCMD='axel -n10'; fi

# # Download JDK 11
# echo 
# echo '------------------------------------------------------------------------------------------'
# echo 'Downloading and Extracting JDK 11 from Eclipse Temurin by Adoptium'
# echo '------------------------------------------------------------------------------------------'
# JDK_11_URL=$(curl -sL https://api.github.com/repos/adoptium/temurin11-binaries/releases/latest \
#                     | grep -e 'http.*OpenJDK11U-jdk_x64_linux_hotspot_.*\.tar\.gz"' \
#                     | cut -d : -f 2,3 \
#                     | tr -d \")

# echo 'Downloading: '${JDK_11_URL}
# $DLCMD ${JDK_11_URL} -o ${DEVROOT_PATH}/jdk11.tar.gz
# tar -zxf ${DEVROOT_PATH}/jdk11.tar.gz -C ${DEVROOT_PATH}
# rm ${DEVROOT_PATH}/jdk11.tar.gz

# # set env and path
# _p_java_home=JAVA_HOME=$(find ${DEVROOT_PATH} -maxdepth 1 -name jdk-*)
# eval ${_p_java_home}

# _p_java_home_bin='${PATH}:${JAVA_HOME}/bin'
# export PATH=$(eval echo ${_p_java_home_bin})

# echo '# JAVA_HOME' >> ${FLUTTERENV_PATH}
# echo 'export '$(eval echo ${_p_java_home}) >> ${FLUTTERENV_PATH}
# echo 'export PATH='${JAVA_HOME} >> ${FLUTTERENV_PATH}

# # flat to PATH
# export PATH=$(printf %s "${PATH}" | awk -v RS=: -v ORS=: '!arr[$0]++')

# # print Paths
# echo '    FLUTTER_ROOT: '${FLUTTER_ROOT}
# echo '    ANDROID_HOME: '${ANDROID_HOME}
# echo 'ANDROID_SDK_HOME: '${ANDROID_SDK_HOME}
# echo 'ANDROID_SDK_ROOT: '${ANDROID_SDK_ROOT}
# echo 'ANDROID_AVD_HOME: '${ANDROID_AVD_HOME}
# echo '       JAVA_HOME: '${JAVA_HOME}
# echo '            PATH: '${PATH}

# flutter install
echo 
echo '------------------------------------------------------------------------------------------'
echo 'git clone flutter...'
echo '------------------------------------------------------------------------------------------'
# git clone --depth 1 -b master https://github.com/flutter/flutter.git "${FLUTTER_ROOT}"
curl -s https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json \
    | head -n300 > ${DEVROOT_PATH}/flutter_releases_linux.json

flutter_stable_hash=$(cat ${DEVROOT_PATH}/flutter_releases_linux.json \
                        | head -n7 \
                        | grep 'stable' \
                        | sed -e 's/"stable"://g' -e 's/"//g' -e 's/ //g')

flutter_stable_url=$(cat ${DEVROOT_PATH}/flutter_releases_linux.json \
                        | grep -A 200 '"releases":' \
                        | grep -A 7 ${flutter_stable_hash} \
                        | grep 'archive' \
                        | sed -e 's/archive//g' -e 's/"//g' -e 's/,//g' -e 's/ //g' \
                        | sed -e 's#:#https:\/\/storage.googleapis.com\/flutter_infra_release\/releases\/##g')

$DLCMD ${flutter_stable_url} -o ${DEVROOT_PATH}/flutter_releases_linux.tar.xz
tar Jxfv ${DEVROOT_PATH}/flutter_releases_linux.tar.xz -C ${DEVROOT_PATH}

rm ${DEVROOT_PATH}/flutter_releases_linux.*

# Android SDK Command line Get Download URL
echo 
echo '------------------------------------------------------------------------------------------'
echo 'Downloading Android SDK Command line tools...'
echo '------------------------------------------------------------------------------------------'
cmd_tool_URL=""
if [[ $(curl https://developer.android.com/studio/index.html -L -k -is) =~ \
        (https://(/*-*_*\.*[a-zA-Z]*)*commandlinetools-linux-[0-9]*_latest\.zip) ]]; then 
    cmd_tool_URL=${BASH_REMATCH[1]};
else
    echo 'Failure!'
    echo 'The Android SDK Command line tools could not be downloaded...'
    exit -1
fi
$DLCMD ${cmd_tool_URL} -o ${ANDROID_HOME}/cmd_tool.zip

echo 
echo '------------------------------------------------------------------------------------------'
echo 'Extracting...'
echo '------------------------------------------------------------------------------------------'
unzip -n ${ANDROID_HOME}/cmd_tool.zip -d ${ANDROID_SDK_HOME}
rm ${ANDROID_HOME}/cmd_tool.zip
find ${MVCMDTL}/.. -maxdepth 1 ! -name latest \
    | grep -E '\.\./' \
    | xargs -I%% mv %% ${MVCMDTL}/.

# licenses accept
echo 
echo '------------------------------------------------------------------------------------------'
echo 'setup android sdkmanager...'
echo '------------------------------------------------------------------------------------------'
sdkmanager --licenses --verbose
flutter doctor --android-licenses
sdkmanager --update

# sdk install
sdkmanager 'build-tools;29.0.3' \
           'build-tools;30.0.3' \
           'build-tools;31.0.0' \
           'build-tools;32.0.0' \
           'platforms;android-29' \
           'platforms;android-30' \
           'platforms;android-31' \
           'platforms;android-32' \
           'platform-tools' \
           'patcher;v4'

flutter doctor

# add .flutter_env to .bashrc
if [ $(grep -q '# .flutter_env' ~/.bashrc) ]; then
    exit 1
fi

echo >> ${BASHRC_PATH}
echo '# .flutter_env' >> ${BASHRC_PATH}
echo 'if [ -f ~/.flutter_env ]; then' >> ${BASHRC_PATH}
echo '    . ~/.flutter_env' >> ${BASHRC_PATH}
echo 'fi' >> ${BASHRC_PATH}

exit 0
