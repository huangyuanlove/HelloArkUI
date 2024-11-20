import ActionBar from '../../../../comm/ActionBar';
import { router } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import {Type, plainToClass } from 'class-transformer';
import { systemDateTime } from '@kit.BasicServicesKit';


interface UserInterface {
  name: string;
}

class UserWithOutMethod {
  name: string = ''
}

class UserWithMethod {
  name: string = ''

  getInfo() {
    hilog.error(0x01, 'UserWithMethod', 'getInfo')
  }
}


@Entry
@Component
struct UseASPage {
  @State message: string = 'Hello World';
  @State user?: User = undefined

  @State firstLevel?:FirstLevel = undefined

  aboutToAppear(): void {
    this.user = router.getParams() as User
    hilog.error(0x01, 'UseASPage', '获取到的参数-->' + JSON.stringify(this.user))

    let userInterface: UserInterface = {
      name: "123"
    }
    let userWithOutMethod: UserWithOutMethod = {
      name: "123",
    }
    let userWithMethod = new UserWithMethod()
    userWithMethod.getInfo()


    let userStr = `{"name":"123"}`
    let userWithMethodJSON = JSON.parse(userStr) as UserWithMethod
    let tmp = plainToClass(UserWithMethod, userWithMethodJSON)
    tmp.getInfo()

  }

  initWithNew() {
    this.firstLevel = new FirstLevel()
    this.firstLevel.time = systemDateTime.getTime()
    let secondLevel:SecondLevel = new SecondLevel()
    secondLevel.name = 'new SecondLevel'
    secondLevel.age = Math.floor(Math.random() * 100)
    this.firstLevel.secondLevel = secondLevel
  }

  initWithAs() {

    let secondLevel:SecondLevel = {
      name: 'as SecondLevel',
      age: Math.floor(Math.random() * 100)
    }
    this.firstLevel = {
      time:systemDateTime.getTime(),
      secondLevel:secondLevel
    }
  }
  initWithPlainToText(){
    let str = `{"time":${systemDateTime.getTime()},"secondLevel":{"name":"PlainToText${Math.floor(Math.random() * 100)}","age":${Math.floor(Math.random() * 100)}}}`
    let tmp:FirstLevel = JSON.parse(str) as FirstLevel
    this.firstLevel = plainToClass(FirstLevel,tmp)
  }

  build() {
    Column() {
      ActionBar({ title: "UseAs" })
      Text(JSON.stringify(this.user))
      Button('调用对象方法').onClick((_) => {
        if (this.user) {
          hilog.error(0x01, 'UseASPage', '调用对象方法-->' + this.user.getInfo)
        }
      })
      Divider().color(Color.Red)
      Row() {
        Button('使用New').margin(10).onClick((_) => {
          this.initWithNew()
        })
        Button('使用PlainToClass').margin(10).onClick((_) => {
         this.initWithPlainToText()
        })

        Button('使用As').margin(10).onClick((_) => {
          this.initWithAs()
        })
      }

      Row() {
        Button('修改time属性').margin(10).onClick((_) => {
          if(this.firstLevel){
            this.firstLevel.time = systemDateTime.getTime()
          }
        })

        Button('修改 name、age 属性').margin(10).onClick((_) => {
          if(this.firstLevel) {
            this.firstLevel.secondLevel.name = '新名字 ' + Math.floor(Math.random() * 10)
            this.firstLevel.secondLevel.age = Math.floor(Math.random() * 100)
          }
        })
      }
      if(this.firstLevel){
        ShowFistLevel({firstLevel:this.firstLevel})
      }

    }
    .height('100%')
    .width('100%')
  }
}


@Component
struct  ShowFistLevel{
  @Watch('onFirstLevelChange') @ObjectLink firstLevel:FirstLevel
  onFirstLevelChange(){
    hilog.error(0x01, 'UseASPage', 'onFirstLevelChange')
  }
  build() {
    Column(){
      Text(this.firstLevel.time.toString())
      ShowSecondLevel({secondLevel:this.firstLevel.secondLevel})
    }.margin(15)
    .backgroundColor("#e7e7e7e7")
  }
}

@Component
struct  ShowSecondLevel{
  @Watch('onSecondLevelChange') @ObjectLink secondLevel:SecondLevel
  onSecondLevelChange(){
    hilog.error(0x01, 'UseASPage', 'onSecondLevelChange')
  }
  build() {
    Column(){
      Text(this.secondLevel.name)
      Text(this.secondLevel.age.toString())
    }.margin(15)
    .backgroundColor("#e7e7e7e7")
  }
}



@Observed
class FirstLevel {
  time: number = 0
  @Type(()=>SecondLevel)
  secondLevel: SecondLevel = new SecondLevel()
}

@Observed
class SecondLevel {
  name: string = ''
  age: number = 0
}


export class User {
  name: string = ''

  getInfo(): string {
    return "123"
  }
}