import router from '@ohos.router';
import { MyComponent, MyComponentController } from '../../component/CustomMethodAndMemeber';
import ActionBar from '../../comm/ActionBar';

@Entry
@Component
struct Base {
  @State message: string = 'Hello World'

  myClickHandler(): void {
    this.message = "hello arkUI"
  }

  controller = new MyComponentController();

  build() {

    Column() {
      // ActionBar({ title: '点击事件绑定' })
      ActionBar()
      Text("使用lambda表达式配置组件的事件方法")
        .onClick(() => {
          this.message = "hello arkUI"
        })
        .backgroundColor('#aaaaaa')
        .fontSize(20)
        .margin({
          top: 20
        })
      Divider().margin({
        top: 10
      })
      Text('使用匿名函数表达式配置组件的事件方法，要求使用bind，以确保函数体中的this指向当前组件。api12没有这种写法')
        .onClick(()=>{
          this.message = "hello arkUI"
        })
        .backgroundColor('#aaaaaa')
        .fontSize(20)
        .margin({
          top: 20
        })

      Text('使用组件的成员函数配置组件的事件方法。')
        .onClick(this.myClickHandler)
        .margin({
          top: 20
        })
        .backgroundColor('#aaaaaa')


      MyComponent({ controller: this.controller, message: "自定义属性方法 使用Controller" })
        .onClick(() => {
          this.controller.updateMessage("点击之后")
        }
        ).margin({
        top: 20
      })
      MyComponent({ message: "尝试直接修改属性" })
        .onClick(()=>{
          console.log("this指向", this)

        }).margin({
        top: 20
      })


      Text(this.message)
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .margin({
          top: 20
        })
      Button() {
        Text('Next 页面跳转')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
      }
      .type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor('#39d167')
      .width('40%')
      .height('5%')
      .onClick(() => {
        router.pushUrl({ url: 'pages/basic_knowledge/Second' })
      })

    }.width('100%').height('100%')
  }
}