import { inputMethod } from '@kit.IMEKit'
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { LengthMetrics } from '@kit.ArkUI';
import { ActionBar } from '../../../comm/ActionBar';

@Entry
@Component
struct RecordKeyboardInputPage {
  @State inputStr: string = ""
  private inputController: inputMethod.InputMethodController = inputMethod.getController();
  private verifyCodeIdx = [0, 1, 2, 3]
  // 软键盘相关设置
  private textConfig: inputMethod.TextConfig = {
    inputAttribute: {
      textInputType: inputMethod.TextInputType.NUMBER,
      enterKeyType: inputMethod.EnterKeyType.DONE
    }
  };

  //订阅键盘输入、删除事件
  bindKeyboardEvent() {
    this.inputController.on('insertText', (text) => {
      this.inputStr += text;
    })
    this.inputController.on('deleteLeft', (length) => {
      this.inputStr = this.inputStr.substring(0, this.inputStr.length - length);
    })
  }

  unbindKeyboardEvent() {
    this.inputController.off('insertText')
    this.inputController.off('deleteLeft')
    this.inputController.detach()
  }

  build() {
    Column() {
      ActionBar({ title: "记录软键盘" })


      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.End,
        wrap: FlexWrap.NoWrap,
        space: { main: new LengthMetrics(10) }
      }) {
        ForEach(this.verifyCodeIdx, (item: number) => {
          Text(this.inputStr[item])
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
              width: { bottom: this.inputStr.length == item ? 2 : 1 },
              color: this.inputStr.length == item ? '#018576' : '#bdbdbd'
            });
        });
      }
      .width('100%').onAppear(async () => {
        await this.inputController.attach(true, this.textConfig).then(() => {
          this.bindKeyboardEvent()
        }).catch((error: BusinessError) => {
          hilog.error(0x01, "RecordKeyboardInputPage", "输入法绑定出错")
        })
      })
      .onDisAppear(() => {
        this.unbindKeyboardEvent()
      })
    }
  }
}