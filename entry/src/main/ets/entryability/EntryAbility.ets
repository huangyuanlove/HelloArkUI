import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import { AbilityConstant, common, Want } from '@kit.AbilityKit';
import { UIContext, window, uiObserver as observer, uiObserver } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { JSON } from '@kit.ArkTS';
import { HMRouterMgr } from '@hadss/hmrouter';
import { DialogHelper } from '@pura/harmony-dialog';
import { ExclusiveAppComponent, FlutterManager, MethodCall, MethodResult } from '@ohos/flutter_ohos';
import FlutterRouterPlugin from 'flutter_router';

export default class EntryAbility extends UIAbility implements ExclusiveAppComponent<UIAbility>{


  detachFromFlutterEngine(): void {
    // throw new Error('Method not implemented.');
  }

  getAppComponent(): UIAbility {
    return this;
  }



  private uiContext: UIContext | null = null;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {




    DialogHelper.setDefaultConfig((config) => {
      config.uiAbilityContext = this.context;
    })
    HMRouterMgr.init({
      context: this.context
    })

    FlutterManager.getInstance().pushUIAbility(this);
    FlutterRouterPlugin.setRouterPushHandler((path:string,args:Record<string,Object>|undefined,result: MethodResult)=>{
      console.error(`rouerHandler:path=> ${path} ,args=>${args}`)
      if(path=='HMRouterAPage'){
        HMRouterMgr.push({pageUrl:"pages/playground/hmrouter_page/HMRouterAPage",param:args,},{
          onResult:(popInfo:PopInfo)=>{
            if(popInfo){
              result.success(popInfo.result)
            }
          }
        })
        return true;
      }
      if(path =='pages/flutter/FromFlutterPage'){
        HMRouterMgr.push({pageUrl:'pages/flutter/FromFlutterPage',param:args},{
          onResult:(popInfo:PopInfo)=>{
            if(popInfo){
              result.success(popInfo.result)
            }else{
              result.success("")
            }
          }
        })
        return true
      }


      return false;
    });

    FlutterRouterPlugin.setRouterPopHandler((call:MethodCall,result: MethodResult)=>{
      console.error(`flutter 调用 pop  setRouterPopHandler:  ${call.method}  ${call.args}`)
      HMRouterMgr.pop({param:call.args})
      return true;
    })


    // 注册监听，范围是abilityContext内的page
    observer.on('routerPageUpdate', this.context, (info: observer.RouterPageInfo) => {
      if(info.state === observer.RouterPageState.ABOUT_TO_APPEAR){
        hilog.error(0x0000, 'routerPageUpdate', 'pageUpdate--> ' + info.name +" ABOUT_TO_APPEAR");
      //   //注册全局 HashMap，根据 info.name 获取对应业务名称
      }
    })
  }



  onDestroy(): void {

    FlutterManager.getInstance().popUIAbility(this);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
    observer.off('routerPageUpdate', this.context)
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    FlutterManager.getInstance().pushWindowStage(this, windowStage);
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err) => {
      // windowStage.loadContent('pages/tel_inquiry_waiting_page/index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
      windowStage.getMainWindow((err: BusinessError, data) => {
        let windowInfo: window.Window = data;
        // 获取UIContext实例
        this.uiContext = windowInfo.getUIContext();
        // 注册监听，范围是uiContext内的page
        observer.on('routerPageUpdate', this.uiContext, (info: observer.RouterPageInfo)=>{
          hilog.error(0x0000, 'routerPageUpdate', `uiContext ${ JSON.stringify(info)}`);
        })
      })
    });
  }

  onWindowStageDestroy(): void {
    FlutterManager.getInstance().popWindowStage(this);
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
    if (this.uiContext) {
      observer.off('routerPageUpdate', this.uiContext);
    }
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  onMemoryLevel(level: AbilityConstant.MemoryLevel) {
    let levelRes: number

    switch (level) {
      case AbilityConstant.MemoryLevel.MEMORY_LEVEL_MODERATE:
        levelRes = 5
        break
      case AbilityConstant.MemoryLevel.MEMORY_LEVEL_LOW:
        levelRes = 10
        break
      case AbilityConstant.MemoryLevel.MEMORY_LEVEL_CRITICAL:
        levelRes = 15
        break
    }
  }
}
