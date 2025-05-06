
import { GeneratedPluginRegistrant } from '@ohos/flutter_module';
import { FlutterEngine, FlutterEntry } from '@ohos/flutter_ohos';
import { MyFlutterPlugin } from './MyFlutterPlugin';

export class MyFlutterEntry  extends FlutterEntry {
  configureFlutterEngine(flutterEngine: FlutterEngine): void {
    super.configureFlutterEngine(flutterEngine)
    console.error("MyFlutterEntry configureFlutterEngine")
    GeneratedPluginRegistrant.registerWith(flutterEngine)
    this.delegate?.addPlugin(new MyFlutterPlugin())
  }
}

