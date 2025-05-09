
import { ActionBar } from '../../comm/ActionBar';
import { ScratchOffView } from './ScratchOffView'
/**
 * 刮奖效果
 */
@Entry
@Component
struct ScratchOffPage{
  build(){
      Column(){
        ActionBar({title:"刮奖效果"})
        ScratchOffView().width("100%").height("50%")
      }
  }
}