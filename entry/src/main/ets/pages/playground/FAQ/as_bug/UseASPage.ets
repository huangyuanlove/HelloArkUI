import { hilog } from '@kit.PerformanceAnalysisKit';
import { systemDateTime } from '@kit.BasicServicesKit';


@Entry
@Component
struct UseASPage {
  @State firstLevelWithClass?: FirstLevel = undefined


  @State logTrack: LogTrack = new LogTrack('Hello');
  @State logNotTrack: LogNotTrack = new LogNotTrack('HarmonyOS');

  isRender(index: number) {
    console.log(`Text ${index} is rendered`);
    return 20;
  }

  aboutToAppear(): void {
    this.firstLevelWithClass = new FirstLevel()
    this.firstLevelWithClass.time = systemDateTime.getTime()
    let secondLevel = new SecondLevel()
    secondLevel.name = "HarmonyOS"
    secondLevel.age = 18
    this.firstLevelWithClass.secondLevel = secondLevel;
  }

  build() {
    Column() {

      Row(){
        Column(){
          Text(this.logTrack.str1) // Text1
            .fontSize(this.isRender(1))
            .fontWeight(FontWeight.Bold)
          Text(this.logTrack.str2) // Text2
            .fontSize(this.isRender(2))
            .fontWeight(FontWeight.Bold)
          Button('修改logTrack.str1')
            .onClick(() => {
              this.logTrack.str1 = 'Bye';
            })
        }.layoutWeight(1)
        Column() {
          Text(this.logNotTrack.str1) // Text3
            .fontSize(this.isRender(3))
            .fontWeight(FontWeight.Bold)
          Text(this.logNotTrack.str2) // Text4
            .fontSize(this.isRender(4))
            .fontWeight(FontWeight.Bold)
          Button('修改logNotTrack.str1')
            .onClick(() => {
              this.logNotTrack.str1 = '再见';
            })
        }.layoutWeight(1)
      }.height("100%")
    .margin({bottom:20})





      Column() {
        Text("直接观测")
        Text(`time:${this.firstLevelWithClass?.time}`)
          .fontColor(Color.White)
        Text(`name:${this.firstLevelWithClass?.secondLevel?.name}`)
          .fontColor(Color.White)
        Text(`age:${this.firstLevelWithClass?.secondLevel?.age}`)
          .fontColor(Color.White)
      }.alignItems(HorizontalAlign.Start).backgroundColor("#a557c1").padding(10)

      Divider().vertical(false).margin(10)

      if (this.firstLevelWithClass) {
        Column() {
          Text("自定义组件观测")
          ShowFistLevel({ firstLevel: this.firstLevelWithClass })
        }.backgroundColor("#368800").padding(10)
      }


      Row() {
        Button('修改time属性').margin(10).onClick((_) => {
          if (this.firstLevelWithClass) {
            this.firstLevelWithClass.time = systemDateTime.getTime()
          }
        })

        Button('修改 name、age 属性').margin(10).onClick((_) => {
          if (this.firstLevelWithClass) {
            this.firstLevelWithClass.secondLevel.name = '新名字 ' + Math.floor(Math.random() * 10)
            this.firstLevelWithClass.secondLevel.age = Math.floor(Math.random() * 100)
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

class LogTrack {
  @Track str1: string;
  @Track str2: string;

  constructor(str1: string) {
    this.str1 = str1;
    this.str2 = 'LogTrack';
  }
}

class LogNotTrack {
  str1: string;
  str2: string;

  constructor(str1: string) {
    this.str1 = str1;
    this.str2 = 'LogNotTrack';
  }
}