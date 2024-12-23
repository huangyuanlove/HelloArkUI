import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { systemDateTime } from '@kit.BasicServicesKit';



@HMRouter({pageUrl:'MultilevelPage2'})
@Component
export struct  MultilevelPage2{
  build() {
    Column(){
      Button('MultilevelPage3').onClick((_)=>{
        HMRouterMgr.push({pageUrl:'MultilevelPage3'})
      })
    }
  }
}