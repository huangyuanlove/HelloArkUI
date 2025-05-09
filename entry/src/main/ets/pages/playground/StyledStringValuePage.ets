import {ActionBar} from '../../comm/ActionBar';
import { DrawContext, LengthMetrics, LengthUnit, promptAction } from '@kit.ArkUI';
import { drawing } from '@kit.ArkGraphics2D';
import hilog from '@ohos.hilog';

@Entry
@ComponentV2
struct StyledStringValuePage {
  textController: TextController = new TextController()
  mutableStyledString: MutableStyledString | undefined
  protocolTextController: TextController = new TextController();
  customSpanTextController: TextController = new TextController();
  demoTextController: TextController = new TextController();

  aboutToAppear(): void {


    this.mutableStyledString =
      new MutableStyledString("豫章故郡，洪都新府。星分翼轸，地接衡庐。襟三江而带五湖，控蛮荆而引瓯越。物华天宝，龙光射牛斗之墟；人杰地灵，徐孺下陈蕃之榻。",
        [{
          start: 0,
          length: 6,
          styledKey: StyledStringKey.FONT,
          styledValue: new TextStyle({ fontColor: Color.Blue })
        }, {
          start: 7,
          length: 6,
          styledKey: StyledStringKey.DECORATION,
          styledValue: new DecorationStyle({
            color: Color.Red,
            type: TextDecorationType.LineThrough,
            style: TextDecorationStyle.WAVY
          })
        }, {
          start: 14,
          length: 6,
          styledKey: StyledStringKey.BASELINE_OFFSET,
          styledValue: new BaselineOffsetStyle(new LengthMetrics(6, LengthUnit.VP))
        }
          , {
            start: 21,
            length: 6,
            styledKey: StyledStringKey.LETTER_SPACING,
            styledValue: new LetterSpacingStyle(new LengthMetrics(6, LengthUnit.VP))
          }
          , {
            start: 28,
            length: 6,
            styledKey: StyledStringKey.TEXT_SHADOW,
            styledValue: new TextShadowStyle({
              radius: 5,
              type: ShadowType.COLOR,
              color: Color.Yellow,
              offsetX: 10,
              offsetY: -10
            })
          }
          , {
            start: 35,
            length: 6,
            styledKey: StyledStringKey.LINE_HEIGHT,
            styledValue: new LineHeightStyle(LengthMetrics.fp(20))
          }
          // , {
          //   start: 42,
          //   length: 6,
          //   styledKey: StyledStringKey.BACKGROUND_COLOR,
          //   styledValue: new BackgroundColorStyle({
          //     color: Color.Pink,
          //     radius: 6
          //   })
          // }
          // , {
          //   start: 49,
          //   length: 6,
          //   styledKey: StyledStringKey.URL,
          //   styledValue: new UrlStyle("https://www.example.com")
          // }
          , {
            start: 56,
            length: 6,
            styledKey: StyledStringKey.PARAGRAPH_STYLE,
            styledValue: new ParagraphStyle({
              textAlign: TextAlign.End,
              maxLines: 1,
              wordBreak: WordBreak.BREAK_ALL,
              overflow: TextOverflow.Ellipsis
            })
          }
        ]);
  }

  onDidBuild(): void {

  }

  onPageShow(): void {



  }

  @Local dynamicWidth:number = 60

  build() {
    Column() {
      ActionBar({ title: "属性字符串" })

      Text(undefined, { controller: this.textController }).onAppear(() => {
        this.textController.setStyledString(this.mutableStyledString)
      })
      // Row(){
      //   Text("动态修改宽度").width(this.dynamicWidth).onClick((_)=>{
      //     this.dynamicWidth = Math.random()*200
      //   }).textAlign(TextAlign.Center).backgroundColor(Color.Pink)
      //
      //   Text(undefined, { controller: this.customSpanTextController }).margin({ left: 20 }).fontSize(16).onAppear(()=>{
      //
      //     // let customSpan: MyCustomSpan = new MyCustomSpan("自定义属性字符串", this.getUIContext());
      //     // let customSpan: MyCustomSpan = new MyCustomSpan("ABCDEFGHIJKLMNOPQRSTUVWXYZ,abcdefghijklmnopqrstuvwxyz", this.getUIContext());
      //
      //   }).backgroundColor(Color.Blue)
      //     .onAreaChange((oldValue:Area,newValue:Area)=>{
      //       hilog.error(0x01,"StyledStringValuePage",`自定义属性字符串 onAreaChange ${newValue.width},${newValue.height}`)
      //       let customSpan: MyCustomSpan = new MyCustomSpan("豫章故郡，洪都新府。星分翼轸，地接衡庐。襟三江而带五湖，控蛮荆而引瓯越。物华天宝，龙光射牛斗之墟；人杰地灵，徐孺下陈蕃之榻。", this.getUIContext(),newValue.width as number);
      //       let style: MutableStyledString = new MutableStyledString(customSpan);
      //       this.customSpanTextController.setStyledString(style)
      //     }).layoutWeight(1)
      // }
        Text(undefined, { controller: this.customSpanTextController }).margin({ left: 20 }).fontSize(16).onAppear(()=>{

          let customSpan: MyCustomSpan = new MyCustomSpan("自定义属性字符串", this.getUIContext());
                let style: MutableStyledString = new MutableStyledString(customSpan);
                this.customSpanTextController.setStyledString(style)
        })


      Text() {
        Span("我已仔细阅读并同意").fontColor("#333333").fontSize(16)
        Span("《用户协议》").fontColor("#39d175").fontSize(16).onClick((_) => {
          promptAction.showToast({ message: "打开用户协议页面" })
        })
        Span("和").fontColor("#333333").fontSize(16)
        Span("《隐私协议》").fontColor("#39d175").fontSize(16).onClick((_) => {
          promptAction.showToast({ message: "打开隐私协议页面" })
        })
      }.margin({ top: 10 })

      Text(undefined, { controller: this.protocolTextController }).onAppear(() => {

        let protocolStyledString: MutableStyledString =
          new MutableStyledString("我已仔细阅读并同意《用户协议》和《隐私协议》", [
            {
              start: 9,
              length: 6,
              styledKey: StyledStringKey.FONT,
              styledValue: new TextStyle({
                fontColor: "#39d175",
                fontSize: LengthMetrics.fp(16),
              })
            },
            {
              start: 9,
              length: 6,
              styledKey: StyledStringKey.GESTURE,
              styledValue: new GestureStyle({
                onClick: (event: ClickEvent) => {
                  promptAction.showToast({ message: "打开用户协议页面" })
                }, onLongPress: (event: GestureEvent) => {
                }
              })
            },

            {
              start: 16,
              length: 6,
              styledKey: StyledStringKey.FONT,
              styledValue: new TextStyle({
                fontColor: "#39d175",
                fontSize: LengthMetrics.fp(16),
              })
            },
            {
              start: 16,
              length: 6,
              styledKey: StyledStringKey.GESTURE,
              styledValue: new GestureStyle({
                onClick: (event: ClickEvent) => {
                  promptAction.showToast({ message: "打开隐私协议页面" })
                }, onLongPress: (event: GestureEvent) => {
                }
              })
            }
          ])
        this.protocolTextController.setStyledString(protocolStyledString)
      })

      Text(undefined, { controller: this.demoTextController }).onAppear(() => {

        let protocolStyledString: MutableStyledString =
          new MutableStyledString("魔力赏ALOID 虚拟歌手会需要电子染发剂吗魔力赏力赏SSR景品魔", [
            {
              start: 0,
              length: 3,
              styledKey: StyledStringKey.FONT,
              styledValue: new TextStyle({
                fontColor: Color.Pink,
                fontSize: LengthMetrics.fp(16),
              })
            },

            {
              start: 0,
              length: 3,
              styledKey: StyledStringKey.BACKGROUND_COLOR,
                styledValue: new BackgroundColorStyle({
                  color: "#ff6134",
                  radius: 2
                })
            }
          ])
        this.demoTextController.setStyledString(protocolStyledString)
      }).margin(10)





    }
    .height('100%')
    .width('100%')
  }
}

class MyCustomSpan extends CustomSpan {
  constructor(text: string, uiContext: UIContext,maxWidth?:number) {
    super();
    this.text = text;
    this.uiContext = uiContext
    this.maxWidth = maxWidth??0
  }

  text: string
  uiContext: UIContext
  maxWidth: number = 0
  fontSizeFp: number = 0


  onMeasure(measureInfo: CustomSpanMeasureInfo): CustomSpanMetrics {
    // measureInfo.fontSize单位为fp
    this.fontSizeFp = measureInfo.fontSize


    // 传入的fontSize单位为fp，返回文本所占布局宽度和高度单位均为px。
    let size =
      this.uiContext.getMeasureUtils().measureTextSize({ textContent: this.text, fontSize: measureInfo.fontSize })

    let measureTextWidth:number = size.width as number

    if(this.maxWidth>0 && measureTextWidth > this.maxWidth){
      size.width = this.maxWidth
      size.height = Math.ceil(measureTextWidth / this.maxWidth) * (size.height as number)

    }

    //单位为vp

    return { width: px2vp(size.width as number), height: px2vp(size.height as number) };
  }

  onDraw(context: DrawContext, drawInfo: CustomSpanDrawInfo): void {


    console.error(`onDraw drawInfo x:${drawInfo.x}  lineTop:${drawInfo.lineTop}  lineBottom:${drawInfo.lineBottom}  baseline:${drawInfo.baseline}`)
    console.error(`onDraw context ${vp2px(context.size.width)}   ${vp2px(context.size.height)}`)

    let canvas = context.canvas;
    const font = new drawing.Font();
    font.setSize(vp2px(this.fontSizeFp));
    const brush = new drawing.Brush();
    brush.setColor({
      alpha: 255,
      red: 0,
      green: 74,
      blue: 175
    });

    canvas.attachBrush(brush)
    const textBlob = drawing.TextBlob.makeFromString(this.text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);

    canvas.drawTextBlob(textBlob, drawInfo.x, drawInfo.baseline);

    canvas.detachBrush()
  }
}