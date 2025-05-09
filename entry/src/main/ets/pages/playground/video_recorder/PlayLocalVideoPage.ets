import { router } from '@kit.ArkUI';
import { RouterParams } from './RouterParams';
import { hilog } from '@kit.PerformanceAnalysisKit';
import {ActionBar} from '../../../comm/ActionBar';

@Entry
@Component
struct PlayLocalVideoPage {
  @State path: string = '';



  onPageShow() {
    try {
      this.path = (router.getParams() as RouterParams).data;
      hilog.error(0x01,'PlayLocalVideoPage',this.path)
    } catch (e) {
      hilog.error(0x01,'PlayLocalVideoPage', JSON.stringify(e))
      return;
    }
  }

  build() {
    Column() {
      ActionBar({title:'本地视频'})
      if(this.path){
        Video({
          src: 'file://' + this.path
        }).objectFit(ImageFit.Contain).width("100%").height("100%")
      }else{
        Text('路径为空')
      }

    }
    .height('100%')
    .width('100%')
  }
}