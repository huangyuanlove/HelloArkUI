@Entry
@Component
struct AboutLocalStorage{
  build(){
    Column() {
      Text('@Observed装饰器和@ObjectLink装饰器：嵌套类对象属性变化,用于在涉及嵌套对象或数组的场景中进行双向数据同步：')
        .margin(10)
        .padding(10)
        .fontSize(20)
        .backgroundColor(Color.Gray)
        .fontColor(Color.White)
        .borderRadius(8)
    }
  }
}