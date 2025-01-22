@Entry
@ComponentV2
struct ObservedV2TracePage {
  @Local person: Person = new Person('fang', 18)
  @Local changeCount:number = 100

  build() {
    Column() {
      Column() {
        Text('父控件中展示数据')
        Text(`${this.person.name}  ${this.person.age}  ${this.person.id}   ${this.changeCount}`)
        Row() {
          Button('修改姓名').onClick((_) => {
            this.person.name = 'liang'
          })
          Button('修改年龄').onClick((_) => {
            this.person.age = Math.floor(Math.random() * 80)
          })
          Button('重新赋值').onClick((_) => {
            this.person = new Person('重新赋值', 22)
          })
          Button('changeCount').onClick((_) => {
            this.changeCount ++
          })
        }
      }.padding(10).borderRadius(2).backgroundColor("#896d93").margin(10)

      ChildPersonComponent1({ person: this.person,changeCount:this.changeCount }).margin(10)
      ChildPersonComponent2({changeCount:this.changeCount,changeCountFactory:()=>{
        this.changeCount ++
      }}).margin(10)
      ChildPersonComponent3({ person: this.person }).margin(10)

    }
    .height('100%')
    .width('100%')
  }
}


@ComponentV2
struct ChildPersonComponent1 {
  @Param @Require person: Person
  @Once @Param changeCount: number = 0

  build() {
    Column() {
      Text('子组件中展示数据，父组件传入,子组件直接修改对象属性值')
      Text(`${this.person.name}  ${this.person.age}  ${this.person.id}  ${this.changeCount}`)
      Row() {
        Button('修改姓名').onClick((_) => {
          this.person.name = 'liang'
        })
        Button('修改年龄').onClick((_) => {
          this.person.age = Math.floor(Math.random() * 80)
        })
        Button('修改id').onClick((_) => {
          this.person.id = Math.floor(Math.random() * 80)
        })
        Button('修改changeCount').onClick((_) => {
          this.changeCount ++
        })

      }.margin(10)
    }.padding(10).borderRadius(2).backgroundColor("#8c7500")
  }
}


@ComponentV2
struct ChildPersonComponent2 {
  @Param person: Person = new Person('子组件初始化', 11)

  @Require @Param changeCount:number

  // 值得注意的是，使用@Event修改父组件的值是立刻生效的，但从父组件将变化同步回子组件的过程是异步的，
  // 即在调用完@Event的方法后，子组件内的值不会立刻变化。
  // 这是因为@Event将子组件值实际的变化能力交由父组件处理，
  // 在父组件实际决定如何处理后，将最终值在渲染之前同步回子组件。
  @Event changeCountFactory:()=>void

  build() {
    Column() {
      Text('子组件中展示数据,本地初始化')
      Text(`${this.person.name}  ${this.person.age}  ${this.person.id}    ${this.changeCount}`)
      Row() {
        Button('修改姓名').onClick((_) => {
          this.person.name = 'liang'
        })
        Button('修改年龄').onClick((_) => {
          this.person.age = Math.floor(Math.random() * 80)
        })
        Button('修改id').onClick((_) => {
          this.person.id = Math.floor(Math.random() * 80)
        })
      }
      Row(){
        Button('通过@Event修改changeCount').onClick((_) => {
          this.changeCountFactory()
        })
      }
    }.padding(10).borderRadius(2).backgroundColor("#8c7500")
  }
}

@ComponentV2
struct ChildPersonComponent3 {
  @Once @Param @Require person: Person

  build() {
    Column() {
      Text('子组件中展示数据,父控件传递，@Once修饰 子组件直接修改')
      Text(`${this.person.name}  ${this.person.age}  ${this.person.id}`)
      Row() {
        Button('修改姓名').onClick((_) => {
          this.person.name = 'liang'
        })
        Button('修改年龄').onClick((_) => {
          this.person.age = Math.floor(Math.random() * 80)
        })
        Button('修改id').onClick((_) => {
          this.person.id = Math.floor(Math.random() * 80)
        })
      }
    }.padding(10).borderRadius(2).backgroundColor("#8c7500").margin(10)
  }
}


@ObservedV2
class Person {
  constructor(name: string, age: number) {
    this.name = name
    this.age = age
    this.id = Math.floor(Math.random() * 100)
  }

  @Trace name: string = ''
  @Trace age: number = -1
  id: number = -1
}

