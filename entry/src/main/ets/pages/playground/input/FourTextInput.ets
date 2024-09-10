import { hilog } from '@kit.PerformanceAnalysisKit'

@Component
struct FourTextInput{

  onFinishInput?: (value:string)=>void

  @State inputValue:string[]=["","","",""]
  inputIndex:number[]=[0,1,2,3]

  build() {
    Column(){
      Row(){
        ForEach(this.inputIndex,(item:number)=>{
          TextInput().layoutWeight(1).textInputStyle().maxLength(1).maxLines(1).margin({right:item == this.inputIndex.length-1?0:10}).id(item.toString()).type(InputType.Number)
            .onDidDelete((_)=>{
              hilog.error(0x01,"InputVerificationCode",`第${item}个执行 onDidDelete`)
              if(this.inputValue[item].length == 0){
                //不是第一个输入框 且 输入框内没有文字，则删除上一个输入框内容，并且使上一个输入框获取焦点
                if(item !=0){
                  this.inputValue[item-1]=""
                  this.getUIContext().getFocusController().requestFocus((item-1).toString())
                }else{
                  //如果输入框内有文字，则只删除当前输入框内容
                  this.inputValue[item]=""
                }
              }
            })
            .onChange((value: string, previewText?: PreviewText)=>{
              hilog.error(0x01,"InputVerificationCode",`第${item}个onChange:  value:${value}  previewText: value-> ${previewText?.value}    offset->${previewText?.offset}`   )
              this.inputValue[item]= value
              if(value.length == 1){
                if(item != 3){
                  this.getUIContext().getFocusController().requestFocus((item+1).toString())
                }else{
                  if(this.onFinishInput){
                    let result = ""
                    for(let i =0;i< this.inputValue.length;i++){
                      result += this.inputValue[i]
                    }
                    this.onFinishInput(result)
                  }
                }
              }
            })
        })
      }
      Row(){

        TextInput().layoutWeight(1).textInputStyle().maxLength(1).maxLines(1).onChange((value: string, previewText?: PreviewText)=>{
          hilog.error(0x01,"InputVerificationCode",`first  value:${value}  previewText: value-> ${previewText?.value}    offset->${previewText?.offset}`   )
          if(value.length == 1){
            this.getUIContext().getFocusController().requestFocus("second")
          }
        }).id("first").type(InputType.Number)
          .onDidDelete((_)=>{
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
      }.margin({top:20})
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