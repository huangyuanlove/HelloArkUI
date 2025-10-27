import { FirstLevel, Root, SecondLevel } from './DataModel';
import { promptAction } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { ActionBar } from '../../../comm/ActionBar';

@Entry
@Component
struct ObservedLinkPage {
  @State message: string = 'Hello World';
  @State root: Root = new Root()

  aboutToAppear(): void {
    this.initData()
    emitter.on("change", (data) => {
      let newProgress = Math.floor(Math.random() * 100)
      promptAction.showToast({ message: `新进度 ${newProgress}` })
      this.root.firstLevel[data.data?.['first']].contents[data.data?.['second']].value = newProgress
    })
  }

  async initData() {


    let p1 = new Promise<string>((res, rej) => {
      setTimeout(() => {
        res('123')
      }, 1000)
    })

    await p1
    hilog.error(0x01, 'a', 'initData')
    this.root = new Root()
    let firstLevel: FirstLevel = new FirstLevel()
    this.root.firstLevel.push(firstLevel)

    let secondLevel1 = new SecondLevel()
    secondLevel1.max = 100
    secondLevel1.value = 24
    firstLevel.contents.push(secondLevel1)

    let secondLevel2 = new SecondLevel()
    secondLevel2.max = 100
    secondLevel2.value = 24
    firstLevel.contents.push(secondLevel2)


    let firstLevel2: FirstLevel = new FirstLevel()
    this.root.firstLevel.push(firstLevel2)

    let secondLevel21 = new SecondLevel()
    secondLevel21.max = 100
    secondLevel21.value = 24
    firstLevel2.contents.push(secondLevel21)

    let secondLevel22 = new SecondLevel()
    secondLevel22.max = 100
    secondLevel22.value = 24
    firstLevel2.contents.push(secondLevel22)
  }

  async initWithAS() {
    let p1 = new Promise<string>((res, rej) => {
      setTimeout(() => {
        res('123')
      }, 1000)
    })

    await p1
    hilog.error(0x01, 'a', 'initWithAS')
    this.root = new Root()
    let firstLevel: FirstLevel = new FirstLevel()
    this.root.firstLevel.push(firstLevel)

    let secondLevel1 = {
      max: 100,
      value: 24
    } as SecondLevel
    firstLevel.contents.push(secondLevel1)

    let secondLevel2 = {
      max: 100,
      value: 24
    } as SecondLevel

    firstLevel.contents.push(secondLevel2)


    let firstLevel2: FirstLevel = new FirstLevel()
    this.root.firstLevel.push(firstLevel2)

    let secondLevel21 = {
      max: 100,
      value: 24
    } as SecondLevel
    firstLevel2.contents.push(secondLevel21)

    let secondLevel22 = {
      max: 100,
      value: 24
    } as SecondLevel
    firstLevel2.contents.push(secondLevel22)
  }

  @Builder
  buildFirstLevel() {
    ForEach(this.root.firstLevel, (firstLevel: FirstLevel, index: number) => {
      ListItem() {
        Column() {

          this.buildSecondLevel(firstLevel.contents)


        }.margin(10).backgroundColor(Color.Grey)
      }
    })
  }

  @Builder
  buildSecondLevel(contents: SecondLevel[]) {
    ForEach(contents, (content: SecondLevel, secondIndex: number) => {

      this.buildMessage(secondIndex, content)
    })
  }

  @Builder
  buildMessage(secondIndex: number, content: SecondLevel) {
    ListItem() {
      Column() {
        ProgressView({ content: content })
      }.margin(10).backgroundColor(Color.Gray)

    }
  }

  build() {
    Column() {
      ActionBar({ title: "Observed" })
      Row() {
        Button('使用 new 初始化').onClick((_) => {
          this.initData()
        })
        Button('使用 as 初始化').onClick((_) => {
          this.initWithAS()
        })
      }

      List() {
        this.buildFirstLevel()

      }

      Flex({ wrap: FlexWrap.Wrap }) {
        Button('第一个进度').onClick((_) => {
          let eventData: emitter.EventData = {
            data: {
              "first": 0,
              "second": 0,
            }
          };
          emitter.emit('change', eventData)

          // let newProgress = Math.floor(Math.random() * 100)
          // promptAction.showToast({ message: `新进度 ${newProgress}` })
          // this.root.firstLevel[0].contents[0].value = newProgress
        })
        Button('第二个进度').onClick((_) => {
          // let newProgress = Math.floor(Math.random() * 100)
          // promptAction.showToast({ message: `新进度 ${newProgress}` })
          // this.root.firstLevel[0].contents[1].value = newProgress


          let eventData: emitter.EventData = {
            data: {
              "first": 0,
              "second": 1,
            }
          };
          emitter.emit('change', eventData)

        })
        Button('第三个进度').onClick((_) => {
          // let newProgress = Math.floor(Math.random() * 100)
          // promptAction.showToast({ message: `新进度 ${newProgress}` })
          // this.root.firstLevel[1].contents[0].value = newProgress


          let eventData: emitter.EventData = {
            data: {
              "first": 1,
              "second": 0,
            }
          };
          emitter.emit('change', eventData)

        })
        Button('修改第四个进度').onClick((_) => {
          // let newProgress = Math.floor(Math.random() * 100)
          // promptAction.showToast({ message: `新进度 ${newProgress}` })
          // this.root.firstLevel[1].contents[1].value = newProgress


          let eventData: emitter.EventData = {
            data: {
              "first": 1,
              "second": 1,
            }
          };
          emitter.emit('change', eventData)

        })

      }.margin({ top: 20 })
    }
    .height('100%')
    .width('100%')
  }
}

@Component
struct ProgressView {
  @ObjectLink content: SecondLevel

  build() {
    Progress({ value: this.content.value, type: ProgressType.Linear }).color(Color.Red).margin(10)
  }
}