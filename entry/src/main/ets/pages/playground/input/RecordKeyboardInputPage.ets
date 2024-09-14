import { inputMethod } from '@kit.IMEKit';

@Entry
@Component
struct  RecordKeyboardInputPage{

  @State inputStr:string =''


  private inputController: inputMethod.InputMethodController = inputMethod.getController();
  // 软键盘相关设置
  private textConfig: inputMethod.TextConfig = {
    inputAttribute: {
      textInputType: inputMethod.TextInputType.NUMBER,
      enterKeyType: inputMethod.EnterKeyType.DONE
    }
  };



  build() {
    Text(this.inputStr)
  }
}