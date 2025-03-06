import hilog from '@ohos.hilog';

@Entry
@Component
struct Index {
  @State message: string = 'this is a feature hap';

  aboutToAppear(): void {
    hilog.error(0x01,'FeatureHapAbility','FeatureHapAbility index aboutToAppear')
  }

  build() {
    Row() {
      Text(this.message)
        .fontColor(Color.Pink)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          this.message = 'Welcome';
        })
    }
    .height('100%')
    .width('100%')
  }
}