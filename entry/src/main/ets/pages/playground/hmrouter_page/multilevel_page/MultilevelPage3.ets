import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { systemDateTime } from '@kit.BasicServicesKit';

@HMRouter({pageUrl:'MultilevelPage3'})
@Component
export struct  MultilevelPage3{
  build() {
    Column(){
      Button('返回HMRouterAPage').onClick((_)=>{
        HMRouterMgr.pop({pageUrl:'pages/playground/hmrouter_page/HMRouterAPage',param:{
          time:systemDateTime.getTime(),
          result:'success'
        }})
      })
    }
  }
}