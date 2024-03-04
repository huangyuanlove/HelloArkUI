import router from '@ohos.router'

@Extend(Button)
function indexButtonStyle(path: string) {
  .type(ButtonType.Normal)
  .borderRadius(4)
  .margin(6)
  .backgroundColor($r('app.color.blue_3583ee'))
  .onClick(() => {
    router.pushUrl({ url: path })
  })
}


@Component
export struct BaseListItem {
  path: string;
  label: string;

  build() {
    Button() {
      Text(this.label)
        .fontSize(24)
        .fontColor(Color.White)
        .padding({left:10,right:10,top:4,bottom:4})
    }.indexButtonStyle(this.path)
  }
}