import { hilog } from '@kit.PerformanceAnalysisKit'

@Component
struct FourTextInput{

  onFinishInput?: (value:string)=>void

  @State inputValue:string[]=["","","",""]
  @State inputEnable:boolean[]=[true,false,false,false]
  inputIndex:number[]=[0,1,2,3]

  build() {
      Row(){
        ForEach(this.inputIndex,(index:number)=>{
          TextInput({text:this.inputValue[index]}).layoutWeight(1).textInputStyle().maxLength(1).maxLines(1).margin({right:index == this.inputIndex.length-1?0:10}).id(index.toString()).type(InputType.Number)
            // .onEditChange((isEditing:boolean)=>{
            //   //防止点击其他输入框
            //   if(!this.inputEnable[index] && isEditing){
            //     this.getUIContext().getFocusController().clearFocus()
            //   }
            //   for(let i =0; i < this.inputEnable.length;i++){
            //     if(this.inputEnable[i]){
            //       this.getUIContext().getFocusController().requestFocus(i.toString())
            //     }
            //   }
            // })
            .onDidDelete((_)=>{
              hilog.error(0x01,"InputVerificationCode",`第${index}个执行 onDidDelete`)
              if(this.inputValue[index].length == 0){
                //不是第一个输入框 且 输入框内没有文字，则删除上一个输入框内容，并且使上一个输入框获取焦点
                if(index !=0){
                  this.inputValue[index-1]=""
                  this.inputEnable[index] =false
                  this.inputEnable[index-1] =true

                  this.getUIContext().getFocusController().requestFocus((index-1).toString())
                }else{
                  //如果输入框内有文字，则只删除当前输入框内容
                  this.inputValue[index]=""
                }
              }
            })

            .onChange((value: string, previewText?: PreviewText)=>{
              hilog.error(0x01,"InputVerificationCode",`第${index}个onChange:  value:${value}  previewText: value-> ${previewText?.value}    offset->${previewText?.offset}`   )
              this.inputValue[index]= value
              if(value.length == 1){
                if(index != 3){
                  this.inputEnable[index+1] =true
                  this.getUIContext().getFocusController().requestFocus((index+1).toString())
                  // this.inputEnable[index] =false
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
      }.onAppear(()=>{
        this.getUIContext().getFocusController().requestFocus("0")
      })
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