import { ActionBar } from '../../../comm/ActionBar';
import { componentUtils, router, screenshot, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import { reqPermissionsFromUser, RequestPermissionCallBack } from '../../../util/PermissionUtils';
import { common } from '@kit.AbilityKit';
import { HMRouterMgr } from '@hadss/hmrouter';

@Entry
@Component
struct ScreenShotPage {
  @State message: string = 'Hello World';
  @State screenShot?:PixelMap = undefined

  build() {

    Column() {
      ActionBar({title:"截图相关"}).id('Rectangle')
      Flex({wrap:FlexWrap.Wrap}) {


        Button('屏幕截图').onClick((_) => {
          const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
          const uiContent = this.getUIContext()
          reqPermissionsFromUser(['ohos.permission.CUSTOM_SCREEN_CAPTURE'], context, uiContent, {
            onGrant: () => {
              screenshot.capture().then((pixelMap: image.PixelMap) => {
                this.screenShot = pixelMap
                console.error(`截图成功`)
              }).catch((error: BusinessError) => {
                console.error(`截图失败 ${error.message}   ${error.code}`)
              })
            }
          } as RequestPermissionCallBack)

        })

        Button('窗口截图').onClick((_) => {
          let context = this.getUIContext().getHostContext() as Context as common.UIAbilityContext;
          window.getLastWindow(context).then(win => {
            let promise = win.snapshot();
            promise.then((pixelMap: image.PixelMap) => {
              this.screenShot = pixelMap;
            });
          });
        })

        Button('组件截图').onClick((_)=>{
        let componentInfo: componentUtils.ComponentInfo =  this.getUIContext().getComponentUtils().getRectangleById('Rectangle')
          console.error(`componentInfo ${JSON.stringify(componentInfo)}`)
          this.getUIContext().getComponentSnapshot() .get("root", { scale: 2, waitUntilRenderFinished: true })
            .then((pixmap: image.PixelMap) => {
              this.screenShot = pixmap;
            })
            .catch((err: Error) => {
              console.error("error: " + err);
            })
        })
        Button('长截图').onClick((_)=>{

          this.getUIContext().getRouter().pushUrl({url:"pages/playground/shot/LongShotPage"})

        })
        Button('图片裁剪').onClick((_)=>{
          this.getUIContext().getRouter().pushUrl({url:"pages/playground/shot/ImageCropPage"})
        })

      }.backgroundColor(Color.Green).id('root')

      Image(this.screenShot).width('100%').objectFit(ImageFit.Contain)

    }
    .height('100%')
    .width('100%').backgroundColor(Color.Pink)
  }
}