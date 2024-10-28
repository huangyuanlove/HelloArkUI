import { HtmlRender } from "../pages/playground/html_parse/HtmlRender"

@CustomDialog
export struct ConfirmOrCancelDialog{
  controller: CustomDialogController
  title?:string
  message?:string
  htmlMessage?:string
  cancelButton?:string
  confirmButton?:string
  onConfirm?:()=>void
  onCancel?:()=>void
  build() {
    Column(){
      if(this.title){
        Text(this.title).fontColor("#1a1a1a").fontSize(18).margin({left:20,right:20,bottom:12})
      }
      if(this.message){
        Text(this.message).fontColor("#666666").fontSize(15).margin({left:15,right:15}).textAlign(TextAlign.Center)
      }
      if(this.htmlMessage){
        HtmlRender({
          htmlContent: this.htmlMessage
        }).margin({left:15,right:15})
      }

      Divider().vertical(false).color("#ededed").margin({top:18}).height(1)
      Row(){
        if (this.cancelButton == undefined || this.cancelButton.length > 0) {
          Text(this.cancelButton?this.cancelButton:"取消").layoutWeight(1).textAlign(TextAlign.Center).fontSize(16).fontColor("#999999").padding(15)
            .onClick((_)=>{
              this.controller.close()
              if(this.onCancel){
                this.onCancel()
              }
            })

          Divider().height(44).color("#EDEDED").width(1)
        }

        Text(this.confirmButton?this.confirmButton:"确定").layoutWeight(1).textAlign(TextAlign.Center).fontSize(16).fontColor("#1b91e0").padding(15)
          .onClick((_)=>{
            this.controller.close()
            if(this.onConfirm){
              this.onConfirm()
            }
          })
      }
    }.padding({top:20})
  }
}