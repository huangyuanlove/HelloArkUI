import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { ActionBar } from '../../../../comm/ActionBar';

@HMRouter({pageUrl:'protocol_detail'})
@Component
export struct ProtocolDetail{
  build() {
    Column(){
      ActionBar({title:"弹窗协议"})
      Text('具体内容')
      Button('返回').margin(10).onClick((_)=>{
        HMRouterMgr.pop()
      })
    }
  }
}