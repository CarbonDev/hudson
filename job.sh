cd $WORKSPACE
export WORKSPACE2=$PWD
mkdir -p ../android
cd ../android
export WORKSPACE=$PWD
echo $ANDROID_JAVA_HOME

rm -rf hudson

git clone git://github.com/CarbonDev/hudson.git -b jb2
