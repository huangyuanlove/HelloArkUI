
cd my_flutter_module
flutter clean
flutter pub get
flutter build har --debug
cd ..

echo 'delete har dir'
rm -rf har/

echo 'copy flutter_module har dir'
cp -r my_flutter_module/.ohos/har .

hvigorw clean
ohpm clean
ohpm install --all --registry https://repo.harmonyos.com/ohpm/ --strict_ssl true
hvigorw --sync -p product=default --analyze=normal --parallel --incremental --daemon
