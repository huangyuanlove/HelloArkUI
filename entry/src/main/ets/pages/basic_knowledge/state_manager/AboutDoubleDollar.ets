import { ActionBar } from  '../../../comm/ActionBar';
@Entry
@Component
struct AboutDoubleDollar {
  @State customPopup: boolean = false;
  build() {
    Column() {
      ActionBar({ title: '$$' })
      Text('当前$$支持基础类型变量，以及@State、@Link和@Prop装饰的变量。\n\n' +
      '当前$$仅支持bindPopup属性方法的show参数，Radio组件的checked属性，Refresh组件的refreshing参数。\n\n' +
      '$$绑定的变量变化时，会触发UI的同步刷新。').fontColor(Color.White).fontSize(18).backgroundColor(Color.Gray).borderRadius(10).margin(10).padding(10)


      Button('Popup')
        .margin(20)
        .onClick(() => {
          this.customPopup = !this.customPopup
        })
        .bindPopup($$this.customPopup, {
          message: 'showPopup'
        })
    }
  }
}