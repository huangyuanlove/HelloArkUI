import ActionBar from '../../../comm/ActionBar';
import { emitter } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct VisionKitPage {

  @State idCardInfo:string= ""
  @State idCardImageUri:string = ''

  build() {
    Scroll(){
      Column() {
        ActionBar({title:"场景视觉化"})
        Text("身份证正面").onClick((_)=>{
            emitter.once("id_card_recognition",(data:emitter.EventData)=>{
                let param = data.data as Record<string,string>
                let info  = `name:${param['name']}  sex:${param['sex']}  nationality:${param['nationality']}  birth:${param['birth']}  address:${param['address']}  idNumber:${param['idNumber']}`
                this.idCardInfo = info

            })
          router.pushUrl({url:"pages/basic_knowledge/vision_kit/IDCardRecognitionPage"})
        })
        if(this.idCardInfo){
          Text(`身份证信息：${this.idCardInfo}`)
        }
        if(this.idCardImageUri){
          Image(this.idCardImageUri).width('100%').fitOriginalSize(true).objectFit(ImageFit.Auto)
        }


        Text("文档扫描")
        Text("AI识图")
      }
    }

    .height('100%')
    .width('100%')
  }
}