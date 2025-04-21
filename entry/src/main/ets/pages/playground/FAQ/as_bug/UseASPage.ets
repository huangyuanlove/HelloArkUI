import { hilog } from '@kit.PerformanceAnalysisKit';
import { systemDateTime } from '@kit.BasicServicesKit';


@Entry
@Component
struct UseASPage {
  @State firstLevelWithPlain?: FirstLevel = undefined
  aboutToAppear(): void {
    this.firstLevelWithPlain = {
      time: systemDateTime.getTime()
    } as FirstLevel
    this.firstLevelWithPlain.secondLevel = {
      name: "HarmonyOS",
      age: 18
    }
  }

  // this
  // .firstLevelWithClass = new FirstLevel()
  // let
  // secondLevel: SecondLevel = new SecondLevel()
  // secondLevel
  // .name = "new second level"
  // secondLevel
  // .age = 20
  // this
  // .firstLevelWithClass
  // .secondLevel = secondLevel
  // @State firstLevelWithClass?: FirstLevel = undefined

  build() {
    Column() {
      Column() {
        Text("直接观测")
        Text(`time:${this.firstLevelWithPlain?.time}`)
          .fontColor(Color.White)
        Text(`name:${this.firstLevelWithPlain?.secondLevel?.name}`)
          .fontColor(Color.White)
        Text(`age:${this.firstLevelWithPlain?.secondLevel?.age}`)
          .fontColor(Color.White)
      }.alignItems(HorizontalAlign.Start).backgroundColor("#a557c1").padding(10)

      Divider().vertical(false).margin(10)

      if (this.firstLevelWithPlain) {
        Column() {
          Text("自定义组件观测")
          ShowFistLevel({ firstLevel: this.firstLevelWithPlain })
        }.backgroundColor("#368800").padding(10)
      }


      Row() {
        Button('修改time属性').margin(10).onClick((_) => {
          if (this.firstLevelWithPlain) {
            this.firstLevelWithPlain.time = systemDateTime.getTime()
          }
        })

        Button('修改 name、age 属性').margin(10).onClick((_) => {
          if (this.firstLevelWithPlain) {
            this.firstLevelWithPlain.secondLevel.name = '新名字 ' + Math.floor(Math.random() * 10)
            this.firstLevelWithPlain.secondLevel.age = Math.floor(Math.random() * 100)
          }
        })
      }

    }
    .height('100%')
    .width('100%')
  }
}


@Component
struct ShowFistLevel {
  @ObjectLink firstLevel: FirstLevel
  build() {
    Column() {
      Text(`time:${this.firstLevel?.time}`)
        .fontColor(Color.White)
      Text(`跨层级观测name:${this.firstLevel?.secondLevel?.name}`)
        .fontColor(Color.White)
      ShowSecondLevel({ secondLevel: this.firstLevel.secondLevel })
    }.margin(15)

  }
}

@Component
struct ShowSecondLevel {
  @ObjectLink secondLevel: SecondLevel

  build() {
    Column() {
      Text(`name:${this.secondLevel?.name}`)
        .fontColor(Color.White)
      Text(`age:${this.secondLevel?.age}`)
        .fontColor(Color.White)
    }.margin(15)
  }
}


@Observed
class FirstLevel {
  time: number = 0
  secondLevel: SecondLevel = new SecondLevel()
}

@Observed
class SecondLevel {
  name: string = ''
  age: number = 0
}