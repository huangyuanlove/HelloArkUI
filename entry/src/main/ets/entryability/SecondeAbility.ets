
import UIAbility, { CalleeCallback } from '@ohos.app.ability.UIAbility';
import Window from '@ohos.window';
import { AbilityConstant, Want } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';

export default class SecondAbility extends UIAbility {


  onCreate(want:Want,launchParam:AbilityConstant.LaunchParam){
    let entryAbilityWant = want;
    let info = entryAbilityWant?.parameters?.info
    console.error('huangyuan',JSON.stringify(info));
    console.error('huangyuan',JSON.stringify(launchParam));

    try {
      // 监听call事件所需的方法
      this.callee.on('funA', FunACall);
      this.callee.on('funB', FunBCall);
    } catch (error) {
      console.log('register failed with error. Cause: ' + JSON.stringify(error));
    }


  }

  onWindowStageCreate(windowStage:Window.WindowStage){
    windowStage.loadContent('pages/Index',(err,data)=>{
      if(err.code){
        console.error('huangyuan','出错了')
        console.error(JSON.stringify(err) ?? '')
      }

    })
  }
  // 进程退出时，解除监听
  onDestroy() {
    try {
      this.callee.off('funA');
      this.callee.off('funB');
    } catch (error) {
      console.log('register failed with error. Cause: ' + JSON.stringify(error));
    }
  }

}

function FunACall(data:rpc.MessageSequence) {
  // 获取call事件中传递的所有参数
  console.log('FunACall param:' + JSON.stringify(data.readString()));
  return null;
}
function FunBCall(data:rpc.MessageSequence) {
  console.log('FunACall param:' + JSON.stringify(data.readString()));
  return null;
}
