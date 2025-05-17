import { webview } from '@kit.ArkWeb';
import router from '@ohos.router';
import { abilityAccessCtrl, common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { picker } from '@kit.CoreFileKit';


@Entry
@Component
struct WebViewPage {
  webviewController: webview.WebviewController = new webview.WebviewController();
  downloadDelegate: webview.WebDownloadDelegate = new webview.WebDownloadDelegate();

  @State path: string = ""
  @State resourcePath: Resource = $rawfile('debug.html')
  @State title: string = ""
  @State progressValue: number = 0
  @State firstLoad: boolean = true
  responseResource: WebResourceResponse = new WebResourceResponse();
  // 开发者自定义响应数据
  @State webData: string = '<!DOCTYPE html>\n' +
    '<html>\n' +
    '<head>\n' +
    '<title>intercept test</title>\n' +
    '</head>\n' +
    '<body>\n' +
    '<h1>intercept ok</h1>\n' +
    '</body>\n' +
    '</html>'

  @State showInvokeJSButtons:boolean = false

  aboutToAppear() {
    const params = router.getParams() as Record<string, Object>; // 获取传递过来的参数对象
    console.error("WebViewPage#aboutToAppear")
    console.error(JSON.stringify(params))
    if(params['showInvokeJSButtons']){
      this.showInvokeJSButtons = params['showInvokeJSButtons'] as boolean
    }


    let paramsPath: string = params['path'] as string;



    let rawFile: string = params['rawFile'] as string
    if (paramsPath) {
      this.path = paramsPath;
    } else if (rawFile) {
      this.resourcePath = $rawfile(rawFile)
    }

    webview.WebviewController.setWebDebuggingAccess(true);
    this.initDownloadDelegate()

  }

  initDownloadDelegate(){
    this.downloadDelegate.onBeforeDownload((webDownloadItem: webview.WebDownloadItem) => {
      console.log("will start a download.");
      // 传入一个下载路径，并开始下载。
      // 如果传入一个不存在的路径，则会下载到默认/data/storage/el2/base/cache/web/目录。

     let dir =getContext().cacheDir +"/web/" + webDownloadItem.getSuggestedFileName()
      console.error("下载路径",dir)

      webDownloadItem.start(dir);
    })
    this.downloadDelegate.onDownloadUpdated((webDownloadItem: webview.WebDownloadItem) => {
      // 下载任务的唯一标识。
      console.log("onDownloadUpdated 唯一标识 guid: " + webDownloadItem.getGuid());
      // 下载的进度。
      console.log("onDownloadUpdated 下载进度百分比: " + webDownloadItem.getPercentComplete());
      // 当前的下载速度。
      console.log("onDownloadUpdated 下载速度 : " + webDownloadItem.getCurrentSpeed())
    })
    this.downloadDelegate.onDownloadFailed((webDownloadItem: webview.WebDownloadItem) => {
      console.log("onDownloadFailed 唯一标识 guid: " + webDownloadItem.getGuid());
      // 下载任务失败的错误码。
      console.log("onDownloadFailed last error code: " + webDownloadItem.getLastErrorCode());
    })
    this.downloadDelegate.onDownloadFinish((webDownloadItem: webview.WebDownloadItem) => {
      console.log("onDownloadFinish guid: " + webDownloadItem.getGuid());
    })
  }


  onBackPress(): boolean | void {
    return this.goBack()
  }

  goBack(): boolean {
    if (this.webviewController.accessBackward()) {
      this.webviewController.backward()
    } else {
      router.back()
    }
    return true
  }


  async selectFile(result: FileSelectorResult): Promise<void> {
    let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    let photoPicker = new photoAccessHelper.PhotoViewPicker();
    // 过滤选择媒体文件类型为IMAGE
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    // 设置最大选择数量
    photoSelectOptions.maxSelectNumber = 5;
    let chooseFile: picker.PhotoSelectResult = await photoPicker.select(photoSelectOptions);
    // 获取选择的文件列表
    result.handleFileList(chooseFile.photoUris);
  }



  build() {
    Column() {
      Row() {
        Image($r('app.media.action_bar_go_back'))
          .objectFit(ImageFit.Cover)
          .margin({ left: 15 })
          .width(12)
          .height(20)
          .onClick((event) => {
            this.goBack()
          })
          .margin({ right: 10, left: 15 })
        Text(this.title).layoutWeight(1).maxLines(1).ellipsisMode(EllipsisMode.END).fontSize(18)
      }

      if (this.progressValue < 100) {
        Progress({ value: this.progressValue, type: ProgressType.Linear, total: 100 }).color(Color.Blue).width("100%")
      }
      Stack() {
        Web({ src: this.path.length > 0 ? this.path : this.resourcePath, controller: this.webviewController })
          .domStorageAccess(true)
          .onInterceptRequest((event) => {
            if (event) {
              console.info('url:' + event.request.getRequestUrl());
              // 拦截页面请求
              if (event.request.getRequestUrl() !== 'https://target.do/') {
                return null;
              }
            }
            // 构造响应数据
            this.responseResource.setResponseData(this.webData);
            this.responseResource.setResponseEncoding('utf-8');
            this.responseResource.setResponseMimeType('text/html');
            this.responseResource.setResponseCode(200);
            this.responseResource.setReasonMessage('OK');
            return this.responseResource;
          })
          .onControllerAttached(()=>{
            this.webviewController.setDownloadDelegate(this.downloadDelegate)
          })
          .onTitleReceive((value) => {
            this.title = value.title
          })
          .onPageEnd((event) => {
            this.progressValue = 100
            this.firstLoad = false
          })
          .onProgressChange((event) => {
            this.progressValue = event.newProgress

          })
          .onPageEnd((value) => {
            console.error("onPageEnd-->" + value.url)
            this.firstLoad = false;
          })
          .onErrorReceive((error) => {
            console.error("onErrorReceive-->" + JSON.stringify(error.error))
          })//定位
          .geolocationAccess(true)
          .onGeolocationShow((event) => {
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
                    atManager.requestPermissionsFromUser(context,
                      ["ohos.permission.APPROXIMATELY_LOCATION", "ohos.permission.LOCATION"]).then((data) => {
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

          })//权限申请
          .onPermissionRequest((event) => {
            console.error("web申请权限", event.request.getAccessibleResource())
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
            //文件选择  用于通知Web组件文件选择的结果。
            // 返回值boolean。当返回值为true时，用户可以调用系统提供的弹窗能力。当返回值为false时，函数中绘制的自定义弹窗无效。
          .onShowFileSelector((event) => {
            let title = event.fileSelector.getTitle()
            let mode = event.fileSelector.getMode()
            let types: string[] = event.fileSelector.getAcceptType()
            let isCapture = event.fileSelector.isCapture()
            console.error(`title:${title} ,mode:${mode} ,types:${types} ,isCapture:${isCapture} `)
            this.selectFile(event.result);
            return true;
          })


          .layoutWeight(1)
          .width('100%')
        if (this.firstLoad) {
          LoadingProgress().color(Color.Blue).width("20%").height("20%")
        }
      }.layoutWeight(1)
      .width('100%')
      .alignContent(Alignment.Center)

      if(this.showInvokeJSButtons){
        Row(){
          Button('有参数')
            .onClick(() => {
              // 如果前端页面函数无参，删除param。
              this.webviewController.runJavaScript('toGreen("传入参数")');
            })
          Button('无参数')
            .onClick(() => {
              // 如果前端页面函数无参，删除param。
              this.webviewController.runJavaScript('toBlue()');
            })
          Button('注入js方法')
            .onClick(() => {
              // 传递runJavaScript侧代码方法。
              this.webviewController.runJavaScript(`function changeColor(){document.getElementById('text').style.color = 'red'}`);
            })
        }
      }

    }.height('100%').width('100%')
  }
}

