import common from '@ohos.app.ability.common'
import ActionBar from '../../../comm/ActionBar'
import Want from '@ohos.app.ability.Want'

@Entry
@Component
struct AboutStateAnnoPage {
  url =
    'https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/arkts-state-0000001474017162-V3?catalogVersion=V3'
  @State person1: Person = new Person()
  @State person2: Person = new Person()
  @State person3: Person = new Person()
  @State person4: Person = new Person()
  @State person5: Person = new Person()

  build() {
    Column() {
      ActionBar({ title: '@State' })
      AboutStateAnno()
      Column() {
        Text(`person1.add: ${this.person1.age}`)
          .onClick((_) => {
            let tmp = this.person1
            AddAge.addAge(tmp)
          }).padding(10).margin(10)
        Text(`person2.add:${this.person2.age}`).onClick((_) => {
          let tmp = this.person2
          new AddAge1().addAge(tmp)
        }).padding(10).margin(10)
        Text(`person3.add:${this.person3.age}`).onClick((_) => {
          let tmp = this.person3
          this.addAge1(tmp)
        }).padding(10).margin(10)
        Text(`person4.add:${this.person4.age}`).onClick((_) => {
          this.addAge()
        }).padding(10).margin(10)
        Text(`person5.add:${this.person5.age}`).onClick((_) => {
          this.person5.age += 2;
        }).padding(10).margin(10)
      }.margin(10)
    }.height('100%')
    .width('100%')
  }

  addAge() {
    this.person4.age += 2
  }

  addAge1(person: Person) {
    person.age += 2
  }
}


class Person {
  age: number = 0
}

class AddAge {
  static addAge(person: Person) {
    person.age += 2
  }
}

class AddAge1 {
  addAge(person: Person) {
    person.age += 2
  }
}


class OutClass {
  constructor(outClassName: string) {
    this.outClassName = outClassName
    this.innerClass = new InnerClass(`${outClassName}_innerClass`)
  }

  outClassName: string
  innerClass: InnerClass
}

class InnerClass {
  constructor(innerClassName: string) {
    this.innerClassName = innerClassName
  }

  innerClassName: string
}

@Component
struct AboutStateAnno {
  @State count: number = 0
  @State grade: string = 'a'
  @State success: boolean = false
  @State outClass: OutClass = new OutClass("out_class")

  build() {
    Column() {
      Text(`count: ${this.count}`)
      Text(`grade: ${this.grade}`)
      Text(`success: ${this.success}`)
      Text(`out_class_name: ${this.outClass.outClassName}`)
      Text(`inner_class_name: ${this.outClass.innerClass.innerClassName}`)
      Button('改变简单数据,UI刷新').onClick((_) => {
        this.count++
        this.grade += this.grade
        this.success = !this.success
      })
      Button('改变outClassName,UI刷新').onClick((_) => {
        this.outClass.outClassName = 'out_afterChange'
      })
      Button('改变innerClassName,UI不刷新').onClick((_) => {
        this.outClass.innerClass.innerClassName = 'inner_afterChange'
      })
      Button('改变innerClass,UI刷新').onClick((_) => {
        this.outClass.innerClass = new InnerClass('new inner_class')
      })

    }.margin(10).borderRadius(10).backgroundColor(Color.Gray).padding(10)
  }
}