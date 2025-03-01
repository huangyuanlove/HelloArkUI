import { LengthMetrics, router, UIUtils } from '@kit.ArkUI';
import { JSON } from '@kit.ArkTS';
import hilog from '@ohos.hilog';


@Entry
@ComponentV2
struct StateManagerV2Page {
  @Local message: string = 'Hello World';
  @Local numberList: number[] = [1, 2, 3, 4, 5, 6]
  @Local person: Person = new Person()
  @Local count: number = 4
  @Local fontColor: string = '#ff6134'
  @Local fontSize: number = 14
  @Local jsonPerson: Person | undefined = undefined

  aboutToAppear(): void {
    this.person.name = 'xuan'
    this.person.age = 18

    let personJSON: string = `
    {
    "name": "huangyuan",
    "age": 19,
    "address": {
        "zipCode": "111111",
        "city": "shangdong"
    }
}
    `

    let tmp = JSON.parse(personJSON) as Person
    this.jsonPerson = UIUtils.makeObserved(tmp)



  }

  build() {
    Column() {
      // Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(5), cross: LengthMetrics.vp(5) } }) {
      //   Button('ObservedV2 & Trace & Param & Local & Event').onClick((_) => {
      //     router.pushUrl({ url: "pages/playground/state_manager_v2/ObservedV2TracePage" })
      //   })
      //
      //   Button('Provider & Consumer').onClick((_) => {
      //     router.pushUrl({ url: "pages/playground/state_manager_v2/ProviderConsumerPage" })
      //   })
      //
      //   Button('Monitor').onClick((_) => {
      //     router.pushUrl({ url: "pages/playground/state_manager_v2/MonitorPage" })
      //   })
      //   Button('Computed').onClick((_) => {
      //     router.pushUrl({ url: "pages/playground/state_manager_v2/ComputedPge" })
      //   })
      //   Button('makeObserved').onClick((_) => {
      //     router.pushUrl({ url: "pages/playground/state_manager_v2/MakeObservedPage" })
      //   })
      // }
      //
      // Column() {
      //   Text('父组件内容')
      //   Text(`${this.person.name}  ${this.person.age}`)
      //   Text(`${this.count}`)
      //   Text(`${this.person.address.zipCode}  ${this.person.address.city}`)
      //
      //   PersonView({ person: this.person, count: this.count }).margin(10).backgroundColor("#66ace4")
      //   PersonView2({ person: this.person, count: this.count }).margin(10).backgroundColor("#66ace4")
      //   Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(5), cross: LengthMetrics.vp(5) } }) {
      //     Button('修改Person属性').onClick((_) => {
      //       this.person.age += 3
      //       this.person.name += 'c'
      //     })
      //     Button('修改Count').onClick((_) => {
      //       this.count += 7
      //     })
      //     Button('修改 address属性').onClick((_) => {
      //       this.person.address.zipCode += '9'
      //       this.person.address.city += 'w'
      //     })
      //     Button('对Person重新赋值').onClick((_) => {
      //       this.person = new Person()
      //       this.person.name = 'new person'
      //       this.person.age = 22
      //     })
      //   }
      // }.margin(10).backgroundColor("#55ff6134")
      //
      // ShowEventAnno({
      //   fontColor: this.fontColor,
      //   fontSize: this.fontSize,
      //   changeFontColor: () => {
      //     if (this.fontColor == '#ff6134') {
      //       this.fontColor = '#39d167'
      //     } else {
      //       this.fontColor = '#ff6134'
      //     }
      //   },
      //   changeFontSize: (size: number) => {
      //     this.fontSize = size
      //   }
      // })

      if (this.jsonPerson) {
        Text(`${this.jsonPerson.name}`)
        Text(`${this.jsonPerson.age}`)
        Text(`${this.jsonPerson.address.zipCode}`)
        Text(`${this.jsonPerson.address.city}`)

        Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(5), cross: LengthMetrics.vp(5) } }) {
          Button('修改name').onClick((_) => {
            if (this.jsonPerson) {
              this.jsonPerson.name += 'b'
            }
          })
          Button('修改age').onClick((_) => {
            if (this.jsonPerson) {
              this.jsonPerson.age += 2
            }
          })
          Button('修改address.zipCode').onClick((_) => {
            if (this.jsonPerson) {
              this.jsonPerson.address.zipCode += 'w'
            }
          })
          Button('修改address.city').onClick((_) => {
            if (this.jsonPerson) {
              this.jsonPerson.address.city += 'q'
            }
          })
          Button('makeObserved 转为json').onClick((_)=>{
            hilog.error(0x01,'StateManagerV2Page',`toJSON: ${JSON.stringify(this.jsonPerson)}`)
          })
          Button('new对象 转为json').onClick((_)=>{
            hilog.error(0x01,'StateManagerV2Page',`toJSON: ${JSON.stringify(this.person)}`)
          })
        }
      }

      Divider().vertical(false).strokeWidth(5).color("#f7f7f7")
      Star({count:this.count!!})
      Divider().vertical(false).strokeWidth(5).color("#f7f7f7")
      Star({count:this.count})

    }

    .height('100%')
    .width('100%')
  }
}


@ComponentV2
struct Star{

  @Param @Require count:number
  @Event $count:(val:number) => void

  build() {
    Column(){
      Text(`value ${this.count}`)
      Button('改变value').onClick((_)=>{

        this.$count(this.count + 1)
      })
    }
  }
}


@ComponentV2
struct PersonView {
  @Require @Param person: Person = new Person()
  @Param count: number = 0

  build() {
    Column() {
      Text('子组件内容，未被@Once 修饰')
      Text(`${this.person.name}  ${this.person.age}`)
      Text(`${this.count}`).onClick((_) => {
        this.person.name += 'a'
        this.person.age++
      })
      Text(`${this.person.address.zipCode}  ${this.person.address.city}`)


    }
  }
}

@ComponentV2
struct PersonView2 {
  @Require @Param @Once person: Person = new Person()
  @Once @Param count: number = 0

  build() {
    Column() {
      Text('子组件内容，被@Once 修饰')
      Text(`${this.person.name}  ${this.person.age}`)
      Text(`${this.count}`).onClick((_) => {
        this.person.name += 'a'
        this.person.age++
      })
      Text(`${this.person.address.zipCode}  ${this.person.address.city}`)
    }
  }
}


@ComponentV2
struct ShowEventAnno {
  @Event changeFontColor: () => void
  @Event changeFontSize: (size: number) => void
  @Require @Param fontColor: string
  @Require @Param fontSize: number

  build() {
    Column() {
      Text('ShowEventAnno View').fontColor(this.fontColor).fontSize(this.fontSize)
      Row() {
        Button('修改文字大小').onClick((_) => {
          if (this.changeFontSize) {
            this.changeFontSize(this.fontSize + 2)
          }
        })
        Button('修改文字颜色').onClick((_) => {
          if (this.changeFontColor) {
            this.changeFontColor()
          }
        })
      }
    }
  }
}


@ObservedV2
class Person {
  @Trace name: string = ''
  @Trace age: number = 0
  @Trace address: Address = new Address()
}

@ObservedV2
class Address {
  @Trace zipCode: string = '000000'
  @Trace city: string = '北京'
}