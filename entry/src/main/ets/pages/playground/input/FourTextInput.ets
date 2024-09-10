import { hilog } from '@kit.PerformanceAnalysisKit'

@Component
struct FourTextInput{

  onFinishInput?: (value:string)=>void

  @State inputValue:string[]=["","","",""]

  build() {
    Row(){
      ForEach(this.inputValue,(item:string)=>{

      })
      TextInput().layoutWeight(1).textInputStyle().maxLength(1).maxLines(1).onChange((value: string, previewText?: PreviewText)=>{
        hilog.error(0x01,"InputVerificationCode",`first  value:${value}  previewText: value-> ${previewText?.value}    offset->${previewText?.offset}`   )
        if(value.length == 1){
          this.getUIContext().getFocusController().requestFocus("second")
        }
      }).id("first").type(InputType.Number).onDidDelete((_)=>{
        hilog.error(0x01,"InputVerificationCode",`onDidDelete`   )
      })
      Blank().width(10)
      TextInput().layoutWeight(1).textInputStyle().maxLength(1).maxLines(1).id("second").type(InputType.Number)
        .onChange((value: string, previewText?: PreviewText)=>{
          hilog.error(0x01,"InputVerificationCode",`second  value:${value}  previewText: value-> ${previewText?.value}    offset->${previewText?.offset}`   )
          if(value.length == 1){
            this.getUIContext().getFocusController().requestFocus("third")
          }else{
            this.getUIContext().getFocusController().requestFocus("first")
          }
        })
      Blank().width(10)
      TextInput().layoutWeight(1).textInputStyle().maxLength(1).maxLines(1).id("third").type(InputType.Number)
        .onChange((value: string, previewText?: PreviewText)=>{
          hilog.error(0x01,"InputVerificationCode",`third  value:${value}  previewText: value-> ${previewText?.value}    offset->${previewText?.offset}`   )
          if(value.length == 1){
            this.getUIContext().getFocusController().requestFocus("fourth")
          }else{
            this.getUIContext().getFocusController().requestFocus("second")
          }
        })
      Blank().width(10)
      TextInput().layoutWeight(1).textInputStyle().maxLength(1).maxLines(1).id("fourth").type(InputType.Number)
        .onChange((value: string, previewText?: PreviewText)=>{
          hilog.error(0x01,"InputVerificationCode",`fourth  value:${value}  previewText: value-> ${previewText?.value}    offset->${previewText?.offset}`   )
          if(value.length == 1){
              if(this.onFinishInput){
                this.onFinishInput
              }
          }else{
            this.getUIContext().getFocusController().requestFocus("third")
          }
        })
    }
  }

}
@Extend(TextInput)
function textInputStyle(){
  .border({
    width: 1,
    color: "#1b91e0",
    radius: 4,
    style: BorderStyle.Solid,
  }).textAlign(TextAlign.Center)
}

export {FourTextInput}