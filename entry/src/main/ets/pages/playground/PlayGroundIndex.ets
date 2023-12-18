
import { BaseListItem } from '../../comm/BaseListItem'

@Component
export struct  PlayGroundIndex {

  build(){
    Flex({wrap:FlexWrap.Wrap}){
      BaseListItem({ label: '手写签名', path: 'pages/playground/SignatureWithCanvas' })
    }.width("100%").height("100%").padding({top:48})
  }

 }

