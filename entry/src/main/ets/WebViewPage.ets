import web_webview from '@ohos.web.webview';
import router from '@ohos.router';
import ActionBar from './comm/ActionBar';
@Component
@Entry

export struct WebViewPage{
  webviewController: web_webview.WebviewController = new web_webview.WebviewController();
  @State path:string = ""
  @State title:string = ""

  aboutToAppear(){
    const params = router.getParams(); // 获取传递过来的参数对象
    console.error("WebViewPage#aboutToAppear")
    console.error(JSON.stringify(params))
    this.path = params['path']

  }

  build(){
    Column(){
      ActionBar({title:this.title})
      Web({src:$rawfile(this.path),controller:this.webviewController}).onTitleReceive((value)=>{
        this.title = value.title
      }).height('100%').width('100%')
    }.height('100%').width('100%')
  }

}