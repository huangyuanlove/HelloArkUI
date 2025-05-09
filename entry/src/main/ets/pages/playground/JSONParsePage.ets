
import { JSON } from '@kit.ArkTS';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { plainToInstance } from 'class-transformer';
import { ActionBar } from '../../comm/ActionBar';

@Entry
@Component
struct JSONParsePage {
  @State message: string = 'Hello World';
  @State user: User | null = null



  initUser(){
    this.user = new User()
    this.user.name = 'JSONParsePage'
    this.user.age = Math.random()
    this.user.defaultSelect = true
  }


  build() {
    Column() {
      ActionBar({ title: 'JSON解析' })
      Row(){
        Button('初始化').onClick((_)=>{
          this.initUser()
        })
        Button('解析').onClick((_)=>{
          let str:string = JSON.stringify(this.user)
          const user1:User = plainToInstance(User, JSON.parse(str))
          hilog.error(0x01,'JSONParsePage',`${user1.name} `)
          hilog.error(0x01,'JSONParsePage',`${user1.getInfo()} `)

        })
      }
      Text(JSON.stringify(this.user))


    }
    .height('100%')
    .width('100%')
  }
}


class User {
  name: string = ''
  age: number = 0
  defaultSelect: boolean = false


  getInfo():string{
    return JSON.stringify(this)
  }
}