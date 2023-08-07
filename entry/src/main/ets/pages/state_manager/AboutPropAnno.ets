import common from '@ohos.app.ability.common'

@Entry
@Component
struct AboutPropAnno {
  @State countDownStartValue: number = 10;
  @State arr: number[] = [1,2,3];
  @State showPropPanel:boolean =false;

  url = 'https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/arkts-prop-0000001473537702-V3?catalogVersion=V3'

  build() {
    Column() {


      Button('@State装饰器：组件内状态')
        .onClick(() => {
          let want = {
            // uncomment line below if wish to implicitly query only in the specific bundle.
            // bundleName: "com.example.myapplication",
            "action": "ohos.want.action.viewData",
            // entities can be omitted.
            "entities": ["entity.system.browsable"],
            "uri": this.url,
          }
          let context = getContext(this) as common.UIAbilityContext;
          context.startAbility(want)
          console.info(`explicit start ability succeed`)
        })
        .backgroundColor(Color.Gray)
        .margin(10)
        .borderRadius(10)
        .height(30)
        .fontSize(20)
      Text('使用场景：父组件@State到子组件@Prop数据同步')
        .padding(10)
        .margin(10)
        .backgroundColor(Color.Gray)
        .fontColor(Color.White)
        .borderRadius(10)
        .fontSize(20)

      Column(){
        Text(`Grant ${this.countDownStartValue} nuggets to play.`).margin(10)
        // 父组件的数据源的修改会同步给子组件
        Button(`+1 - Nuggets in New Game`).onClick(() => {
          this.countDownStartValue += 1;
        }).margin(10)
        // 父组件的修改会同步给子组件
        Button(`-1  - Nuggets in New Game`).onClick(() => {
          this.countDownStartValue -= 1;
        }).margin(10)

        CountDownComponent({ count: this.countDownStartValue, costOfOneAttempt: 2 }).margin(10)

      }.backgroundColor('#999999').borderRadius(10)



      Column(){
        Text("数组同步注意事项：假设我们点击了多次，所有变量的本地取值都是“7”。单击重置按钮后，会展示什么信息")
          .fontSize(20).margin(10).fontColor(Color.White)
        .onClick(()=>{
          this.showPropPanel= true;
        })
        Row(){
          Child({value: this.arr[0]}).layoutWeight(1)
          Child({value: this.arr[1]}).layoutWeight(1)
          Child({value: this.arr[2]}).layoutWeight(1)
        }.width('100%').alignItems(VerticalAlign.Center).justifyContent(FlexAlign.Center)


        Divider().height(5).backgroundColor(Color.White).margin(10)

        ForEach(this.arr,
          item => {
            Child({value: item})
          },
          item => item.toString()
        )
        Text('重置')
          .fontSize(30)
          .onClick(()=>{
            // 两个数组都包含项“3”。
            this.arr = this.arr[0] == 1 ? [3,4,5] : [1,2,3];
          })
      }.borderRadius(10).backgroundColor('#aaaaaa')
      Panel(this.showPropPanel) { // 展示日程
        Column() {
          Text('Today Calendar')
          Divider()
          Text('1. afternoon 4:00 The project meeting')
        }
      }
      .type(PanelType.Foldable)
      .mode(PanelMode.Half)
      .dragBar(true) // 默认开启
      .halfHeight(500) // 默认一半
      .onChange((width: number, height: number, mode: PanelMode) => {
        console.info(`width:${width},height:${height},mode:${mode}`)
      })
    }.height('100%')
    .width('100%')
  }
}

@Component
struct CountDownComponent {
  @Prop count: number;
  costOfOneAttempt: number = 1;

  build() {
    Column() {
      if (this.count > 0) {
        Text(`You have ${this.count} Nuggets left`)
      } else {
        Text('Game over!')
      }

      // @Prop装饰的变量不会同步给父组件
      Button(`Try again`).onClick(() => {
        this.count -= this.costOfOneAttempt;
      })
    }

  }
}

@Component
struct Child {
  @Prop value: number;

  build() {
    Text(`${this.value}`)
      .fontSize(25)
      .margin(10)
      .fontColor(Color.White)
      .backgroundColor(Color.Blue)
      .onClick(()=>{this.value++})
  }
}