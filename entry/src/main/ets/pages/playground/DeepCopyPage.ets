import { ActionBar } from '../../comm/ActionBar'
import { ObjectUtils } from '../../util/ObjectUtils'

@Entry
@Component
struct DeepCopyPage {
  @State person: Person | undefined = undefined

  aboutToAppear(): void {

    let str:string ="{\"name\":\"\",\"age\":18,\"address\":{\"zipCode\":100000,\"location\":\"北京\"}}"
    let tmpPerson:Person = JSON.parse(str)

    this.person = ObjectUtils.deepCopy<Person>(tmpPerson,new Person())

  }

  build() {
    Column() {
      ActionBar({ title: "深拷贝" })
      Text(this.person?.name)
      Text(`是否成年：${this.person?.isAdult()}`)
    }
    .height('100%')
    .width('100%')
  }
}

class Person {
  name: string = ''
  age: number = 18
  address:Address = new Address()
  isAdult(): boolean {
    return this.age >= 18
  }
}

class Address {
  zipCode: number = 100000
  location: string = '北京'
}