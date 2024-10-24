import { FirstLevel, Root, SecondLevel } from './DataModel';
import { promptAction } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';

@Entry
@Component
struct ObservedLinkPage {
  @State message: string = 'Hello World';
  @State root: Root = new Root()

  aboutToAppear(): void {
    this.initData()
    emitter.on("change",(data)=>{
      let newProgress = Math.floor(Math.random() * 100)
      promptAction.showToast({ message: `新进度 ${newProgress}` })
      this.root.firstLevel[data.data?.['first']].contents[data.data?.['second']].value = newProgress
    })
  }

  initData() {
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

  build() {
    Column() {
      List() {

        ForEach(this.root.firstLevel,(firstLevel:FirstLevel,index:number)=>{
              ListItem(){
                Column(){
                  Text(`第一层 第 ${index} 个`)
                  ForEach(firstLevel.contents, (content: SecondLevel,secondIndex:number) => {
                    ListItem() {
                      Column(){
                        Text(`第二层 第 ${secondIndex} 个`)
                        ProgressView({ content: content })
                      }.margin(10).backgroundColor(Color.Gray)

                    }

                  })
                }.margin(10).backgroundColor(Color.Grey)
              }
        })


      }

      Flex({wrap:FlexWrap.Wrap}) {
        Button('修改第一层 第一个进度').onClick((_) => {
          let eventData: emitter.EventData = {
            data: {
              "first": 0,
              "second": 0,
            }
          };
          emitter.emit('change',eventData)

          // let newProgress = Math.floor(Math.random() * 100)
          // promptAction.showToast({ message: `新进度 ${newProgress}` })
          // this.root.firstLevel[0].contents[0].value = newProgress
        })
        Button('修改第一层 第二个进度').onClick((_) => {
          // let newProgress = Math.floor(Math.random() * 100)
          // promptAction.showToast({ message: `新进度 ${newProgress}` })
          // this.root.firstLevel[0].contents[1].value = newProgress


          let eventData: emitter.EventData = {
            data: {
              "first": 0,
              "second": 1,
            }
          };
          emitter.emit('change',eventData)

        })
        Button('修改第二层第一个进度').onClick((_) => {
          // let newProgress = Math.floor(Math.random() * 100)
          // promptAction.showToast({ message: `新进度 ${newProgress}` })
          // this.root.firstLevel[1].contents[0].value = newProgress


          let eventData: emitter.EventData = {
            data: {
              "first": 1,
              "second": 0,
            }
          };
          emitter.emit('change',eventData)

        })
        Button('修改第二层第二个进度').onClick((_) => {
          // let newProgress = Math.floor(Math.random() * 100)
          // promptAction.showToast({ message: `新进度 ${newProgress}` })
          // this.root.firstLevel[1].contents[1].value = newProgress


          let eventData: emitter.EventData = {
            data: {
              "first": 1,
              "second": 1,
            }
          };
          emitter.emit('change',eventData)

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