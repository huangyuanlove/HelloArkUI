@Entry
@Component
struct AboutObservedAndObjectLinkAnno {
  build() {
    Text('@Observed装饰器和@ObjectLink装饰器：嵌套类对象属性变化')
      .margin(10)
      .padding(10)
      .backgroundColor(Color.Gray)
      .fontColor(Color.White)
      .borderRadius(8)
  }
}