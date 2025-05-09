import web_webview from '@ohos.web.webview';
import router from '@ohos.router';
import { ActionBar } from  './comm/ActionBar';


@Entry
@Component
struct WebViewPage {
  webviewController: web_webview.WebviewController = new web_webview.WebviewController();
  @State path: string  = ""
  @State resourcePath:Resource = $rawfile('debug.html')
  @State title: string = ""
  @State loadProgress: number = 0

  aboutToAppear() {
    const params = JSON.stringify(router.getParams()); // 获取传递过来的参数对象
    console.error("WebViewPage#aboutToAppear")
    console.error(JSON.stringify(params))
    let paramsPath: string = params['path'];
    if (paramsPath.startsWith("http") || paramsPath.startsWith("file")) {
      this.path = paramsPath;
    } else {
      this.resourcePath = $rawfile(paramsPath)
    }
  }

  build() {
    Column() {
      ActionBar({ title: this.title })
      if (this.loadProgress < 100) {
        Progress({ value: this.loadProgress, type: ProgressType.Linear, total: 100 }).color(Color.Blue) .width("100%")
      }
      Stack() {
        Web({ src: this.path.length>0 ?this.path: this.resourcePath, controller: this.webviewController })
          .onTitleReceive((value) => {
            this.title = value.title
          }).onPageEnd((event) => {
          this.loadProgress = 100
          console.error("onPageEnd")
        }).onProgressChange((event)=>{
          this.loadProgress = event.newProgress
          console.error("onProgressChange-->" + this.loadProgress)
        }).onPageEnd((value)=>{
          console.error("onPageEnd-->" + value.url)
        }).onErrorReceive((error)=>{
          console.error("onErrorReceive-->" + JSON.stringify(error.error))
        })
          .layoutWeight(1)
          .width('100%')
        if (this.loadProgress < 100) {
          LoadingProgress().color(Color.Blue).width("20%").height("20%")
        }
      }.layoutWeight(1)
      .width('100%')
      .alignContent(Alignment.Center)




    }.height('100%').width('100%')
  }
}

