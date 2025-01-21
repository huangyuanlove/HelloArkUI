import { UIUtils } from '@kit.ArkUI'

@Entry
@ComponentV2
struct ObservedV2TracePage {

 @Local person:Person = new Person('fang',18)

  build() {
    Column() {
      Text(`${this.person.name }  ${this.person.age }  ${this.person.id }`)


      Row(){
        Button('修改姓名').onClick((_)=>{
          this.person.name = 'liang'
        })
        Button('修改年龄').onClick((_)=>{
          this.person.age = Math.floor(Math.random() * 80)
        })
        Button('修改id').onClick((_)=>{
          this.person.id = Math.floor(Math.random() * 80)
        })
      }
    }
    .height('100%')
    .width('100%')
  }
}


@ObservedV2
class Person{
  constructor(name: string, age: number) {
    this.name = name
    this.age = age
    this.id = Math.floor(Math.random() * 100)
  }


  @Trace name:string = ''
  @Trace age:number = -1
  id:number = -1

}

