import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { systemDateTime } from '@kit.BasicServicesKit';
import { ActionBar } from '../../../../comm/ActionBar';


@HMRouter({pageUrl:'MultilevelPage2'})
@Component
export struct  MultilevelPage2{
  build() {
    Column(){
      ActionBar({title:"MultilevelPage2"})
      Button('MultilevelPage3').onClick((_)=>{
        HMRouterMgr.push({pageUrl:'MultilevelPage3'})
      })
    }
  }
}