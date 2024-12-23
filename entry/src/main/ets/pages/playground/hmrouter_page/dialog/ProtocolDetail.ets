import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';

@HMRouter({pageUrl:'protocol_detail'})
@Component
export struct ProtocolDetail{
  build() {
    Column(){
      Text('具体内容')
      Button('返回').margin(10).onClick((_)=>{
        HMRouterMgr.pop()
      })
    }
  }
}