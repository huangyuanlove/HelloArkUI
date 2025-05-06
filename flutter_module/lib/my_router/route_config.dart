import '../login/login_page.dart';
import 'router_manager.dart';

void setupRoutes() {
  RouteManager.instance.addRoutes([
    // RouteO(FlutterPathConfig.TEST.name, (ctx, path, args) => WidgetTestPage()),
    // RouteO(
    //     'academic',
    //     (ctx, path, args) => AcademicMain(
    //           args: args,
    //         )),
    // RouteO('academic_search', ((ctx, path, args) => AcademicSearch(args))),
    RouteO('login', ((ctx, path, args) => const LoginPage())),
    // RouteO(
    //     FlutterPathConfig.EDIT_GOOD_AT.name,
    //     (ctx, path, args) => GoodAtManagerPage(
    //           queryParams: args,
    //         )),
  
  ]);
}
