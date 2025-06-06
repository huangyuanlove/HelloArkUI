
import 'package:flutter_router/router_manager.dart';
import 'package:my_flutter_module/login_page.dart';

import '../from_flutter_page.dart';

void initRouter(){
    RouterManager.instance.addRouter("login",(args){return LoginPage(args);});
    RouterManager.instance.addRouter("from_flutter",(args){return FromFlutterPage(args);});
}