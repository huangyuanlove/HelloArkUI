@echo off


cd my_flutter_module
flutter clean & flutter pub get & flutter build har --debug & cd .. & rd /s /q har & xcopy "my_flutter_module\.ohos\har" ".\har" /e /i /h /k /y & hvigorw clean &  pause
