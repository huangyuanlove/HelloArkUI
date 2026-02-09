import { ConfigurationConstant } from '@kit.AbilityKit';
import { webview } from '@kit.ArkWeb';
import { DialogHelper } from '@pura/harmony-dialog';
import { display, window } from '@kit.ArkUI';

@Entry
@Component
struct DarkThemeModelPage {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Text('深色模式适配')
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontColor($r('app.color.text_title_color'))
        .padding(15)
      Divider().vertical(false)
      Scroll() {


        Column() {
          Text('如何适配深色模式').fontSize(18).fontColor($r('app.color.text_title_color'))
          Text('1. 色值写在资源文件').fontSize(16).fontColor($r('app.color.text_subtitle_color'))
          Text('在 resource 文件夹下新建 dark/element/color.json文件，同时在该文件中配置和 base/element/color.json文件中相同的颜色名称和不同的颜色值')
            .fontSize(14)
            .fontColor($r('app.color.text_desc_color'))
          Text('在页面中应用配置文件中的色值，例如$r(\'app.color.text_title_color\')')
            .fontSize(14)
            .fontColor($r('app.color.text_desc_color'))
          Text('在手机中切换颜色模式，再返回应用').fontSize(14).fontColor($r('app.color.text_desc_color'))

          Text('2. 图片资源放在对应的文件夹中').fontSize(16).fontColor($r('app.color.text_subtitle_color'))
          Text('在 resource 文件夹下新建 dark/media/文件夹，在该文件夹下放置同名文件，深色模式下系统优先加载 dark 目录的图片')
            .fontSize(14)
            .fontColor($r('app.color.text_desc_color'))
          Text('SVG图标动态着色：使用 Image 组件的 fillColor 属性绑定颜色资源，使图标颜色随主题切换。')
            .fontSize(14)
            .fontColor($r('app.color.text_desc_color'))
          Row() {
            Image($r('app.media.color_mode_icon')).width('50%')
            Column() {
              Image($r('app.media.color_mode_icon_svg')).height('50%').objectFit(ImageFit.Contain)
              Image($r('app.media.color_mode_icon_svg'))
                .height('50%')
                .fillColor($r('app.color.text_subtitle_color'))
                .objectFit(ImageFit.Contain)
            }.height(px2vp(1024)).width('50%').justifyContent(FlexAlign.Start)
          }.width('100%').alignItems(VerticalAlign.Top)


          Text('3. 状态栏适配').fontSize(16).fontColor($r('app.color.text_subtitle_color'))
          Text('在 UIAbility 的 onConfigurationUpdate 生命周期方法中获取最新颜色模式，并通过 AppStorage 全局共享状态：')
            .fontSize(14)
            .fontColor($r('app.color.text_desc_color'))


          Text('4. webview适配').fontSize(16).fontColor($r('app.color.text_subtitle_color'))
          Text('Web组件设置：通过 Web 组件的 .darkMode(WebDarkMode.Auto) 使网页跟随系统模式，或手动设置 .darkMode(WebDarkMode.On/Off)')
            .fontSize(14)
            .fontColor($r('app.color.text_desc_color'))
          Text('强制深色转换：使用 .forceDarkAccess(true) 对未适配深色的网页进行色值算法转换（需注意部分颜色可能不符合预期）。')
            .fontSize(14)
            .fontColor($r('app.color.text_desc_color'))

          // Web({src:'https://www.baidu.com',controller:new webview.WebviewController()}).forceDarkAccess(true)

        }.width('100%').padding({ left: 15, right: 15 }).alignItems(HorizontalAlign.Start).layoutWeight(1)

      }.width('100%').layoutWeight(1).align(Alignment.Start)

      Flex({ wrap: FlexWrap.Wrap }) {
        Button('切换深色模式').onClick((_) => {
          this.getUIContext()
            .getHostContext()?.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK)
        })
        Button('切换浅色模式').onClick((_) => {
          this.getUIContext()
            .getHostContext()?.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
        })
        Button('跟随系统').onClick((_) => {
          this.getUIContext()
            .getHostContext()?.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
        })
        Button('弹窗').onClick((_) => {
          DialogHelper.showAlertDialog({
            title: "弹窗标题",
            content: "弹窗内容",
            primaryButton: '取消',
            secondaryButton: '确认',
            onAction: (action, dialogID) => {
            }
          })
        })

      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.page_background_color'))
  }
}