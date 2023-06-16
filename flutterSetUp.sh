sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get install bash \
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
                     --ignore-missing

# root
DEVROOT=~/development

SETPATH=~/.bashrc

# flutter
_p0=FLUTTER_ROOT=${DEVROOT}/flutter

# Android SDK
_p11=ANDROID_HOME=${DEVROOT}/android

eval $_p0
eval $_p11

_p2=${ANDROID_HOME}/sdk
_p3=${ANDROID_HOME}/sdk
_p4=${ANDROID_HOME}/avd


_p22=ANDROID_SDK_HOME=$_p2
_p33=ANDROID_SDK_ROOT=$_p3
_p44=ANDROID_AVD_HOME=$_p4

# set env
eval $_p22
eval $_p33
eval $_p44

# set env PATH
_p00='${PATH}:${FLUTTER_ROOT}/bin'
_p5='${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin'
_p6='${PATH}:${ANDROID_SDK_ROOT}/platform-tools'
_p7='${PATH}:${ANDROID_SDK_ROOT}/emulator'

# set env
export PATH=$(eval echo $_p00)
export PATH=$(eval echo $_p5)
export PATH=$(eval echo $_p6)
export PATH=$(eval echo $_p7)

set ~/.bashrc
echo >> $SETPATH
echo '# flutter' >> $SETPATH
echo 'export '$(eval echo $_p0) >> $SETPATH
echo >> $SETPATH
echo '# Android SDK' >> $SETPATH
echo 'export '$(eval echo $_p11) >> $SETPATH
echo 'export '$(eval echo $_p22) >> $SETPATH
echo 'export '$(eval echo $_p33) >> $SETPATH
echo 'export '$(eval echo $_p44) >> $SETPATH
echo >> $SETPATH
echo '# set PATH' >> $SETPATH
echo 'export PATH='$_p00 >> $SETPATH
echo 'export PATH='$_p5 >> $SETPATH
echo 'export PATH='$_p6 >> $SETPATH
echo 'export PATH='$_p7 >> $SETPATH

echo '    FLUTTER_ROOT: '$FLUTTER_ROOT
echo '    ANDROID_HOME: '$ANDROID_HOME
echo 'ANDROID_SDK_HOME: '$ANDROID_SDK_HOME
echo 'ANDROID_SDK_ROOT: '$ANDROID_SDK_ROOT
echo 'ANDROID_AVD_HOME: '$ANDROID_AVD_HOME
echo '            PATH: '$PATH

# # source $SETPATH

# make directory
MVCMDTL=${ANDROID_SDK_HOME}/cmdline-tools/latest

mkdir -p $MVCMDTL
mkdir -p $FLUTTER_ROOT
mkdir -p $ANDROID_HOME
mkdir -p $ANDROID_SDK_HOME
mkdir -p $ANDROID_SDK_ROOT
mkdir -p $ANDROID_AVD_HOME
mkdir -p $ANDROID_AVD_HOME

# # flutter install 
# git clone -b master https://github.com/flutter/flutter.git "${FLUTTER_ROOT}"

# # remove git
# # find ${FLUTTER_ROOT} -name *\.git* | xargs rm -rf


# Android SDK Command line Get Download URL
# cmd_tool_URL=""
if [[ $(curl https://developer.android.com/studio/index.html -L -k -is) =~ (https://(/*-*_*\.*[a-zA-Z]*)*commandlinetools-linux-[0-9]*_latest\.zip) ]]; then cmd_tool_URL=${BASH_REMATCH[1]}; fi

curl $cmd_tool_URL -o $ANDROID_HOME/cmd_tool.zip

unzip -n $ANDROID_HOME/cmd_tool.zip -d ${ANDROID_SDK_HOME}
find ${MVCMDTL}/.. ! -name latest -maxdepth 1 | grep -E '\.\./' | xargs -I%% mv %% ${MVCMDTL}/.
rm $ANDROID_HOME/cmd_tool.zip

# licenses accept
sdkmanager --licenses
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

