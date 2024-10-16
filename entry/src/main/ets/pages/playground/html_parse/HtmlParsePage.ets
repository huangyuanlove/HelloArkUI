import { xml, util } from '@kit.ArkTS'; // 需要使用util模块函数对文件编码
import { hilog } from '@kit.PerformanceAnalysisKit';
import { copyStyle, Style, VNode } from './VNode';
import { promptAction } from '@kit.ArkUI';
import { Stack } from '@kit.ArkTS';
import { HtmlRender } from './HtmlRender';

@Entry
@Component
struct HtmlParsePage {

  private htmlContent: string =
    `<span> 123\n <font  color="red"> <a href="https://www.baidu.com">点我跳转到百度</a></font> <br/><font> 这位姑娘有一双</font><span style="color:#ff6134;font-size:40px;background:yellow">蓝色的眼睛。</span></span>`






  build() {
    Column(){
      HtmlRender({htmlContent:this.htmlContent})
    }

  }


}



//如果是Span则没有子控件，属性放在Span上
//如果是 ContainerSpan，只允许一级子控件
