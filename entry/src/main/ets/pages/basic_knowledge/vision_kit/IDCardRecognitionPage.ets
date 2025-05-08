import { CardRecognition, CardSide, CardType } from '@hms.ai.CardRecognition';
import { CallbackParam, ShootingMode } from '@kit.VisionKit';
import { promptAction, router } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';
import { JSON } from '@kit.ArkTS';

@Entry
@Component
struct IDCardRecognitionPage {
  cardSide = CardSide.BACK

  aboutToAppear(): void {

    let routerParams = router.getParams() as Record<string,number>
    if(routerParams){
      console.error(`IDCardRecognitionPage routerParams   ${routerParams}` )
      this.cardSide = routerParams['side']
    }else{
      console.error(`IDCardRecognitionPage routerParams is null` )
    }



  }

  build() {
    Column() {
     if(this.cardSide == CardSide.FRONT){
       Text("CardSide.FRONT")
     }else if(this.cardSide == CardSide.BACK){
       Text("CardSide.BACK")
     }else if(this.cardSide == CardSide.DEFAULT){
       Text("CardSide.DEFAULT")
     }else{
       Text("CardSide.KNOWN")
     }

      if(canIUse("SystemCapability.AI.Component.CardRecognition")){
        CardRecognition({
          supportType:CardType.CARD_ID,
          cardSide:this.cardSide,
          cardRecognitionConfig:{
            isPhotoSelectionSupported:true,
            defaultShootingMode:ShootingMode.AUTO
          },
          callback:(params:CallbackParam)=>{
            if(params.code == 200 && params.cardInfo){
              console.error("识别成功")
              console.error(`${ JSON.stringify(params.cardInfo)}`)
              if(this.cardSide == CardSide.FRONT){
                emitter.emit("id_card_recognition",{data:params.cardInfo.front})
              }else{
                emitter.emit("id_card_recognition",{data:params.cardInfo.back})
              }
              router.back()

            }else{
              console.error("识别失败")
              promptAction.showToast({message:"识别失败"})
              router.back()
            }
          }
        })
      }
    }
    .height('100%')
    .width('100%')
  }
}