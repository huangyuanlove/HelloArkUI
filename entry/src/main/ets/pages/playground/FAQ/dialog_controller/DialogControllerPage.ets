import { CustomDialogExample, showDialog } from './DialogControllerUtils';
import { ComponentContent, promptAction } from '@kit.ArkUI';
import { confirmOrCancelDialogBuilder, DialogData } from '../../../../widget/ConfirmOrCancelDialogBuilder';
import { HtmlRender } from '../../html_parse/HtmlRender';
import { BusinessError } from '@kit.BasicServicesKit';
import { ActionBar } from '../../../../comm/ActionBar';

@Entry
@Component
struct DialogControllerPage {
  @State message: string = 'Hello World';
  dialogID: number = 0
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogExample({
      cancel: () => {
      },
      confirm: () => {
      },
    }),
  })

  build() {
    Column() {
      ActionBar({title:"Dialog"})
      Text('在 Click 事件中定义').margin(10)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .onClick((_) => {
          let dialogController: CustomDialogController | null = new CustomDialogController({
            builder: CustomDialogExample({
              cancel: () => {
              },
              confirm: () => {
              },
            }),
          })
          dialogController.open()
        })
      CustomDialogView()
      Text('在页面中定义').margin(10)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .onClick((_) => {
          this.dialogController?.open()
        })


      Text('推荐方案 一').margin(10)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .onClick((_) => {
          let dialogData: DialogData = new DialogData()
          dialogData.title = '推荐方案 一'
          dialogData.message = '使用  promptAction.openCustomDialog'


          let uiContext = this.getUIContext();
          let promptAction = uiContext.getPromptAction();

          let contentNode = new ComponentContent(uiContext, wrapBuilder(glaobleConfirmOrCancelDialogBuilder1), dialogData);
          dialogData.onCancel = () => {
            promptAction.closeCustomDialog(contentNode)

          }
          dialogData.onConfirm = () => {
            promptAction.closeCustomDialog(contentNode)
          }
          try {
            promptAction.openCustomDialog(contentNode);
          } catch (error) {
            let message = (error as BusinessError).message;
            let code = (error as BusinessError).code;
            console.error(`OpenCustomDialog args error code is ${code}, message is ${message}`);
          };
        })


      Text('推荐方案 二').margin(10)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .onClick((_) => {
          let dialogData: DialogData1 = new DialogData1()
          dialogData.title = '推荐方案二'
          dialogData.message = '使用  promptAction.openCustomDialog'
          dialogData.onCancel = () => {
            promptAction.closeCustomDialog(this.dialogID)
          }
          dialogData.onConfirm = () => {
            promptAction.closeCustomDialog(this.dialogID)
          }
          this.getUIContext().getPromptAction().openCustomDialog({
            builder: () => {
              this.confirmOrCancelDialogBuilder1(dialogData)
            },

          }).then((dialogID: number) => {
            this.dialogID = dialogID
          })
        })

    }
    .height('100%')
    .width('100%')
  }

  @Builder
  confirmOrCancelDialogBuilder1(dialogData: DialogData1) {
    Column() {
      if (dialogData.title) {
        Text(dialogData.title).fontColor("#1a1a1a").fontSize(18).margin({ left: 20, right: 20, bottom: 12 })
      }
      if (dialogData.message) {
        Text(dialogData.message)
          .fontColor("#666666")
          .fontSize(15)
          .margin({ left: 15, right: 15 })
          .textAlign(TextAlign.Center)
      }
      if (dialogData.htmlMessage) {
        HtmlRender({
          htmlContent: dialogData.htmlMessage
        }).margin({ left: 15, right: 15 })
      }

      Divider().vertical(false).color("#ededed").margin({ top: 18 }).height(1)
      Row() {
        if (dialogData.cancelButton == undefined || dialogData.cancelButton.length > 0) {
          Text(dialogData.cancelButton ? dialogData.cancelButton : "取消")
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .fontSize(16)
            .fontColor("#999999")
            .padding(15)
            .onClick((_) => {
              if (dialogData.onCancel) {
                dialogData.onCancel()
              }
            })

          Divider().height(44).color("#EDEDED").width(1)
        }

        Text(dialogData.confirmButton ? dialogData.confirmButton : "确定")
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontSize(16)
          .fontColor("#1b91e0")
          .padding(15)
          .onClick((_) => {
            if (dialogData.onConfirm) {
              dialogData.onConfirm()
            }
          })
      }
    }.padding({ top: 20 })
  }
}



@Builder
function  glaobleConfirmOrCancelDialogBuilder1(dialogData: DialogData1) {
  Column() {
    if (dialogData.title) {
      Text(dialogData.title).fontColor("#1a1a1a").fontSize(18).margin({ left: 20, right: 20, bottom: 12 })
    }
    if (dialogData.message) {
      Text(dialogData.message)
        .fontColor("#666666")
        .fontSize(15)
        .margin({ left: 15, right: 15 })
        .textAlign(TextAlign.Center)
    }
    if (dialogData.htmlMessage) {
      HtmlRender({
        htmlContent: dialogData.htmlMessage
      }).margin({ left: 15, right: 15 })
    }

    Divider().vertical(false).color("#ededed").margin({ top: 18 }).height(1)
    Row() {
      if (dialogData.cancelButton == undefined || dialogData.cancelButton.length > 0) {
        Text(dialogData.cancelButton ? dialogData.cancelButton : "取消")
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontSize(16)
          .fontColor("#999999")
          .padding(15)
          .onClick((_) => {
            if (dialogData.onCancel) {
              dialogData.onCancel()
            }
          })

        Divider().height(44).color("#EDEDED").width(1)
      }

      Text(dialogData.confirmButton ? dialogData.confirmButton : "确定")
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .fontSize(16)
        .fontColor("#1b91e0")
        .padding(15)
        .onClick((_) => {
          if (dialogData.onConfirm) {
            dialogData.onConfirm()
          }
        })
    }
  }.padding({ top: 20 }).backgroundColor(Color.White).borderRadius(6)
}

export class DialogData1 {
  title?: string
  message?: string
  htmlMessage?: string
  cancelButton?: string
  confirmButton?: string
  onConfirm?: () => void
  onCancel?: () => void
}

@Component
struct CustomDialogView{
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogExample({
      cancel: () => {
      },
      confirm: () => {
      },
    }),
  })
  build() {
    Text('在自定义组件中定义').margin(10)
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .onClick((_) => {
        this.dialogController?.open()
      })
  }
}