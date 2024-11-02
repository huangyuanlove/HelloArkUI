import { BaseListItem } from '../../../comm/BaseListItem';

@Entry
@Component
struct IndexPage {
  @State message: string = 'Hello World';

  build() {
    Flex({wrap:FlexWrap.Wrap}){
      BaseListItem({ label: '键盘弹出', path: 'pages/playground/FAQ/keyboard_show/KeyBoardPage' })
      BaseListItem({ label: '循环渲染刷新', path: 'pages/playground/FAQ/for_each/ForeachPage' })
      BaseListItem({ label: 'as 类型强转问题', path: 'pages/playground/FAQ/as_bug/FirstASTestPage' })
      BaseListItem({ label: 'DialogController', path: 'pages/playground/FAQ/dialog_controller/DialogControllerPage' })
    }
    .height('100%')
    .width('100%')
  }
}