@Entry
@Component
struct AboutObservedAndObjectLinkAnno {
  @State b: ClassB = new ClassB(new ClassA(0));

  build() {

    Column() {
      Text('@Observed装饰器和@ObjectLink装饰器：嵌套类对象属性变化,用于在涉及嵌套对象或数组的场景中进行双向数据同步：')
        .margin(10)
        .padding(10)
        .fontSize(20)
        .backgroundColor(Color.Gray)
        .fontColor(Color.White)
        .borderRadius(8)
      Text('@ObjectLink只能接收被@Observed装饰class的实例')
        .margin(10)
        .padding(10)
        .fontSize(20)
        .backgroundColor(Color.Gray)
        .fontColor(Color.White)
        .borderRadius(8)
      Column() {
        ViewA({ label: 'ViewA #1', a: this.b.a }).margin(10)
        ViewA({ label: 'ViewA #2', a: this.b.a }).margin(10)

        Button(`ViewB: this.b.a.c+= 1`)
          .onClick(() => {
            this.b.a.c += 1;
          }).margin(10)
        Button(`ViewB: this.b.a = new ClassA(0)`)
          .onClick(() => {
            this.b.a = new ClassA(0);
          }).margin(10)
        Button(`ViewB: this.b = new ClassB(ClassA(0))`)
          .onClick(() => {
            this.b = new ClassB(new ClassA(0));
          })
      }
      .margin(10)
      .padding(10)
      .backgroundColor(Color.Gray)
      .borderRadius(8)

    }

  }
}


@Component
struct ViewA {
  label: string = 'ViewA1';
  @ObjectLink a: ClassA;

  build() {
    Row() {
      Button(`ViewA [${this.label}] this.a.c=${this.a.c} +1`)
        .onClick(() => {
          this.a.c += 1;
        })
    }
  }
}


let NextID: number = 1;

@Observed
class ClassA {
  public id: number;
  public c: number;

  constructor(c: number) {
    this.id = NextID++;
    this.c = c;
  }
}

@Observed
class ClassB {
  public a: ClassA;

  constructor(a: ClassA) {
    this.a = a;
  }
}
