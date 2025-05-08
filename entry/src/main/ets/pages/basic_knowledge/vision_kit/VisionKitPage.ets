import { ActionBar } from '../../../comm/ActionBar';
import { emitter } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';
import { CardSide } from '@kit.VisionKit';


@Entry
@Component
struct VisionKitPage {

  @State idCardInfo:string= ""
  @State originalImageUri:string = ''
  @State idCardImageUri:string = ''

  build() {
      Column() {
        ActionBar({title:"场景视觉化"})
        Scroll(){
          Column(){
             Button("身份证正面").onClick((_)=>{
              emitter.once("id_card_recognition",(data:emitter.EventData)=>{
                let param = data.data as Record<string,string>
                let info  = `name:${param['name']}  sex:${param['sex']}  nationality:${param['nationality']}  birth:${param['birth']}  address:${param['address']}  idNumber:${param['idNumber']}`
                this.idCardInfo = info

                this.idCardImageUri = param['cardImageUri']
                this.originalImageUri = param['originalImageUri']

              })
              router.pushUrl({url:"pages/basic_knowledge/vision_kit/IDCardRecognitionPage",params:{"side":CardSide.FRONT}})
            })
            if(this.idCardInfo){
              Text(`身份证信息：${this.idCardInfo}`)
            }
            if(this.idCardImageUri){
              Image(this.idCardImageUri).width('100%').fitOriginalSize(true).objectFit(ImageFit.Auto).padding(10)
            }
            if(this.originalImageUri){
              Image(this.originalImageUri).width('100%').fitOriginalSize(true).objectFit(ImageFit.Auto).padding(10)
            }


            Button("文档扫描")
            Button("AI识图")
          }.layoutWeight(1).justifyContent(FlexAlign.Start)

        }

      }

    .height('100%')
    .width('100%')
  }
}