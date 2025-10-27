import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { systemDateTime } from '@kit.BasicServicesKit';
import { ActionBar } from '../../../../comm/ActionBar';

@HMRouter({pageUrl:'MultilevelPage3'})
@Component
export struct  MultilevelPage3{
  build() {
    Column(){
      ActionBar({title:"MultilevelPage3"})
      Button('返回HMRouterAPage').onClick((_)=>{
        HMRouterMgr.pop({pageUrl:'pages/playground/hmrouter_page/HMRouterAPage',param:{
          time:systemDateTime.getTime(),
          result:'success'
        }})
      })
    }
  }
}