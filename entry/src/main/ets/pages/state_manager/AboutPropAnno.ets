import common from '@ohos.app.ability.common'
// import CustomDialogController from
@Entry
@Component
struct AboutPropAnno {
  @State countDownStartValue: number = 10;
  @State arr: number[] = [1, 2, 3];
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({}),

    autoCancel: true,
    alignment: DialogAlignment.Default,
    offset: { dx: 0, dy: 0 },
  })

  // 在自定义组件即将析构销毁时将dialogControlle删除和置空
  aboutToDisappear() {
    delete this.dialogController, // 删除dialogController
    this.dialogController = undefined // 将dialogController置空
  }

  build() {
    Column() {
      Text('@State装饰器：组件内状态,使用场景：父组件@State到子组件@Prop数据同步')
        .padding(10)
        .margin(10)
        .backgroundColor(Color.Gray)
        .fontColor(Color.White)
        .borderRadius(10)
        .fontSize(20)

      Column() {
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


      Column() {
        Text("数组同步注意事项：假设我们点击了多次，所有变量的本地取值都是“7”。单击重置按钮后，会展示什么信息")
          .fontSize(20).margin(10).fontColor(Color.White)
          .onClick(() => {
            if (this.dialogController != undefined) {
              console.error('huangyuan', '调用打开弹窗方法')
              this.dialogController.open()
            } else {
              console.error('huangyuan', '无法打开弹窗')
            }
          })
        Row() {
          Child({ value: this.arr[0] }).layoutWeight(1)
          Child({ value: this.arr[1] }).layoutWeight(1)
          Child({ value: this.arr[2] }).layoutWeight(1)
        }.width('100%').alignItems(VerticalAlign.Center).justifyContent(FlexAlign.Center)


        Divider().height(5).backgroundColor(Color.White).margin(10)


        Row() {
          ForEach(this.arr,
            item => {
              Child({ value: item })
            },
            item => item.toString()
          )
        }.width('100%').alignItems(VerticalAlign.Center).justifyContent(FlexAlign.Center)

        Text('重置')
          .fontSize(30)
          .onClick(() => {
            // 两个数组都包含项“3”。
            this.arr = this.arr[0] == 1 ? [3, 4, 5] : [1, 2, 3];
          })
      }.borderRadius(10).backgroundColor('#aaaaaa')
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
      .onClick(() => {
        this.value++
      })
  }
}

@CustomDialog
struct CustomDialogExample {
  private customController: CustomDialogController

  build() {
    Column() {
      Text('在子组件Child中做的所有的修改都不会同步回父组件Index组件，' +
      '所以即使6个组件显示都为7，但在父组件Index中，this.arr保存的值依旧是[1,2,3]。\n\n' +
      '点击replace entire arr，this.arr[0] == 1成立，' +
      '将this.arr赋值为[3, 4, 5]；因为this.arr[0]已更改，' +
      'Child({value: this.arr[0]})组件将this.arr[0]更新同步到实例@Prop装饰的变量。' +
      'Child({value: this.arr[1]})和Child({value: this.arr[2]})的情况也类似。\n\n' +
      'this.arr的更改触发ForEach更新，' +
      'this.arr更新的前后都有数值为3的数组项：[3, 4, 5] 和[1, 2, 3]。' +
      '根据diff机制，数组项“3”将被保留，删除“1”和“2”的数组项，添加为“4”和“5”的数组项。' +
      '这就意味着，数组项“3”的组件不会重新生成，而是将其移动到第一位。' +
      '所以“3”对应的组件不会更新，此时“3”对应的组件数值为“7”，' +
      'ForEach最终的渲染结果是“7”，“4”，“5”。')
        .fontSize(20).padding(10)

    }
    // dialog默认的borderRadius为24vp，如果需要使用border属性，请和borderRadius属性一起使用。
  }
}