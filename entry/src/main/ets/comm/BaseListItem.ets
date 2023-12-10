import router from '@ohos.router'

@Extend(Button)
function indexButtonStyle(path: string) {
  .type(ButtonType.Normal)
  .borderRadius(4)
  .margin(6)
  .backgroundColor($r('app.color.green_39d169'))
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
        .fontSize(18)
        .padding(2)
    }.indexButtonStyle(this.path)
  }
}