import { LengthMetrics, router } from '@kit.ArkUI';



@Entry
@ComponentV2
struct StateManagerV2Page {
  @Local message: string = 'Hello World';
  @Local numberList: number[] = [1, 2, 3, 4, 5, 6]

  @Local  person:Person = new Person()
  @Local count:number = 4

  aboutToAppear(): void {
    this.person.name ='xuan'
    this.person.age = 18
  }
  build() {
    Column() {
      Flex({ wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(5), cross: LengthMetrics.vp(5) } }) {
        Button('ObservedV2 & Trace & Param & Local & Event').onClick((_) => {
          router.pushUrl({ url: "pages/playground/state_manager_v2/ObservedV2TracePage" })
        })

        Button('Provider & Consumer').onClick((_) => {
          router.pushUrl({ url: "pages/playground/state_manager_v2/ProviderConsumerPage" })
        })

        Button('Monitor').onClick((_) => {
          router.pushUrl({ url: "pages/playground/state_manager_v2/MonitorPage" })
        })
        Button('Computed').onClick((_) => {
          router.pushUrl({ url: "pages/playground/state_manager_v2/ComputedPge" })
        })
        Button('makeObserved').onClick((_) => {
          router.pushUrl({ url: "pages/playground/state_manager_v2/MakeObservedPage" })
        })
      }

      PersonView({person:this.person,count:this.count})
      Row(){
        Button('修改Person').onClick((_)=>{
          this.person.age +=3
          this.person.name +='c'
        })
        Button('修改Count').onClick((_)=>{
          this.count +=7
        })
      }

    }

    .height('100%')
    .width('100%')
  }
}

@ComponentV2
struct PersonView {
 @Require @Param person: Person = new Person()
  @Param count:number = 0
  build() {
   Column(){
     Text(`${this.person.name}  ${this.person.age}`)
     Text(`${this.count}`) .onClick((_)=>{
       this.person.name +='a'
       this.person.age ++
     })
   }

  }
}

class Person {
  name: string = ''
  age: number = 0
}