import ActionBar from '../../comm/ActionBar';
import { notificationManager } from '@kit.NotificationKit';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { common } from '@kit.AbilityKit';

const TAG:string = "IconBadgePage"

@Entry
@Component
struct IconBadgePage {
  @State message: string = 'Hello World';

  build() {
    Column() {
      ActionBar({title:"设置桌面图标角标"})
      Button("设置角标").onClick(async  (_)=>{

        let hasPermission = await this.isNotificationEnable()
        if(hasPermission){
          notificationManager.setBadgeNumber(2).then(()=>{
            promptAction.showToast({message:"设置角标成功，如未展示，请开启通知权限中的桌面角标权限"})
          }).catch((error:BusinessError)=>{
            promptAction.showToast({message:`设置角标失败 ${error.message}`})
          })
        }else{
          promptAction.showToast({message:"没有权限"})
        }


      })
      Button("清除角标").onClick(async(_)=>{
        let hasPermission = await this.isNotificationEnable()
        if(hasPermission){
          notificationManager.setBadgeNumber(0).then(()=>{
            promptAction.showToast({message:"清除角标成功，如未清除，请开启通知权限中的桌面角标权限"})
          }).catch((error:BusinessError)=>{
            promptAction.showToast({message:`清除角标失败 ${error.message}`})
          })
        }else{
          promptAction.showToast({message:"没有权限"})
        }


      })

    }
    .height('100%')
    .width('100%')
  }


   async  isNotificationEnable(): Promise<boolean> {
    try {
      let enable = await notificationManager.isNotificationEnabled()
      if (enable) {
        return true
      } else {

        try {
          let context = getContext() as common.UIAbilityContext;
          await  notificationManager.requestEnableNotification(context)
          return true
        }catch (error){
          if(error.code === 1600004){
            hilog.error(0x01, TAG,
              `[ANS] requestEnableNotification refused, code is ${error.code}, message is ${error.message}`);
          }else{
            hilog.error(0x01, TAG,
              `[ANS] requestEnableNotification failed, code is ${error.code}, message is ${error.message}`);
          }
          return false
        }
      }
    } catch (err) {
      hilog.error(0x01, TAG, `isNotificationEnabled fail, code is ${err.code}, message is ${err.message}`);
      return false
    }
  }
}