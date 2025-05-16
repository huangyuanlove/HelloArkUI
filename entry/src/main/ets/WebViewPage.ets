import web_webview from '@ohos.web.webview';
import router from '@ohos.router';
import { abilityAccessCtrl, common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';





@Entry
@Component
struct WebViewPage {
  webviewController: web_webview.WebviewController = new web_webview.WebviewController();
  @State path: string  = ""
  @State resourcePath:Resource = $rawfile('debug.html')
  @State title: string = ""
  @State progressValue: number = 0
  @State firstLoad:boolean = true





  aboutToAppear() {
    const params = router.getParams() as Record<string,string>; // 获取传递过来的参数对象
    console.error("WebViewPage#aboutToAppear")
    console.error(JSON.stringify(params))
    let paramsPath: string = params['path'];
    let rawFile:string = params['rawFile']
    if(paramsPath){
      this.path = paramsPath;
    }else if(rawFile){
      this.resourcePath = $rawfile(rawFile)
    }
  }

  onBackPress(): boolean | void {
    return this.goBack()
  }

  goBack():boolean{
    if(this.webviewController.accessBackward()){
      this.webviewController.backward()
    }else{
      router.back()
    }
    return true
  }

  build() {
    Column() {
      Row(){
        Image($r('app.media.action_bar_go_back'))
          .objectFit(ImageFit.Cover)
          .margin({ left: 15 })
          .width(12)
          .height(20)
          .onClick((event) => {
            this.goBack()
          }).margin({right:10,left:15})
        Text(this.title).layoutWeight(1).maxLines(1).ellipsisMode(EllipsisMode.END).fontSize(18)
      }
      if (this.progressValue < 100) {
        Progress({ value: this.progressValue, type: ProgressType.Linear, total: 100 }).color(Color.Blue) .width("100%")
      }
      Stack() {
        Web({ src: this.path.length>0 ?this.path: this.resourcePath, controller: this.webviewController })
          .onTitleReceive((value) => {
            this.title = value.title
          }).onPageEnd((event) => {
          this.progressValue = 100
          this.firstLoad = false
        }).onProgressChange((event)=>{
          this.progressValue = event.newProgress

        }).onPageEnd((value)=>{
          console.error("onPageEnd-->" + value.url)
          this.firstLoad =false;
        }).onErrorReceive((error)=>{
          console.error("onErrorReceive-->" + JSON.stringify(error.error))
        })
          //定位
          .geolocationAccess(true)
          .onGeolocationShow((event)=>{
            AlertDialog.show({
              title: '位置权限请求',
              message: '是否允许获取位置信息',
              primaryButton: {
                value: '拒绝',
                action: () => {
                  if (event) {
                    event.geolocation.invoke(event.origin, false, false); // 不允许此站点地理位置权限请求
                  }
                }
              },
              secondaryButton: {
                value: '允许',
                action: () => {
                  if (event) {
                    let context = getContext(this) as common.UIAbilityContext;
                    let atManager = abilityAccessCtrl.createAtManager();
                    atManager.requestPermissionsFromUser(context, ["ohos.permission.APPROXIMATELY_LOCATION","ohos.permission.LOCATION"]).then((data) => {
                      event.geolocation.invoke(event.origin, true, false); // 允许此站点地理位置权限请求
                    }).catch((error: BusinessError) => {
                      console.error(`Failed to request permissions from user. Code is ${error.code}, message is ${error.message}`);
                    })
                  }
                }
              },
              cancel: () => {
                if (event) {
                  event.geolocation.invoke(event.origin, false, false); // 不允许此站点地理位置权限请求
                }
              }
            })

          })


          //权限申请
          .onPermissionRequest((event)=>{
            console.error("web申请权限",event.request.getAccessibleResource())
            AlertDialog.show({
              title: '权限申请',
              message: event.request.getAccessibleResource().toString(),
              primaryButton: {
                value: '拒绝',
                action: () => {
                  event.request.deny();
                }
              },
              secondaryButton: {
                value: '允许',
                action: () => {
                  event.request.grant(event.request.getAccessibleResource());
                }
              },
              autoCancel: false,
              cancel: () => {
                event.request.deny();
              }
            })
          })


          .layoutWeight(1)
          .width('100%')
        if(this.firstLoad){
          LoadingProgress().color(Color.Blue).width("20%").height("20%")
        }
      }.layoutWeight(1)
      .width('100%')
      .alignContent(Alignment.Center)




    }.height('100%').width('100%')
  }
}

