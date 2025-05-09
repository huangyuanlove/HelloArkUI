import { ActionBar } from '../../comm/ActionBar';
@Entry
@Component
struct AboutStateStyle {
  @Styles marginStyle(){
    .margin(10)
    .padding(10)
  }

  build() {
    Column() {
      ActionBar({ title: '组件状态：' })
      Text("提供了四种状态\nfocused：获焦态。\nnormal：正常态。\npressed：按压态。\ndisabled：不可用态。")
        .fontSize(20)
        .fontColor(Color.Black)
        .marginStyle()


      Text('Click me')

        .stateStyles({

          focused: {
            .backgroundColor(Color.Red)
          },
          pressed: {
            .backgroundColor(Color.Yellow)
          },
          normal: {
            .backgroundColor(Color.Gray)
          }

        })
        .marginStyle()
    }.height('100%')
  }
}

