import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import { AbilityConstant, common, Want } from '@kit.AbilityKit';
import { JPushInterface } from '@jg/push';

export default class EntryAbility extends UIAbility {

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {

    JPushInterface.setAppKey("e876bc984fc96b94e2d4ccc7")
    JPushInterface.init(this.context.getApplicationContext())
    // //开启应用通知开关
    // notificationManager.requestEnableNotification().then(() => {
    //   hilog.debug(0x0000, "EntryAbility", '%{public}s', 'requestEnableNotification success');
    // }).catch((err: BusinessError) => {
    //   hilog.debug(0x0000, "EntryAbility", '%{public}s', "error = " + err);
    // })
    //
    //
    // //初始化GTSDK
    // PushManager.initialize({
    //   appId: 'm2EZ0ovk8hAnJVts9tEP63',
    //   context: this.context as common.UIAbilityContext,
    //   onSuccess: (cid: string) => {
    //     hilog.debug(0x0000, "GeTuiPush", '%{public}s', "个推SDK初始化成功，cid = " + cid);
    //   },
    //   onFailed: (error: string) => {
    //     hilog.debug(0x0000, "GeTuiPush", '%{public}s', "个推SDK初始化失败，error = " + error);
    //   }
    // })
    //
    //
    // PushManager.setPushCallback({
    //   // 接收 cid
    //   onReceiveClientId: (clientId: string) => {
    //     hilog.debug(0x0000, 'GeTuiPush', '%{public}s', "clientId = " + clientId);
    //   },
    //   //接收厂商token
    //   onReceiveDeviceToken: (token: string) => {
    //     hilog.debug(0x0000, 'GeTuiPush', '%{public}s', "token = " + token);
    //   },
    //   // cid 离线上线通知
    //   onReceiveOnlineState: (onLine: boolean) => {
    //     hilog.debug(0x0000, 'GeTuiPush', '%{public}s', "onLine = " + onLine);
    //   },
    //   //命令相应回复
    //   onReceiveCommandResult: (result: GTCmdMessage) => {
    //     hilog.debug(0x0000, 'GeTuiPush', '%{public}s', "cmd = " + JSON.stringify(result));
    //   },
    //   //sdk 收到透传消息
    //   onReceiveMessageData: (message: GTTransmitMessage) => {
    //     hilog.debug(0x0000, 'GeTuiPush', '%{public}s', "message = " + JSON.stringify(message));
    //   },
    //   //通知到达回调
    //   onNotificationMessageArrived: (message: GTNotificationMessage) => {
    //     hilog.debug(0x0000, 'GeTuiPush', '%{public}s', "message = " + JSON.stringify(message));
    //   },
    //   //通知点击回调, 需要配合PushManager.setClickWant(want)使用
    //   onNotificationMessageClicked: (message: GTNotificationMessage) => {
    //     hilog.debug(0x0000, 'GeTuiPush', '%{public}s', "message = " + JSON.stringify(message));
    //   },
    // })


  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/main/Main', (err) => {
      // windowStage.loadContent('pages/tel_inquiry_waiting_page/index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
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
