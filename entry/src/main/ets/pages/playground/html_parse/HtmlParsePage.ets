import { xml, util } from '@kit.ArkTS'; // 需要使用util模块函数对文件编码
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct HtmlParsePage {
  private htmlContent: string =
    ` <font size="3" color="red"> <a href="https://www.baidu.com">点我跳转到百度</a> </font> <br/><span style="background:#1b91e0"> 这位姑娘有一双<span style="color:#ff6134;font-weight:bold;font-size:20px;background:yellow">蓝色</span>的眼睛。</span>`



  startParse() {
    let textEncoder: util.TextEncoder = new util.TextEncoder();
    let arrBuffer: Uint8Array = textEncoder.encodeInto(this.htmlContent); // 对数据编码，防止包含中文字符乱码
    // 1.基于ArrayBuffer构造XmlPullParser对象
    let that: xml.XmlPullParser = new xml.XmlPullParser(arrBuffer.buffer as object as ArrayBuffer, 'UTF-8');
    let options: xml.ParseOptions = {
      supportDoctype: true,
      ignoreNameSpace: true,
      tagValueCallbackFunction: this.tagValueCallback,
      attributeValueCallbackFunction: this.attributeValueCallback,
      tokenValueCallbackFunction: this.tokenValueCallback
    };
    that.parse(options);
  }

  attributeValueCallback(name: string, value: string): boolean {
    let str = name + ' ' + value + ' ';
    hilog.error(0x01, 'HtmlParsePage', `attributeValueCallback  ${str}`)
    return true; // true:继续解析 false:停止解析
  }

  tagValueCallback(name: string, value: string): boolean {
    let str = name + value;
    hilog.error(0x01, 'HtmlParsePage', `tagValueCallback  ${str}`)

    return true; //true:继续解析 false:停止解析
  }

  tokenValueCallback(name: xml.EventType, value: xml.ParseInfo): boolean {
    let str = name + ' ' + JSON.stringify(value); // getDepth 获取元素的当前深度
    let nameStr = '未知'
    if (name == xml.EventType.START_DOCUMENT) {
      nameStr = 'START_DOCUMENT'
    } else if (name == xml.EventType.END_DOCUMENT) {
      nameStr = 'END_DOCUMENT'
    } else if (name == xml.EventType.START_TAG) {
      nameStr = 'START_TAG'
    } else if (name == xml.EventType.END_TAG) {
      nameStr = 'END_TAG'
    } else if (name == xml.EventType.TEXT) {
      nameStr = 'TEXT'
    } else if (name == xml.EventType.CDSECT) {
      nameStr = 'CDSECT'
    } else if (name == xml.EventType.COMMENT) {
      nameStr = 'COMMENT'
    } else if (name == xml.EventType.DOCDECL) {
      nameStr = 'DOCDECL'
    } else if (name == xml.EventType.INSTRUCTION) {
      nameStr = 'INSTRUCTION'
    } else if (name == xml.EventType.ENTITY_REFERENCE) {
      nameStr = 'ENTITY_REFERENCE'
    } else if (name == xml.EventType.WHITESPACE) {
      nameStr = 'WHITESPACE'
    }
    let valueStr =
      `getName:${value.getName()}  getNamespace:${value.getNamespace()}  getPrefix:${value.getPrefix()}  getText:${value.getText()}  getColumnNumber:${value.getColumnNumber()}  getDepth:${value.getDepth()}  getLineNumber:${value.getLineNumber()}  getAttributeCount:${value.getAttributeCount()}`

    hilog.error(0x01, 'HtmlParsePage', `tokenValueCallback  ${nameStr}  ${valueStr}`)
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
        })
      Text() {
        Span("123").fontColor(Color.Red).fontSize(18)
        ContainerSpan() {
          Span("456").fontColor(Color.Blue).fontSize(24)
          Span("789").fontColor(Color.Green).fontSize(16)
        }.textBackgroundStyle({color: "#7F007DFF", radius: 6,})

        ContainerSpan() {
          Span("1011").fontColor(Color.Blue).fontSize(24)
          Span("1213").fontColor(Color.Green).fontSize(16)
        }.textBackgroundStyle({color: "#7F107DFF", radius: 6,})
        ContainerSpan()
      }.backgroundColor(Color.Orange)
    }
  }
}

//如果是Span则没有子控件，属性放在Span上
//如果是 ContainerSpan，只允许一级子控件
