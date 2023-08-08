
let localStorage = LocalStorage.GetShared() //在 EntryAbility中声明并 load，可以在多个视图中共享
@Entry(localStorage)
@Component
struct AboutLocalStorage {
  @LocalStorageLink('PropA') storLink1: number = 1;//双向同步
  @LocalStorageProp('PropA') storProp1: number = 1;//单向同步

  build() {
    Column() {
      Text('@Observed装饰器和@ObjectLink装饰器：嵌套类对象属性变化,用于在涉及嵌套对象或数组的场景中进行双向数据同步：')
        .margin(10)
        .padding(10)
        .fontSize(20)
        .backgroundColor(Color.Gray)
        .fontColor(Color.White)
        .borderRadius(8)
      Column() {
        Button(`Parent from LocalStorage with @LocalStorageLink${this.storLink1}`)
          .onClick(() => this.storLink1 += 1)
        Button(`Parent from LocalStorage with @LocalStorageProp ${this.storProp1}`)
          .onClick(() => this.storProp1 += 1).margin(10)
      }.backgroundColor(Color.Gray).padding(10).margin(10).borderRadius(8)



      LocalStorageChild().margin(10)
    }
  }
}


@Component
struct LocalStorageChild {
  // @LocalStorageLink变量装饰器与LocalStorage中的'ProA'属性建立双向绑定
  @LocalStorageLink('PropA') storLink2: number = 1;
  @LocalStorageProp('PropA') storProp2: number = 1;

  build() {
    Column() {


      Button(`Child from LocalStorage ${this.storLink2}`)
        // 更改将同步至LocalStorage中的'ProA'以及Parent.storLink1
        .onClick(() => this.storLink2 += 1).margin(10)

      Button(`Child from LocalStorage ${this.storProp2}`)
        // 更改将同步至LocalStorage中的'ProA'以及Parent.storLink1
        .onClick(() => this.storProp2 += 1)
    }.backgroundColor(Color.Gray).padding(10).margin(10).borderRadius(8)
  }
}