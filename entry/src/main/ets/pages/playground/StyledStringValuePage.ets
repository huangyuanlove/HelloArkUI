import ActionBar from '../../comm/ActionBar';
import { DrawContext, LengthMetrics, LengthMetricsUnit, LengthUnit, UIUtils } from '@kit.ArkUI';
import { text } from '@kit.ArkGraphics2D';
import { drawing } from '@kit.ArkGraphics2D'

@Entry
@ComponentV2
struct StyledStringValuePage {

  textController:TextController = new TextController()


  customSpanTextController: TextController = new TextController();

  onPageShow(): void {
    let fontStyleAttr: TextStyle = new TextStyle({ fontColor: Color.Blue });
    let mutableStyledString: MutableStyledString = new MutableStyledString("使用属性字符串实现", [{
      start: 0,
      length: 9,
      styledKey: StyledStringKey.FONT,
      styledValue: fontStyleAttr
    },{
      start:2,
      length:2,
      styledKey:StyledStringKey.DECORATION,
      styledValue:new DecorationStyle({color:Color.Red,type:TextDecorationType.LineThrough,style:TextDecorationStyle.WAVY})
    },{
      start:3,
      length:2,
      styledKey:StyledStringKey.BASELINE_OFFSET,
      styledValue:new BaselineOffsetStyle(new LengthMetrics(6,LengthUnit.VP) )
    }
      ,{
        start:5,
        length:2,
        styledKey:StyledStringKey.LETTER_SPACING,
        styledValue:new LetterSpacingStyle(new LengthMetrics(6,LengthUnit.VP) )
      }
      ,{
        start:5,
        length:2,
        styledKey:StyledStringKey.TEXT_SHADOW,
        styledValue:new TextShadowStyle({
          radius: 5,
          type: ShadowType.COLOR,
          color: Color.Yellow,
          offsetX: 10,
          offsetY: -10
        })
      }
    ]);
    this.textController.setStyledString(mutableStyledString)


  let  customSpan: MyCustomSpan = new MyCustomSpan("自定义属性字符串",this.getUIContext());
    let style: MutableStyledString = new MutableStyledString(customSpan);
    this.customSpanTextController.setStyledString(style)
  }

  build() {
    Column() {
      ActionBar({title:"属性字符串"})

  Text(undefined,{controller:this.textController})
  Text(undefined,{controller:this.customSpanTextController}).margin({left:20}).fontSize(16)



    }
    .height('100%')
    .width('100%')
  }
}

class MyCustomSpan extends CustomSpan{
  constructor(text: string,uiContext:UIContext) {
    super();
    this.text = text;
    this.uiContext = uiContext
  }
  text:string
  uiContext:UIContext


  onMeasure(measureInfo: CustomSpanMeasureInfo): CustomSpanMetrics {

    let size =  this.uiContext.getMeasureUtils().measureTextSize({textContent:this.text,fontSize:measureInfo.fontSize})

    console.error(`onMeasure ${size.width}  ${size.height}`)
    return { width: size.width as number, height: size.height as number };
  }

  onDraw(context: DrawContext, drawInfo: CustomSpanDrawInfo): void {

    let canvas = context.canvas;
    const font = new drawing.Font();
    font.setSize(vp2px(24));
    const brush = new drawing.Brush();
    brush.setColor({
      alpha: 255,
      red: 0,
      green: 74,
      blue: 175
    });
    canvas.attachBrush(brush)
    const textBlob = drawing.TextBlob.makeFromString(this.text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob,drawInfo.x, drawInfo.lineTop);
  }

}