import ActionBar from '../../../../comm/ActionBar';
import { router } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { plainToClass } from 'class-transformer';
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
    secondLevel.age = 1
    this.firstLevel.secondLevel = secondLevel
  }

  initWithAs() {

    let secondLevel:SecondLevel = {
      name: 'as SecondLevel',
      age: 2
    }
    this.firstLevel = {
      time:systemDateTime.getTime(),
      secondLevel:secondLevel
    }

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
        Button('initWithNew').margin(10).onClick((_) => {
          this.initWithNew()
        })
        Button('initWithPlainToClass').margin(10).onClick((_) => {
          let str = JSON.stringify(this.firstLevel)
          let tmp:FirstLevel = JSON.parse(str) as FirstLevel
          this.firstLevel = plainToClass(FirstLevel,tmp)
        })

        Button('initWithAs').margin(10).onClick((_) => {
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
          if(this.firstLevel){
          this.firstLevel.secondLevel.name = '新名字'
          this.firstLevel.secondLevel.age = 123
          }
        })
      }
      if(this.firstLevel){
        ShowFistLevel({firstLevel:this.firstLevel})
        // if(this.firstLevel.secondLevel){
        //   ShowSecondLevel({secondLevel:this.firstLevel.secondLevel})
        // }
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