
import UIAbility from '@ohos.app.ability.UIAbility';
import Window from '@ohos.window';
export default class SecondAbility extends UIAbility {


  onCreate(want,launchParam){
    let entryAbilityWant = want;
    let info = entryAbilityWant?.parameters?.info
    console.error('huangyuan',JSON.stringify(info));
    console.error('huangyuan',JSON.stringify(launchParam));
  }

  onWindowStageCreate(windowStage:Window.WindowStage){
    windowStage.loadContent('pages/Index',(err,data)=>{
      if(err.code){
        console.error('huangyuan','出错了')
        console.error(JSON.stringify(err) ?? '')
      }

    })
  }

}

