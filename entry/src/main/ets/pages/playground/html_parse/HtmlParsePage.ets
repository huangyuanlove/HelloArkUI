import { HtmlRender } from './HtmlRender';
import { promptAction } from '@kit.ArkUI';
import { Style } from './VNode';
import { ActionBar } from '../../../comm/ActionBar';

@Entry
@Component
struct HtmlParsePage {

  private htmlContent:string = '<span style="color:blue;background:yellow">这位姑娘有一双 <span style="color:blue;background:red">蓝<span style="color:red;background:blue">色</span></span>的眼睛</span> <a href="https://example.com">这是链接</a>'

  build() {
    Column(){
      ActionBar({title:"富文本解析与渲染"})
      Text(this.htmlContent)
      Divider().vertical(false).color(Color.Gray).height(2).margin(15)
      HtmlRender({htmlContent:this.htmlContent})
      Divider().vertical(false).color(Color.Gray).height(2).margin(15)
      HtmlRender({htmlContent:this.htmlContent,defaultStyle:{fontSize:14,hrefFontColor:Color.Red,fontColor:Color.Brown} as Style, onLinkClick:(link:string)=>{
        promptAction.showToast({message:`点击了链接 ${link}`})

      }})
    }

  }

}

