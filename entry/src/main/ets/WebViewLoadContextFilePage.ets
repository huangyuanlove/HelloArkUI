import { webview } from '@kit.ArkWeb';
import { ActionBar } from './comm/ActionBar';
import { fileIo as fs } from '@kit.CoreFileKit';
import common from '@ohos.app.ability.common';
import { JSON } from '@kit.ArkTS';

@Entry
@Component
struct WebViewLoadContextFilePage {
  @State webviewController: webview.WebviewController = new webview.WebviewController()
  @State webUrl: string = "https://www.baidu.com"
  @State localFile:string = ''

  aboutToAppear(): void {
    let webData: string = '<!DOCTYPE html>\n' +
      '<html>\n' +
      '<head>\n' +
      '<title>intercept test</title>\n' +
      '</head>\n' +
      '<body>\n' +
      '<h1>intercept ok</h1>\n' +
      '</body>\n' +
      '</html>'

    let cacheDir = this.getUIContext().getHostContext()?.cacheDir
    this.localFile = cacheDir +"/local_file.html"


  }

  build() {
    Column() {
      ActionBar({ title: "webview" })
      Row() {
        Button("加载rawfile").onClick((_) => {
          this.webviewController.loadUrl($rawfile("debug.html"))
        })
        Button("加载沙箱文件").onClick((_) => {

        })
        Button("生成 pdf").onClick((_)=>{
         let pdfConfig: webview.PdfConfiguration = {
            width: 8.27,
            height: 11.69,
            marginTop: 0,
            marginBottom: 0,
            marginRight: 0,
            marginLeft: 0,
            shouldPrintBackground: true
          }
          this.webviewController.createPdf(pdfConfig,(error, result: webview.PdfData)=>{
            try {
              // 获取组件上下文
              let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
              // 获取沙箱路径，设置pdf文件名
              let filePath = context.filesDir + "/test.pdf";
              let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
              fs.write(file.fd, result.pdfArrayBuffer().buffer).then((writeLen: number) => {
                console.info("createPDF write data to file succeed and size is:" + writeLen);
              }).catch((err: BusinessError<void>) => {
                console.error("createPDF write data to file failed with error message: " + err.message +
                  ", error code: " + err.code);
              }).finally(() => {
                fs.closeSync(file);
              });
            } catch (resError) {
              console.error(`ErrorCode: ${(error as BusinessError<void>).code},  Message: ${(error as BusinessError<void>).message}`);
            }
          })
        })
      }

      Web({ controller: this.webviewController, src: this.webUrl })
    }
    .height('100%')
    .width('100%')
  }
}