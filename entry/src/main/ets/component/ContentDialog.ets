@CustomDialog
export struct ContentDialog {
  private customController: CustomDialogController
  content:string ='';
  build() {
    Column() {
      Text(this.content)
        .fontSize(20).padding(10)

    }

  }
}