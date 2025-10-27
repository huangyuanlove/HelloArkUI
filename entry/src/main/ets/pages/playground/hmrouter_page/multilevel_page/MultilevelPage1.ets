import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { systemDateTime } from '@kit.BasicServicesKit';
import { ActionBar } from '../../../../comm/ActionBar';

@HMRouter({pageUrl:'MultilevelPage1'})
@Component
export struct  MultilevelPage1{
  build() {
    Column(){
      ActionBar({title:"MultilevelPage1"})
      Button('MultilevelPage2').onClick((_)=>{
        HMRouterMgr.push({pageUrl:'MultilevelPage2'})
      })
    }
  }
}