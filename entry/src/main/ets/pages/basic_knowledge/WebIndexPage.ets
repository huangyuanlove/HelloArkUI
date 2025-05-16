import { ActionBar } from '../../comm/ActionBar';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct WebIndexPage {
  @State message: string = 'Hello World';

  build() {
    Column() {
      ActionBar({title:"web demo"})
      Scroll(){
        Flex(){
          Button("基础").onClick(() => {
            router.pushUrl({ url: "WebViewPage", params: { 'path': "developer.huawei.com/consumer/cn/develop/" } })
          })
          Button("定位").onClick(() => {
            router.pushUrl({ url: "WebViewPage", params: { 'rawFile': "getLocation.html" } })
          })
          Button("运动和方向传感器").onClick(() => {
            router.pushUrl({ url: "WebViewPage", params: { 'rawFile': "Accelerometer.html" } })
          })
          Button("下载").onClick(() => {
            router.pushUrl({ url: "WebViewPage", params: { 'path': "developer.huawei.com/consumer/cn/develop/" } })
          })
        }
      }
    }
    .height('100%')
    .width('100%')
  }
}