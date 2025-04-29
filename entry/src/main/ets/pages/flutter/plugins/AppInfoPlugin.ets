import { MethodCall, MethodResult } from "@ohos/flutter_ohos";
import BuildProfile from "BuildProfile";

export class AppInfoPlugin{
  static async handleCall(call: MethodCall, result: MethodResult) {
    result.success({"version":BuildProfile.VERSION_NAME})
  }
}