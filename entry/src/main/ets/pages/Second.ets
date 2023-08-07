import router from '@ohos.router'
import { HelloComponent } from '../component/HelloComponent'
@Entry
@Component
struct Second{
  @State message :string = 'hi second'
  build(){
    Row(){
      Column(){
        Text(this.message)
          .fontColor('#1b91e0')
          .fontWeight(FontWeight.Lighter)
        Button(){
          Text('back')
            .fontWeight(FontWeight.Medium)
            .fontColor('#666666')

        }
        .type(ButtonType.Normal)
        .backgroundColor('#0D9FFB')
        .margin({
          top:20
        })
        .width('40%')
        .height('5%')
        .onClick(()=>{
          router.back()
        })
        HelloComponent()

      }
      .width('100%')
    }.height('100%')

  }
}
// @Component
// struct HelloComponent{
//   @State message:string = "hello"
//   @State count:number = 0;
//   build(){
//
//     Row(){
//       Text( `${this.message}   ${this.count}`)
//         .onClick(()=>{
//           this.count ++;
//           this.message = `you had click for ${this.count} times`
//         })
//         .fontColor('#999999')
//         .fontSize(14)
//         .fontWeight(FontWeight.Regular)
//     }
//
//   }
// }
