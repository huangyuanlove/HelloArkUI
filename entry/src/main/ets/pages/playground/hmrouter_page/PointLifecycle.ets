import { HMLifecycle, HMLifecycleContext, HMRouterMgr, IHMLifecycle } from '@hadss/hmrouter';
import hilog from '@ohos.hilog';

@HMLifecycle({lifecycleName : 'pointLifecycle',global:true})
export class PointLifecycle implements IHMLifecycle {


  // onPrepare?(ctx: HMLifecycleContext): void;
  // onAppear?(ctx: HMLifecycleContext): void;
  // onDisAppear?(ctx: HMLifecycleContext): void;
  // onShown?(ctx: HMLifecycleContext): void;
  // onHidden?(ctx: HMLifecycleContext): void;
  // onWillAppear?(ctx: HMLifecycleContext): void;
  // onWillDisappear?(ctx: HMLifecycleContext): void;
  // onWillShow?(ctx: HMLifecycleContext): void;
  // onWillHide?(ctx: HMLifecycleContext): void;
  // onReady?(ctx: HMLifecycleContext): void;
  // onBackPressed?(ctx: HMLifecycleContext): boolean;
 public  intercept:boolean = false

  onPrepare(ctx: HMLifecycleContext): void {

  }
  onAppear(ctx: HMLifecycleContext): void {
    let info = ''

    if(ctx.navContext){
      info +=  'navPathName: ' +ctx.navContext?.pathInfo.name
    }
    info += '\trouterPath : ' +  ctx.uiContext.getRouter().getState().path +ctx.uiContext.getRouter().getState().name
    hilog.error(0x01,'PointLifecycle','onAppear-->' +info)


  }



}