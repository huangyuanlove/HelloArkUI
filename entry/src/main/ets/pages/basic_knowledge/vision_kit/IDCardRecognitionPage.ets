import { CardRecognition, CardSide, CardType } from '@hms.ai.CardRecognition';
import { promptAction, router } from '@kit.ArkUI';
import { CallbackParam, ShootingMode } from '@kit.VisionKit';
import { emitter } from '@kit.BasicServicesKit';

@Entry
@Component
struct IDCardRecognitionPage {
  cardSide = CardSide.BACK

  aboutToAppear(): void {
    this.cardSide = router.getParams() as CardSide
  }

  build() {
    Column() {
      if(canIUse("SystemCapability.AI.Component.CardRecognition")){
        CardRecognition({
          supportType:CardType.CARD_ID,
          cardSide:this.cardSide,
          cardRecognitionConfig:{
            defaultShootingMode:ShootingMode.MANUAL,
            isPhotoSelectionSupported:true,
          },
          callback:async(params:CallbackParam)=>{
            if(params.code == 200 && params.cardInfo){
              console.error("识别成功")
              if(this.cardSide == CardSide.FRONT){
                emitter.emit("id_card_recognition",{data:params.cardInfo.front})
              }else{
                emitter.emit("id_card_recognition",{data:params.cardInfo.back})
              }
              router.back()

            }else{
              console.error("识别失败")
              promptAction.showToast({message:"识别失败"})
            }
          }
        })
      }
    }
    .height('100%')
    .width('100%')
  }
}