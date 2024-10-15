import { xml, util } from '@kit.ArkTS'; // 需要使用util模块函数对文件编码
import { hilog } from '@kit.PerformanceAnalysisKit';
import { VNode } from './VNode';
import { promptAction } from '@kit.ArkUI';


@Entry
@Component
struct HtmlParsePage {
  rootTagCount = 0
  startTag = 0
  rootNode: VNode = new VNode()
  currentNode: VNode = new VNode()
  @State hasParse: boolean = false
  private htmlContent: string =
    `<span> 123\n <font  color="red"> <a href="https://www.baidu.com">点我跳转到百度</a></font> <br/><font> 这位姑娘有一双</font><span style="color:#ff6134;font-size:40px;background:yellow">蓝色的眼睛。</span></span>`

  startParse() {
    let textEncoder: util.TextEncoder = new util.TextEncoder();
    let arrBuffer: Uint8Array = textEncoder.encodeInto(this.htmlContent); // 对数据编码，防止包含中文字符乱码
    // 1.基于ArrayBuffer构造XmlPullParser对象
    let that: xml.XmlPullParser = new xml.XmlPullParser(arrBuffer.buffer as object as ArrayBuffer, 'UTF-8');
    let options: xml.ParseOptions = {
      supportDoctype: true,
      ignoreNameSpace: true,

      attributeValueCallbackFunction: this.attributeValueCallback.bind(this),
      tokenValueCallbackFunction: this.tokenValueCallback.bind(this)
    };
    that.parse(options);
    //如何判断是否为多个标签？检测 start_tag 和 end_tag
    hilog.error(0x01, "HtmlParsePage", `共 ${this.rootTagCount} 个根标签`)
  }

  attributeValueCallback(name: string, value: string): boolean {
    let str = name + ' ' + value + ' ';
    hilog.error(0x01, 'HtmlParsePage', `attribute  ${str}`)
    if (name === 'href') {
      this.currentNode.href = value
    } else if (name === 'size') {
      if (value.includes('px')) {
        let tmp = value.replace('px', '')
        this.currentNode.style.fontSize = px2fp(parseInt(tmp))
      } else {
        this.currentNode.style.fontSize = px2fp(parseInt(value))
      }
    } else if (name === 'style') {
      let attributes: string[] = value.split(';')
      attributes.forEach((attribute: string) => {
        let tmp: string [] = attribute.split(':')
        if (tmp[0] === 'color') {
          this.currentNode.style.fontColor = tmp[1]
        } else if (tmp[0] === 'background') {
          this.currentNode.style.backgroundColor = this.getColorWithStr(tmp[1])
        } else if (tmp[0] === 'font-size') {
          this.currentNode.style.fontSize = px2fp(parseInt(tmp[1].replace('px', '')))
        }
      })
    } else if (name === 'color') {
      this.currentNode.style.fontColor = this.getColorWithStr(value)
    }
    return true; // true:继续解析 false:停止解析
  }

  getColorWithStr(color: string): string | Color {
    if (color.includes('#')) {
      return color
    }
    switch (color.toLowerCase()) {
      case 'white':
        return Color.White
      case 'black':
        return Color.Black
      case 'blue':
        return Color.Blue
      case 'brown':
        return Color.Brown
      case 'gray':
        return Color.Gray
      case 'green':
        return Color.Green
      case 'grey':
        return Color.Grey
      case 'orange':
        return Color.Orange
      case 'pink':
        return Color.Pink
      case 'red':
        return Color.Red
      case 'yellow':
        return Color.Yellow
      case 'transparent':
        return Color.Transparent
      default:
        hilog.error(0x01, 'HtmlParsePage', '未支持的颜色--> ' + color)
        return Color.Transparent

    }
  }

  tokenValueCallback(name: xml.EventType, value: xml.ParseInfo): boolean {

    let nameStr = '未知'
    if (name == xml.EventType.START_DOCUMENT) {
      nameStr = 'START_DOCUMENT'
      return true
    } else if (name == xml.EventType.END_DOCUMENT) {
      nameStr = 'END_DOCUMENT'
      return true
    } else if (name == xml.EventType.START_TAG) {
      nameStr = 'START_TAG'
    } else if (name == xml.EventType.END_TAG) {
      nameStr = 'END_TAG'
    } else if (name == xml.EventType.TEXT) {
      nameStr = 'TEXT'
    } else if (name == xml.EventType.CDSECT) {
      nameStr = 'CDSECT'
      return true
    } else if (name == xml.EventType.COMMENT) {
      nameStr = 'COMMENT'
      return true
    } else if (name == xml.EventType.DOCDECL) {
      nameStr = 'DOCDECL'
      return true
    } else if (name == xml.EventType.INSTRUCTION) {
      nameStr = 'INSTRUCTION'
      return true
    } else if (name == xml.EventType.ENTITY_REFERENCE) {
      nameStr = 'ENTITY_REFERENCE'
      return true
    } else if (name == xml.EventType.WHITESPACE) {
      nameStr = 'WHITESPACE'
      return true
    }
    let valueStr =
      `getName:${value.getName()}    getText:${value.getText()}  `

    hilog.error(0x01, 'HtmlParsePage', `token  ${nameStr}  ${valueStr}`)
    if (name === xml.EventType.TEXT) {
      this.currentNode.text = value.getText()
    }

    if (name === xml.EventType.START_TAG) {
      if (value.getName() === 'br') {
        let lineBreakSpan = new VNode()
        lineBreakSpan.text = '\n'
        this.rootNode.child?.push(lineBreakSpan)
      }
      if (this.startTag == 0) {
        this.currentNode = new VNode()
        this.rootNode.child?.push(this.currentNode)
        this.rootTagCount++
      }
      this.startTag++
    }
    if (name === xml.EventType.END_TAG) {
      this.startTag--

    }

    return true; //true:继续解析 false:停止解析
  }

  getXmlEventTypeStr(type: number): string {
    switch (type) {
      case xml.EventType.START_DOCUMENT:
        return 'START_DOCUMENT'
      case xml.EventType.END_DOCUMENT:
        return 'END_DOCUMENT'
      case xml.EventType.START_TAG:
        return 'START_TAG'
      case xml.EventType.END_TAG:
        return 'END_TAG'
      case xml.EventType.TEXT:
        return 'TEXT'
      case xml.EventType.CDSECT:
        return 'CDSECT'
      case xml.EventType.COMMENT:
        return 'COMMENT'
      case xml.EventType.DOCDECL:
        return 'DOCDECL'
      case xml.EventType.INSTRUCTION:
        return 'INSTRUCTION'
      case xml.EventType.ENTITY_REFERENCE:
        return 'ENTITY_REFERENCE'
      case xml.EventType.WHITESPACE:
        return 'WHITESPACE'


    }

    return "未知"
  }

  build() {
    Column() {
      Text(this.htmlContent)
        .onClick((_) => {
          this.startParse()
          this.hasParse = true
        })
      Text() {
        Span("123").fontColor(Color.Red).fontSize(18)
        ContainerSpan() {
          Span("456").fontColor(Color.Blue).fontSize(24)
          Span("789").fontColor(Color.Green).fontSize(16)
        }.textBackgroundStyle({ color: "#7F007DFF", radius: 6, })

        Span("\n")
        ContainerSpan() {
          Span("1011").fontColor(Color.Blue).fontSize(24)
          Span("1213").fontColor(Color.Green).fontSize(16)
        }.textBackgroundStyle({ color: "#7F107DFF", radius: 6, })

        ContainerSpan()
      }.backgroundColor(Color.Orange)

      if (this.hasParse) {
        Divider().color(Color.Gray).height(20)
        this.buildWithVNode(this.rootNode)
      }


    }
  }

  @Builder
  buildWithVNode(vNode: VNode) {
    Text() {
      ForEach(vNode.child, (child: VNode) => {
        if (child.style.backgroundColor != Color.Transparent) {
          ContainerSpan() {
            Span(child.text).configSpanStyle(child)
          }.textBackgroundStyle({ color: child.style.backgroundColor })
        } else {
          Span(child.text).configSpanStyle(child)
        }
      })
    }.backgroundColor('#e1e1e1')
  }
}

@Extend(Span)
function configSpanStyle(vNode: VNode) {
  .backgroundColor(vNode.style.backgroundColor)
  .fontColor(vNode.href ? vNode.style.hrefFontColor : vNode.style.fontColor)
  .fontSize(vNode.style.fontSize)
  .onClick((event: ClickEvent) => {
    if (vNode.href) {
      promptAction.showToast({ message: vNode.href })
    }
  })
}


//如果是Span则没有子控件，属性放在Span上
//如果是 ContainerSpan，只允许一级子控件
