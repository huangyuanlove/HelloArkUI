import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { systemDateTime } from '@kit.BasicServicesKit';
@HMRouter({pageUrl:'MultilevelPage1'})
@Component
export struct  MultilevelPage1{
  build() {
    Column(){
      Button('MultilevelPage2').onClick((_)=>{
        HMRouterMgr.push({pageUrl:'MultilevelPage2'})
      })
    }
  }
}