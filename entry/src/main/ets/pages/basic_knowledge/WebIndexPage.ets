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
        Flex({wrap:FlexWrap.Wrap}){
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
            router.pushUrl({ url: "WebViewPage", params: { 'path': "https://www.jetbrains.com/idea/download/?section=windows" } })
          })
          Button("选择文件").onClick(() => {
            router.pushUrl({ url: "WebViewPage", params: { 'rawFile': "upload_file.html" } })
          })
          Button("调用h5").onClick(() => {
            router.pushUrl({ url: "WebViewPage", params: { 'rawFile': "with_native.html" } })
          })
          Button("加载pdf").onClick(() => {
            router.pushUrl({ url: "WebViewPage", params: { 'rawFile': "MshMDL_v1.1.pdf" } })
          })
          Button("自定义页面请求响应").onClick(() => {
            router.pushUrl({ url: "WebViewPage", params: { 'rawFile': "onInterceptRequest.html" } })
          })

        }
      }
    }
    .height('100%')
    .width('100%')
  }
}