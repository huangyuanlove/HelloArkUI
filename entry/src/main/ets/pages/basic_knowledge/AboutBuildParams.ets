import ActionBar from '../../comm/ActionBar'
@Builder function GlobalBuilder0($$: { label: string }) {
  Text($$.label)
    .width(400)
    .height(50)
    .backgroundColor(Color.Grey)
    .padding(10)
    .margin(10)
}

@Entry
@Component
struct AboutBuildParams {
  @State label: string = 'Parent'

  @Builder componentBuilder() {
    Text(`${this.label}`).padding(10).margin(10)
  }

  build() {
    Column() {
      ActionBar({ title: '构建参数' })
      this.componentBuilder()
      Child({ aBuilder0: this.componentBuilder, aBuilder1: GlobalBuilder0 })

      CustomContainer({ header: this.label }) {
        Column() {
          specificParam('testA', 'testB')
        }
        .onClick(() => {
          this.label = 'changeHeader';
        }).margin(10).padding(10).backgroundColor('#ff6134')
      }


      Text('就是一个插槽Slot而已，表示占位，我们可以使用任意符合函数签名的方法来替换')
        .fontColor('#666666')
        .fontSize(20)
        .padding(10)
    }
    .alignItems(HorizontalAlign.Center)

  }
}


@Component
struct Child {
  label: string = 'Child'
  @BuilderParam aBuilder0: () => void;
  @BuilderParam aBuilder1: ($$: { label: string }) => void;

  build() {
    Column() {
      this.aBuilder0()
      this.aBuilder1({ label: 'global Builder label' })
    }
  }
}

@Component
struct CustomContainer {
  @Prop header: string;
  @BuilderParam closer: () => void

  build() {
    Column() {
      Text(this.header)
        .fontSize(30)
        .margin(10)
      this.closer()
    }
  }
}

@Builder function specificParam(label1: string, label2: string) {
  Column() {
    Text(label1)
      .fontSize(30)
      .margin(10)
      .padding(10)
      .backgroundColor(Color.Yellow)
    Text(label2)
      .fontSize(30)
      .margin(10).padding(10)
      .backgroundColor(Color.Blue)
  }
}

