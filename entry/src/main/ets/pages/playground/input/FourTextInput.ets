import { hilog } from '@kit.PerformanceAnalysisKit'

@Component
struct FourTextInput {
  onFinishInput?: (value: string) => void
  @State inputValue: string[] = ["", "", "", ""]
  @State inputEnable: boolean[] = [true, false, false, false]
  inputIndex: number[] = [0, 1, 2, 3]

  // build() {
  //     Row(){
  //       ForEach(this.inputIndex,(index:number)=>{
  //         RelativeContainer(){
  //           TextInput({text:this.inputValue[index]}).layoutWeight(1).textInputStyle(this.inputEnable[index]).maxLength(1).maxLines(1).id(index.toString()).type(InputType.Number)
  //             .onDidDelete((_)=>{
  //               hilog.error(0x01,"InputVerificationCode",`第${index}个执行 onDidDelete`)
  //               if(this.inputValue[index].length == 0){
  //                 //不是第一个输入框 且 输入框内没有文字，则删除上一个输入框内容，并且使上一个输入框获取焦点
  //                 if(index !=0){
  //                   this.inputValue[index-1]=""
  //                   this.inputEnable[index] =false
  //                   this.inputEnable[index-1] =true
  //
  //                   this.getUIContext().getFocusController().requestFocus((index-1).toString())
  //                 }else{
  //                   //如果输入框内有文字，则只删除当前输入框内容
  //                   this.inputValue[index]=""
  //                 }
  //               }
  //             })
  //             .onChange((value: string, previewText?: PreviewText)=>{
  //               hilog.error(0x01,"InputVerificationCode",`第${index}个onChange:  value:${value}  previewText: value-> ${previewText?.value}    offset->${previewText?.offset}`   )
  //               this.inputValue[index]= value
  //               if(value.length == 1){
  //                 if(index != 3){
  //                   this.inputEnable[index+1] =true
  //                   this.getUIContext().getFocusController().requestFocus((index+1).toString())
  //                   this.inputEnable[index] = false
  //                   // this.inputEnable[index] =false
  //                 }else{
  //                   if(this.onFinishInput){
  //                     let result = ""
  //                     for(let i =0;i< this.inputValue.length;i++){
  //                       result += this.inputValue[i]
  //                     }
  //                     this.onFinishInput(result)
  //                   }
  //                 }
  //               }
  //             })
  //           if(!this.inputEnable[index]){
  //             Text().backgroundColor(Color.Transparent).alignRules({
  //               left: {anchor: index.toString(), align: HorizontalAlign.Start},
  //               top: {anchor: index.toString(), align: VerticalAlign.Top},
  //               bottom: {anchor: index.toString(), align: VerticalAlign.Bottom},
  //               right: {anchor: index.toString(), align: HorizontalAlign.End}
  //             })
  //           }
  //         }.layoutWeight(1).height(40).margin({right:index == this.inputIndex.length-1?0:10})
  //       })
  //     }.onAppear(()=>{
  //       this.getUIContext().getFocusController().requestFocus("0")
  //     })
  // }
  build() {
    Row() {
      ForEach(this.inputIndex, (index: number) => {
        TextInput({ text: this.inputValue[index] })
          .defaultFocus(this.inputEnable[index])
          .id(index.toString())
          .margin({ right: index == this.inputIndex.length - 1 ? 0 : 10 })
          .textInputStyle(this.inputEnable[index])
          .onChange((value: string, previewText?: PreviewText) => {
            this.inputValue[index] = value //记录输入的内容
            if (value.length == 1) { //确认是输入而不是删除
              if (index != 3) { //如果不是最后一个输入框发生的输入事件，就把焦点交给下一个输入框
                this.inputEnable[index+1] = true //记录下一个输入框获取焦点，改变背景色
                this.getUIContext().getFocusController().requestFocus((index + 1).toString()) //下一个输入框获取焦点
                this.inputEnable[index] = false //标记当前输入框失去焦点，改变背景色
              } else { //如果是最后一个输入框发生的输入事件，表示已经输入完了，继续后面流程
                //todo 输入完成，继续后面流程
                if (this.onFinishInput) {
                  let result = ""
                  for (let i = 0; i < this.inputValue.length; i++) {
                    result += this.inputValue[i]
                  }
                  this.onFinishInput(result)
                }
              }
            }
          })
      })
    }
  }
}

@Extend(TextInput)
function textInputStyle(enable: boolean) {
  .border({
    width: 1,
    color: enable ? "#1b91e0" : "#999999",
    radius: 4,
    style: BorderStyle.Solid,
  })
  .textAlign(TextAlign.Center)
  .layoutWeight(1)
  .maxLength(1)
  .maxLines(1)
  .type(InputType.Number)
  .layoutWeight(1)
  .height(40)
}

export { FourTextInput }