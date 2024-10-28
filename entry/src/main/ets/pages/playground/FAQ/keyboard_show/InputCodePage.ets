import ActionBar from '../../../../comm/ActionBar'
import { FourText } from '../../input/FourText'
import { FourTextInput } from '../../input/FourTextInput'

@Entry
@Component
struct  InputCodePage{
  build() {
    Column(){
      ActionBar({title:'输入验证码'})
      FourText()
    }
  }
}