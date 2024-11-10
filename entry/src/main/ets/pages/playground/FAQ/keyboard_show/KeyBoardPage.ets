/**
 * 上一个页面键盘未关闭，下个页面使用 InputMethod.getController.show  后没有回调，具体见诊所端验证码登录
 */
import ActionBar from '../../../../comm/ActionBar'
import { router } from '@kit.ArkUI'
import { inputMethod } from '@kit.IMEKit'

@Entry
@Component
struct  KeyBoardPage{
  build() {
    Column(){
      ActionBar({title:'登录页面'})

      TextInput().onChange((value: string, previewText?: PreviewText)=>{

      })
      Text('获取验证码').onClick((_)=>{
        router.pushUrl({url:'pages/playground/FAQ/keyboard_show/InputCodePage'})
      })
    }



  }
}