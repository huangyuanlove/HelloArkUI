## 对富文本要求
1. 只支持 font、span、a标签
2. ~~不允许标签嵌套~~ 不允许带有背景色的标签多层嵌套
3. 颜色属性请用16进制表示

## 限制
* Span控件没有backgroundColor属性，只能放在ContainerSpan控件或者Text控件上

* ContainerSpan控件只允许使用Span控件，因此，只能有一个或多个Span控件

## 解析
按照上面的限制，最多支持这种情况
``` typescript
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
```
1. 判断是否是多个一级标签，如果是多个一级标签，则只能解析为
``` typescript
Text(){
  ContainerSpan(){}.textBackgroundStyle() //1级标签对应的控件
  ContainerSpan(){}.textBackgroundStyle()
}

```
2. 如果只有一个一级标签，则可以解析为
``` typescript
Text(){
}.backgroundColor()
```


如果有background属性，则需要包一层 ContainerSpan，因为span不支持背景色
如果是

如果是 Span 则没有子控件，属性放在Span上
如果是 ContainerSpan，只允许一级子控件
