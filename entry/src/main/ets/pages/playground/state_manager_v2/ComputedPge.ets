import hilog from '@ohos.hilog';

@Entry
@ComponentV2
struct ComputedPge {
  @Local name: string = 'xuan';
  @Local age: number = 18;
  @Local address:string='北京'

  @Local person:Person = new Person()

  @Computed
  get info() {
    hilog.error(0x01,'ComputedPge',"获取所有信息");
    return `name:${this.name} ,age:${this.age} , address:${this.address}`
  }

  build() {
    Column() {

      Text(`${this.info}`)
      Text(`${this.info}`)
      Text(`${this.info}`)

      Button('修改简单属性').onClick(() => {
        this.age++;
      })

      Text(`${this.person.info}`)
      Text(`${this.person.info}`)
      Text(`${this.person.info}`)
      Button('修改').onClick(() => {
        this.person.name +='p'
      })
    }
  }
}

@ObservedV2
class Person{
  @Trace name:string =''
  @Trace age:number = 0

  @Computed
  get info(){
    hilog.error(0x01,'ComputedPge',"在数据类中获取所有信息");
    return `name:${this.name} , age:${this.age}`
  }
}