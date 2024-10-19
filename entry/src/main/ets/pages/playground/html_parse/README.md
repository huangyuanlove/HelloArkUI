---
title: 鸿蒙-做一个简版的富文本解析控件
tags: [HarmonyOS]
date: 2024-10-17 21:30:03
keywords: HarmonyOS,鸿蒙应用开发,鸿蒙手机应用开发,XmlPullParser,Html解析,Html展示
---
本来只是需要展示一下简单的富文本，支持简单的背景色，字体大小，字体颜色就够了。调研了一圈都没有完全符合需求的。那就自己撸一个呗。
支持 span、font、br、a标签就好，属性的话就支持color、font-color、size、font-size、background、href这些属性就好了。

<!--more-->
老规矩，先上效果图

![富文本解析.png](/image/HarmonyOS/html_parse_render.png)

最上方是在浏览器中的表现，手机截图分割线中间是自己撸的控件，最下方是鸿蒙自带的`RichText`

看起来还行，主要是自己写的，调整起来也方便

## 限制

1. 目前只支持了上面说的那些标签级属性：span、font、br、a标签 和 color、font-color、size、font-size、background、href这些属性
2. 富文本的解析使用的是`xml.XmlPullParser`,因此对富文本内容中的标签要求比较严格，一定要严格闭合才行，否则解析会失败。
3. 也要求所有元素都必须包含在标签内容，否则也会失败，应对这个问题，可以通过在富文本最外层添加没有属性的span标签解决
4. 对于颜色值，只支持了有限了英文名字，建议使用十六进制表示

## 结果展示

解析结果的展示是`Text`中嵌套`Span`和`ContainerSpan`实现的：
1. `Span`不支持背景色，要么只能依赖父级控件`Text`或者父级控件`ContainerSpan`来设置背景色
2. `ContainerSpan`只能包含`Span`、`ImageSpan`子组件。
3. `Span`、`ImageSpan` 没有子控件

也就是说解析结果只有一个`Text`控件，内容样式都由`Span`和`ContainerSpan`完成

## 思路

展示结果使用`Text`嵌套`Span`和`ContainerSpan`实现,将样式抽成一个类，要展示的文字作为属性就好了。
``` TypeScript
export class VNode{
  text:string=''
  child?:VNode[]=[]
  style:Style= new Style()
}

/**
 * 属性默认值都可以做成配置，由调用者传入
 */
export class Style{
  //如果有backGround属性需要使用 ContainerSpan
  backgroundColor:string|Resource|Color=Color.Transparent
  fontSize:number = 16
  fontColor:string|Resource|Color = Color.Black
  hrefFontColor:string|Resource|Color = Color.Blue
  href:string | undefined
}
```
为了方便的话，这里的`Style`属性默认值可以做成配置的，由调用者传入，方便定制。  
如果父级标签设置了背景颜色、文字颜色等属性，子控件没有设置的话，需要继承父标签的属性。如果子标签也设置了属性，则需要覆盖父控件对应的属性。简单来讲就是需要合并子标签和父标签的属性来作为子标签的属性，当然，子标签属性值优先级高于父标签，也就是子标签属性值覆盖父标签的属性值。

就拿截图中的例子来讲：
``` html
<span style="color:blue;background:yellow">
  这位姑娘有一双 
    <span style="color:blue;background:red">蓝
        <span style="color:red;background:blue">色</span>
    </span>
  的眼睛
</span>
```
代码按照`xml`样式格式化了一下，看着方便
`蓝`这个字的父级标签设置了背景色为`yellow`,字体颜色为`blue`,所以`这位姑娘有一双`这几个字的背景色就是`yellow`，字体颜色为`blue`。但`蓝`这个字的标签同样设置了背景色为`red`,优先级要高于父标签，所以`蓝`这个字的背景色为`red`。  
`的眼睛`是和`这位姑娘有一双`同级的文字，因此背景色和字体颜色也是一致的。

基于上面的规则，很自然的想到使用`Stack`来保存每一层级的属性，遇到开始标签则复制一份父控件的样式属性(栈顶元素)然后入栈。遇到结束标签则出栈。注意下`br`标签，只是换行，不会有样式，直接添加一个`Span('\n')`就行。

## 实现

基于我们的需求，需要展示的富文本不会很复杂，最多也就是上面说的这些属性，鸿蒙正好也由自带的`xml`解析，用来解析富文本也行。
具体文档可以看这里 [XML解析](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/xml-parsing-V5)

### xml.XmlPullParser
这里简单介绍一下流程，
需要导入 `import { util, xml } from "@kit.ArkTS";` 这两个包，其中需要用`util`对富文本进行编码，防止中文和特殊符号乱码。

首先准备好富文本，并且编码一下,创建`xml.XmlPullParser`对象
``` TypeScript
// 对数据编码，防止包含中文字符乱码
let textEncoder: util.TextEncoder = new util.TextEncoder();
let arrBuffer: Uint8Array = textEncoder.encodeInto(this.htmlContent);
let xmlPullParser: xml.XmlPullParser = new xml.XmlPullParser(arrBuffer.buffer as object as ArrayBuffer, 'UTF-8');
```
调用开始解析的方法需要传入一个`xml.ParseOptions`对象，这个是重点。  
这个对象由三个回调方法：`tagValueCallbackFunction`、`attributeValueCallbackFunction`和`tokenValueCallbackFunction`。我们在解析的过程中需要知道标签名(根据标签名解析属性值)，标签的开始和结束以及标签包裹的文本。因此我们这里只需要`attributeValueCallbackFunction` 和 `tokenValueCallbackFunction`这两个回调就好了。  
先来打印一下解析出来的数据，再决定后面怎么获取属性值
``` TypeScript
attributeValueCallback(name: string, value: string): boolean {
  let str = name + ' ' + value + ' ';
  hilog.error(0x01, 'HtmlParsePage', `attribute  ${str}`)
    return true; // true:继续解析 false:停止解析
}
tokenValueCallback(name: xml.EventType, value: xml.ParseInfo): boolean {
  //只需要关心 START_TAG  END_TAG TEXT 这三个类型就好
  let nameStr = ''
  if(name == xml.EventType.START_TAG || name == xml.EventType.END_TAG || name == xml.EventType.TEXT){
    nameStr = this.getTagEventName(name)
  }else{
    return true
  }

  hilog.error(0x01, 'HtmlParsePage', `token    ${nameStr}  getName:${value.getName()}    getText:${value.getText()} `)
  return true
}

getTagEventName(name: xml.EventType):string{
  let nameStr = ''
    if (name == xml.EventType.START_TAG) {
    nameStr = 'START_TAG'
  } else if (name == xml.EventType.END_TAG) {
    nameStr = 'END_TAG'
  } else if (name == xml.EventType.TEXT) {
    nameStr = 'TEXT'
  }
  return nameStr
}
```

然后我们开始解析，看看打印出来的数据
``` TypeScript

let options: xml.ParseOptions = {
  supportDoctype: true,
  ignoreNameSpace: true,
  attributeValueCallbackFunction: this.attributeValueCallback.bind(this),
  tokenValueCallbackFunction: this.tokenValueCallback.bind(this)
};
xmlPullParser.parse(options);
```


### 得到属性值

然后我们就可以看到结果
``` text
token    START_TAG  getName:span    getText: 
attribute  style color:blue;background:yellow 
token    TEXT  getName:    getText:这位姑娘有一双  
token    START_TAG  getName:span    getText: 
attribute  style color:blue;background:red 
token    TEXT  getName:    getText:蓝 
token    START_TAG  getName:span    getText: 
attribute  style color:red;background:blue 
token    TEXT  getName:    getText:色 
token    END_TAG  getName:span    getText: 
token    END_TAG  getName:span    getText: 
token    TEXT  getName:    getText:的眼睛 
token    END_TAG  getName:span    getText: 
```
这就好办多了，就像上面思路中说的一样：遇到`START_TAG`复制一个父标签属性对象，在属性回调中解析属性并设置属性，然后入栈。遇到`TEXT`则根据有无背景色属性添加一个`ContainerSpan`或者`Span`,遇到`END_TAG`则属性出栈。    
对于属性解析，`style`属性根据`;`分割一下，将结果再按`:`分割，就得到了我们想要的属性名字(color、backgroud等)和属性值。然后我们就可以映射成抽象出来的`Style`类。  
哦，对了，还有一点，如果颜色的属性值是`red`、`green`这种英文名字，需要解析成对应的十六进制或者在鸿蒙中对应的Color对象。

### 映射
按照上面的介绍，我们在`tokenValueCallback`创建样式或者`Span`、`ContainerSpan`。在`attributeValueCallback`中解析具体属性
``` TypeScript
  attributeValueCallback(name: string, value: string): boolean {
    let str = name + ' ' + value + ' ';
    hilog.error(0x01, 'HtmlParsePage', `attribute  ${str}`)
    if (name === 'href') {
      this.styleStack.peek().href = value
    } else if (name === 'size') {
      if (value.includes('px')) {
        let tmp = value.replace('px', '')
        this.styleStack.peek().fontSize = px2fp(parseInt(tmp))
      } else {
        this.styleStack.peek().fontSize = px2fp(parseInt(value))
      }
    } else if (name === 'style') {
      let attributes: string[] = value.split(';')
      attributes.forEach((attribute: string) => {
        let tmp: string [] = attribute.split(':')
        if (tmp[0] === 'color') {
          this.styleStack.peek().fontColor = this.getColorWithStr(tmp[1])
        } else if (tmp[0] === 'background') {
          this.styleStack.peek().backgroundColor = this.getColorWithStr(tmp[1])
        } else if (tmp[0] === 'font-size') {
          this.styleStack.peek().fontSize = px2fp(parseInt(tmp[1].replace('px', '')))
        }
      })
    } else if (name === 'color') {
      this.styleStack.peek().fontColor = this.getColorWithStr(value)
    }
    return true; // true:继续解析 false:停止解析
  }

  tokenValueCallback(name: xml.EventType, value: xml.ParseInfo): boolean {
    //只需要关心 START_TAG  END_TAG TEXT 这三个类型就好
    let nameStr = ''
    if(name == xml.EventType.START_TAG || name == xml.EventType.END_TAG || name == xml.EventType.TEXT){
      nameStr = this.getTagEventName(name)
    }else{
      return true
    }

    hilog.error(0x01, 'HtmlParsePage', `token    ${nameStr}  getName:${value.getName()}    getText:${value.getText()} `)
    if (name === xml.EventType.TEXT) {
      let vNode: VNode = new VNode()
      vNode.text = value.getText()
      vNode.style = copyStyle(this.styleStack.peek())
      this.rootNode.child?.push(vNode)
    }

    if (name === xml.EventType.START_TAG) {
      if (value.getName() === 'br') {
        let lineBreakSpan = new VNode()
        lineBreakSpan.text = '\n'
        this.rootNode.child?.push(lineBreakSpan)
      }
      if (value.getName() === 'font' || value.getName() === 'span' || value.getName() === 'a') {
        if (this.styleStack.isEmpty()) {
          this.styleStack.push(new Style())
        } else {
          let style = copyStyle(this.styleStack.peek())
          this.styleStack.push(style)
        }
      }
    }
    if (name === xml.EventType.END_TAG && (value.getName() === 'font' || value.getName() === 'span'|| value.getName() === 'a')) {
      this.styleStack.pop()
    }

    return true; //true:继续解析 false:停止解析
  }
```

## 渲染
所有的准备工作都做完了，渲染就成了最简单的一步。  
根节点使用Text控件，判断子节点Sytle背景色属性，如果设置了其他值，就使用`ContainerSpan(){Span()}`,如果没有，直接使用`Span()`.  
这里将属性写成了`Extend(Span)`形式
``` TypeScript
@Extend(Span)
function configSpanStyle(vNode: VNode) {
  .backgroundColor(vNode.style.backgroundColor)
  .fontColor(vNode.style.href ? vNode.style.hrefFontColor : vNode.style.fontColor)
  .fontSize(vNode.style.fontSize)
  .onClick((event: ClickEvent) => {
    if (vNode.style.href) {
      promptAction.showToast({ message: vNode.style.href })
    }
  })
}

  build() {
    if (this.hasParse) {
      this.buildWithVNode(this.rootNode)

    } else {
      LoadingProgress()
        .color(Color.Blue).width(10).height(10)

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
    }
  }
```

到这里就结束了，源码在github[github](https://github.com/huangyuanlove/HelloArkUI/blob/main/entry/src/main/ets/pages/playground/html_parse/HtmlParsePage.ets)、[gitee](https://gitee.com/huangyuan/HelloArkUI/blob/main/entry/src/main/ets/pages/playground/html_parse/HtmlParsePage.ets)

当然代码都是硬怼上去的，有很多可以改进的地方：
1. 上面提到的默认属性，可以由调用者传入
2. 结果标签和属性目前也是直接写死的支持哪些，其实可以做成责任链，解析可以让使用者自定义，更加方便扩展
3. 因为是使用xml的解析器，遇到不复合标准的富文本会崩溃，要么在解析上加个try catch。或者在使用无属性的`span`标签再包裹一下。建议可以两个都用上，毕竟墨菲定律

---- 

下个版本再说吧