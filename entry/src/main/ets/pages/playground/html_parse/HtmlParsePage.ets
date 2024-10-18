import { HtmlRender } from './HtmlRender';
@Entry
@Component
struct HtmlParsePage {

  private htmlContent:string = '<span style="color:blue;background:yellow">这位姑娘有一双 <span style="color:blue;background:red">蓝<span style="color:red;background:blue">色</span></span>的眼睛</span> <a href="https://example.com">这是链接</a>'

  build() {
    Column(){
      Text(this.htmlContent)
      Divider().vertical(false).color(Color.Gray).height(2).margin(15)
      HtmlRender({htmlContent:this.htmlContent})
      Divider().vertical(false).color(Color.Gray).height(2).margin(15)
      RichText(this.htmlContent).backgroundColor(Color.Grey).height(200)
    }

  }


}



//如果是Span则没有子控件，属性放在Span上
//如果是 ContainerSpan，只允许一级子控件
