cd $WORKSPACE
export WORKSPACE2=$PWD
mkdir -p ../android
cd ../android
export WORKSPACE=$PWD
echo $ANDROID_JAVA_HOME

if [ -d hudson ]
then
  rm -rf hudson
fi

git clone git://github.com/CarbonDev/hudson.git -b old

cd hudson
exec ./build.sh
