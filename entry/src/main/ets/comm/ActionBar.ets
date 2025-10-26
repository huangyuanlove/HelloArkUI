import { router } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';


@Component
@Preview
struct ActionBar {
  @Prop title: string = ''
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
            Image($r('app.media.source_code')).fitOriginalSize(true).onClick((_)=>{

                let targetURL =' https://gitcode.com/huangyuan_xuan/HelloArkUI'
              let want: Want = {
                action: 'ohos.want.action.viewData',
                entities: ['entity.system.browsable'],
                uri: targetURL
              };
              (this.getUIContext().getHostContext() as  common.UIAbilityContext) .startAbility(want).then(() => {
              }).catch((err: BusinessError<Object>) => {
                hilog.error(0x01, 'toExternalWeb', '打开系统浏览器失败--> ' + JSON.stringify(err))
              });
            })
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