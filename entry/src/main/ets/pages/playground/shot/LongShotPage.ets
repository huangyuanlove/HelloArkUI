import { HMRouter } from '@hadss/hmrouter';
import { ActionBar } from '../../../comm/ActionBar';


@HMRouter({ pageUrl: "playground/shot/LongShotPage" })
@Entry
@ComponentV2
export struct LongShotPage {
  data: number[] =
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
  imageResource: Resource[] =
    [$r('app.media.product00'), $r('app.media.product01'), $r('app.media.product02'), $r('app.media.product03'),
      $r('app.media.product04')]

  build() {
    Column() {
      ActionBar({ title: "长截图" })
      List({ space: 20 }) {
        ForEach(this.data, (item: number, index: number) => {
          ListItem() {
            Row() {
              Image(this.imageResource[index % this.imageResource.length])
                .width(40)
                .height(40)
                .objectFit(ImageFit.Contain)
              Column() {
                Text('这是标题').fontSize(18).fontColor("#333333")
                Text('这是长描述长描述长描述长描述').fontSize(14).fontColor("#666666")
              }.padding({ left: 8 }).layoutWeight(1).alignItems(HorizontalAlign.Start)
            }.width('100%').padding({ top: 10, bottom: 10 }).backgroundColor(Color.White).borderRadius(8)
          }.width('100%').padding({ left: 15, right: 15 })
        })
      }.width('100%').layoutWeight(1).edgeEffect(EdgeEffect.Fade).id('list')

      Row() {
        Button('一键截图')
        Button('滚动截图')
        Button('截图水印')
      }.width('100%').justifyContent(FlexAlign.SpaceEvenly)
    }.height('100%')
    .width('100%')
    .backgroundColor("#f7f7f7")
  }
}