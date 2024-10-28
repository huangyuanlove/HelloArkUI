import { HtmlRender } from "../pages/playground/html_parse/HtmlRender"

@Builder
export function confirmOrCancelDialogBuilder(dialogData:DialogData){
  Column(){
    if(dialogData.title){
      Text(dialogData.title).fontColor("#1a1a1a").fontSize(18).margin({left:20,right:20,bottom:12})
    }
    if(dialogData.message){
      Text(dialogData.message).fontColor("#666666").fontSize(15).margin({left:15,right:15}).textAlign(TextAlign.Center)
    }
    if(dialogData.htmlMessage){
      HtmlRender({
        htmlContent: dialogData.htmlMessage
      }).margin({left:15,right:15})
    }

    Divider().vertical(false).color("#ededed").margin({top:18}).height(1)
    Row(){
      if (dialogData.cancelButton == undefined || dialogData.cancelButton.length > 0) {
        Text(dialogData.cancelButton?dialogData.cancelButton:"取消").layoutWeight(1).textAlign(TextAlign.Center).fontSize(16).fontColor("#999999").padding(15)
          .onClick((_)=>{
            if(dialogData.onCancel){
              dialogData.onCancel()
            }
          })

        Divider().height(44).color("#EDEDED").width(1)
      }

      Text(dialogData.confirmButton?dialogData.confirmButton:"确定").layoutWeight(1).textAlign(TextAlign.Center).fontSize(16).fontColor("#1b91e0").padding(15)
        .onClick((_)=>{
          if(dialogData.onConfirm){
            dialogData.onConfirm()
          }
        })
    }
  }.padding({top:20})
}

export class DialogData{
  title?:string
  message?:string
  htmlMessage?:string
  cancelButton?:string
  confirmButton?:string
  onConfirm?:()=>void
  onCancel?:()=>void

}