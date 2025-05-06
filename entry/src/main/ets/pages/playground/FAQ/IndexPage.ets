import { BaseListItem } from '../../../comm/BaseListItem';
import { User } from './as_bug/UseASPage';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct IndexPage {
  @State message: string = 'Hello World';

  build() {
    Flex({wrap:FlexWrap.Wrap}){
      BaseListItem({ label: '键盘弹出', path: 'pages/playground/FAQ/keyboard_show/KeyBoardPage' })
      BaseListItem({ label: '循环渲染刷新', path: 'pages/playground/FAQ/for_each/ForeachPage' })
      // BaseListItem({ label: 'as 类型强转问题', path: 'pages/playground/FAQ/as_bug/FirstASTestPage' })
      Button("as 类型强转问题").onClick((_)=>{

      //   userParam.name = 'FirstASTestPage'
      //   router.pushUrl({url:'pages/playground/FAQ/as_bug/UseASPage',params:userParam})
      })
      BaseListItem({ label: 'DialogController', path: 'pages/playground/FAQ/dialog_controller/DialogControllerPage' })

    }
    .height('100%')
    .width('100%')
  }
}