// 将设备languageCode存入AppStorage中
import { ActionBar } from  '../../../comm/ActionBar';

Environment.EnvProp('languageCode', 'en');
let enable:number | undefined = AppStorage.Get('languageCode');

@Entry
@Component
struct AboutEnvironment {
  @StorageProp('languageCode') languageCode: string = 'en';

  build() {
    Column() {
      ActionBar({ title: 'Environment' })

      // 输出当前设备的languageCode
      Text(this.languageCode)
        .margin(10)
        .padding(10)
        .fontSize(20)
        .backgroundColor(Color.Gray)
        .fontColor(Color.White)
        .borderRadius(8)

        .onClick(() => {
          // 使用Environment.EnvProp将设备运行languageCode存入AppStorage中；
          Environment.EnvProp('languageCode', 'en');
          // 从AppStorage获取单向绑定的languageCode的变量
          const lang: SubscribedAbstractProperty<string> = AppStorage.Prop('languageCode');

          if (lang.get() === 'zh') {
            console.info('你好');
          } else {
            console.info('Hello!');
          }
        })
    }
  }
}