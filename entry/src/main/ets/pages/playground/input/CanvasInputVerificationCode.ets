import { inputMethod } from '@kit.IMEKit'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct CanvasInputVerificationCode {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private canvasWidth = 0
  private canvasHeight = 0
  private codeLength = 4;
  private hSpace = 10 //验证码下划线间距
  inputFocus: boolean[] = [true, false, false, false] //控制下划线高亮
  verifyCodeStr: string = ''; // 用户输入的验证码
  //软键盘
  private inputController: inputMethod.InputMethodController = inputMethod.getController();
  // 软键盘相关设置
  private textConfig: inputMethod.TextConfig = {
    inputAttribute: {
      textInputType: inputMethod.TextInputType.NUMBER,
      enterKeyType: inputMethod.EnterKeyType.DONE
    }
  };

  onInputChange() {
    const userInputLength: number = this.verifyCodeStr.length;

    // 设置 text 高亮
    for (let i: number = 0; i < this.codeLength; i++) {
      if (userInputLength == i) {
        this.inputFocus[i] = true;
      } else {
        this.inputFocus[i] = false;
      }
    }
    hilog.error(0x01, "CanvasInputVerificationCode", `onInputChange ${this.inputFocus}`)
    this.canvasRendering.reset()
    this.drawUnderLine()
    this.drawText()

    // 输入给定位数后做一些操作
    if (userInputLength === this.codeLength) {
      promptAction.showToast({ message: `输入的验证码是-->${this.verifyCodeStr}` })
    }
  }

  aboutToAppear() {
    hilog.error(0x01, "CanvasInputVerificationCode", "aboutToAppear")
    this.inputAttach().then(() => {
      this.inputListener();
      this.inputController.showTextInput().then(() => {
        hilog.error(0x01, "CanvasInputVerificationCode", "调起键盘成功")
      }).catch((error: BusinessError) => {
        hilog.error(0x01, "CanvasInputVerificationCode", `调起键盘失败--> ${JSON.stringify(error)}`)
      })
    });

  }

  /**
   * 输入监听
   */
  inputListener() {
    this.inputController.on('insertText', (text: string) => {

      if (this.verifyCodeStr.length >= this.codeLength || isNaN(Number(text)) || text === '') {
        return;
      }
      this.verifyCodeStr += text;

      this.onInputChange()
    });
    this.inputController.on('deleteLeft', () => {

      this.verifyCodeStr = this.verifyCodeStr.substring(0, this.verifyCodeStr.length - 1);

      this.onInputChange()
    });
  }

  /**
   * 页面关闭时解绑输入法
   */
  aboutToDisappear() {
    hilog.error(0x01, "CanvasInputVerificationCode", "aboutToDisappear")
    this.inputDetach();
  }

  /**
   * 输入法绑定
   */
  async inputAttach() {
    await this.inputController.attach(true, this.textConfig);
  }

  /**
   * 输入法解绑
   */
  inputDetach() {
    this.inputController.off('insertText');
    this.inputController.off('deleteLeft');
    this.inputController.detach().then(() => {
      hilog.error(0x01, "CanvasInputVerificationCode", "Succeeded in detaching inputMethod")
    }).catch((err: Error) => {
      hilog.error(0x01, "CanvasInputVerificationCode", `Failed to detach: ${JSON.stringify(err)}`)
    });
  }

  drawText() {
    //每个下划线长度
    let lineWidth = (this.canvasWidth - (this.codeLength - 1) * this.hSpace) / 4
    this.canvasRendering.fillStyle = "#666666"
    this.canvasRendering.font = "30vp"
    //在每个下划线的中心画数字
    //线的中心点
    let y = this.canvasHeight - 6
    for (let i = 0; i < this.codeLength && i < this.verifyCodeStr.length; i++) {
      let result: TextMetrics = this.canvasRendering.measureText(this.verifyCodeStr[i])
      this.canvasRendering.fillText(this.verifyCodeStr[i],
        lineWidth / 2 + (lineWidth + this.hSpace) * i - result.width / 2, y)
    }
  }

  drawUnderLine() {

    //每个下划线长度
    let lineWidth = (this.canvasWidth - (this.codeLength - 1) * this.hSpace) / 4

    //画出下划线
    let y = this.canvasHeight - 2
    hilog.error(0x01, "CanvasInputVerificationCode", `drawUnderLine ${this.inputFocus}`)
    for (let i = 0; i < this.codeLength; i++) {
      let path = new Path2D()

      if (this.inputFocus[i]) {

        this.canvasRendering.strokeStyle = "#39D167"
        this.canvasRendering.lineWidth = 3
      } else {
        this.canvasRendering.strokeStyle = "#999999"
        this.canvasRendering.lineWidth = 2
      }
      let startX = (lineWidth + this.hSpace) * i
      let endX = lineWidth + (lineWidth + this.hSpace) * i
      hilog.error(0x01,"CanvasInputVerificationCode",`drawUnderLine startX:${startX}  endX:${endX}  ${this.canvasRendering.strokeStyle}`)
      path.moveTo(startX, y)
      path.lineTo(endX, y)
      this.canvasRendering.stroke(path)
    }



  }

  build() {
    Column(){
      Text("canvas绘制").fontSize(20).fontColor(Color.Black)
      Canvas(this.canvasRendering)
        .width("calc(100% - 30vp)")
        .margin({ left: 15, right: 15 })
        .height("100")
        .onReady(() => {
          this.canvasWidth = this.canvasRendering.width
          this.canvasHeight = this.canvasRendering.height
          this.drawUnderLine()
          this.drawText()


        })
    }

  }
}