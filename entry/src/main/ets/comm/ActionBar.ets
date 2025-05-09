import { router } from '@kit.ArkUI';


@Component
@Preview
struct ActionBar {
  @Prop title: string = ''
  @Prop rightImage?: Resource = undefined
  @Prop rightText: string = ''
  @Prop showBack: boolean = true;
  @Prop showDivider: boolean = true
  onClickBack: ((event: ClickEvent) => void) | undefined
  onClickRight: ((event: ClickEvent) => void) | undefined

  build() {
    Column() {
      Stack() {
        Text(this.title)
          .fontSize(18)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .maxLines(1)
          .wordBreak(WordBreak.BREAK_WORD)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .layoutWeight(1)
          .fontColor(Color.Black)
        Row() {
          Row() {
            if (this.showBack) {
              Image($r('app.media.action_bar_go_back'))
                .objectFit(ImageFit.Cover)
                .margin({ left: 15 })
                .width(12)
                .height(20)
                .onClick((event) => {
                  if (this.onClickBack) {
                    this.onClickBack(event)
                  } else {
                    router.back()
                  }
                })
            }
          }.width(44)

          Row() {
            if (this.rightImage != null) {
              Image(this.rightImage)
            }
            if (this.rightText.length > 0) {
              Text(this.rightText).fontColor(Color.White).fontSize(16)
            }
          }
          .margin({ right: 15 })
          .onClick((event) => {
            if (this.onClickRight) {
              this.onClickRight(event)
            }
          })
        }.width('100%').height(44).justifyContent(FlexAlign.SpaceBetween)
      }.width('100%').height('44')

      if (this.showDivider) {
        Divider().vertical(false).color("#f7f7f7").strokeWidth(1).width('100%')
      }
    }.backgroundColor(Color.White).expandSafeArea([SafeAreaType.KEYBOARD], [SafeAreaEdge.TOP])
  }
}

export { ActionBar }