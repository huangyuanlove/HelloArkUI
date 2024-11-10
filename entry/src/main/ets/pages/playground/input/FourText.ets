import { LengthMetrics } from '@kit.ArkUI';
import { inputMethod } from '@kit.IMEKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
struct FourText{
  private verifyCodeLength: number = 4; // 验证码固定长度
  private verifyCodeIdx: number[] = [0, 1, 2, 3]; // 验证码索引
  @State inputFocus: boolean[] = [true, false, false, false]; // 输入焦点
  @Watch('onInputChange') @State verifyCodeStr: string = ''; // 用户输入的验证码
  onFinishInput?: (value:string)=>void
  private inputController: inputMethod.InputMethodController = inputMethod.getController();
  // 软键盘相关设置
  private textConfig: inputMethod.TextConfig = {
    inputAttribute: {
      textInputType: inputMethod.TextInputType.NUMBER,
      enterKeyType: inputMethod.EnterKeyType.DONE
    }
  };


  aboutToAppear() {
    hilog.error(0x01,"FourText","aboutToAppear")

    // setTimeout(()=>{
    //   this.inputAttach().then(() => {
    //     this.inputListener();
    //     this.inputController.showTextInput().then(()=>{
    //       hilog.error(0x01,"FourText","调起键盘成功")
    //     }).catch((error:BusinessError)=>{
    //       hilog.error(0x01,"FourText",`调起键盘失败--> ${JSON.stringify(error)}`)
    //     })
    //   }).catch((error:BusinessError)=>{
    //     hilog.error(0x01,"FourText",`inputAttach失败--> ${JSON.stringify(error)}`)
    //   });
    // },500)
      this.inputAttach().then(() => {
        this.inputListener();
        this.inputController.showTextInput().then(()=>{
          hilog.error(0x01,"FourText","调起键盘成功")
        }).catch((error:BusinessError)=>{
          hilog.error(0x01,"FourText",`调起键盘失败--> ${JSON.stringify(error)}`)
        })
      }).catch((error:BusinessError)=>{
        hilog.error(0x01,"FourText",`inputAttach失败--> ${JSON.stringify(error)}`)
      });



  }

  aboutToDisappear() {
    hilog.error(0x01,"FourText","aboutToDisappear")
    this.inputDetach();
  }


  /**
   * 输入法解绑
   */
  inputDetach() {
    this.inputController.off('insertText');
    this.inputController.off('deleteLeft');
    this.inputController.detach().then(() => {
      hilog.error(0x01,"FourText","Succeeded in detaching inputMethod")
    }).catch((err: Error) => {
      hilog.error(0x01,"FourText",`Failed to detach: ${JSON.stringify(err)}`)
    });
  }


  onInputChange() {
    const userInputLength: number = this.verifyCodeStr.length;

    // 设置 text 高亮
    for (let i: number = 0; i < this.verifyCodeLength; i++) {
      if (userInputLength === i) {
        this.inputFocus[i] = true;
      } else {
        this.inputFocus[i] = false;
      }
    }

    // 输入 4 位后自动发送验证码请求
    if (userInputLength === this.verifyCodeLength) {
     if(this.onFinishInput){
       this.onFinishInput(this.verifyCodeStr)
     }
    }
  }
  /**
   * 输入监听
   */
  inputListener() {
    hilog.error(0x01,"FourText",`inputListener`)
    this.inputController.on('insertText', (text: string) => {
      hilog.error(0x01,"FourText",`insertText-->输入的字符 ${text}`)
      if (this.verifyCodeStr.length >= this.verifyCodeLength || isNaN(Number(text)) || text === '') {
        return;
      }
      this.verifyCodeStr += text;
      hilog.error(0x01,"FourText",`insertText-->处理后字符 ${this.verifyCodeStr}`)
    });
    this.inputController.on('deleteLeft', () => {
      hilog.error(0x01,"FourText",`deleteLeft-->删除前的字符 ${this.verifyCodeStr}`)
      this.verifyCodeStr = this.verifyCodeStr.substring(0, this.verifyCodeStr.length - 1);
      hilog.error(0x01,"FourText",`deleteLeft-->删除后的字符 ${this.verifyCodeStr}`)
    });
  }


  /**
   * 输入法设置
   */
  async inputAttach() {
    await this.inputController.attach(true, this.textConfig);
  }
  build() {
    Row(){
      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.End,
        wrap: FlexWrap.NoWrap,
        space: { main: new LengthMetrics(10) }
      }) {
        ForEach(this.verifyCodeIdx, (item: number) => {
          Text(this.verifyCodeStr[item])
            .flexGrow(1)
            .flexShrink(1)
            .flexBasis(1)
            .height(50)
            .fontSize(30)
            .fontColor('#323232')
            .enabled(false)
            .textAlign(TextAlign.Center)
            .border({
              style: BorderStyle.Solid,
              width: { bottom: this.inputFocus[item] ? 2 : 1 },
              color: this.inputFocus[item] ? '#018576' : '#bdbdbd'
            });
        });
      }
      .width('100%')
      .defaultFocus(true)
      .onClick(async () => {
        await this.inputAttach();
      });
    }
  }
}
export {FourText}