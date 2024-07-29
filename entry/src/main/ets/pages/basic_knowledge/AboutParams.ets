/**
 * 调用@Builder装饰的函数默认按值传递。
 * 当传递的参数为状态变量时，状态变量的改变不会引起@Builder方法内的UI刷新。
 * 所以当使用状态变量的时候，推荐使用按引用传递。
 */
import ActionBar from '../../comm/ActionBar';
@Entry
@Component
struct AboutParams {
  @State label: string = 'hello @State';
  label1: string = 'hello variable'

  build() {

    Column() {
      ActionBar({ title: '参数传递' })
      ABuild({ paramsA: this.label,paramsB:this.label1 })
      Divider()
        .margin({
          top: 10,
          bottom: 10
        })
      BBuild(this.label,this.label1)

      Button() {
        Text(`修改label值  ${this.label}`).fontColor(Color.White).fontSize(20)
      }
      .type(ButtonType.Capsule)
      .onClick(() => {
        console.info("点击了更新label值")
        this.label = 'onClick'
      })
      .margin(10)
      .padding(10)
      .width('60%')
    }

  }
}

interface GeneratedTypeLiteralInterface_1 {
  paramsA: string;
  paramsB: string;
}

@Builder function ABuild($$: GeneratedTypeLiteralInterface_1) {
  Text(`按引用传递 : 状态变量--> ${$$.paramsA}  普通变量-->${$$.paramsB} `).fontSize(20).padding(10)
}

@Builder function BBuild(paramsA: string,paramsB:string) {
  Row() {
    Text(`按值传递 : 状态变量-->${paramsA}   普通变量-->${paramsB}`).fontSize(20).padding(10)
  }
}