import Notification from '@ohos.notificationManager'
import NotificationRequest from '@ohos.notificationManager'
import { ActionBar } from '../../comm/ActionBar';
import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct NotificationPage {



  requestNotification(){
    notificationManager.isNotificationEnabled().then((data:boolean)=>{
      if(!data){
        let context = getContext(this) as common.UIAbilityContext;
        notificationManager.requestEnableNotification(context).then(()=>{
          hilog.info(0x01, "requestNotification", `[ANS] requestEnableNotification success`);
        }).catch((err : BusinessError) => {
          if(1600004 == err.code){
            hilog.error(0x01, "requestNotification", `[ANS] requestEnableNotification refused, code is ${err.code}, message is ${err.message}`);
          } else {
            hilog.error(0x01, "requestNotification", `[ANS] requestEnableNotification failed, code is ${err.code}, message is ${err.message}`);
          }
        });
      }
    }).catch((err : BusinessError) => {
      hilog.error(0x01, "requestNotification", `isNotificationEnabled fail: ${JSON.stringify(err)}`);
    });
  }

  // publishCallback(err) {
  //   if (err) {
  //     console.info("publish failed " + JSON.stringify(err));
  //   } else {
  //     console.info("publish success");
  //   }
  // }

  build() {
    Column() {
      ActionBar({ title: '通知' })
      Button("获取通知权限").onClick((_)=>{
        this.requestNotification()
      })
      Button("普通文本类型").onClick(() => {

        let notificationRequest: notificationManager.NotificationRequest = {
          id: 1,
          content: {
            notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT, // 普通文本类型通知
            normal: {
              title: 'test_title',
              text: 'test_text',
              additionalText: 'test_additionalText',
            }
          }
        };
        notificationManager.publish(notificationRequest, (err: BusinessError) => {
          if (err) {
            hilog.error(0x01, "publishNotification", `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
            return;
          }
          hilog.info(0x01, "publishNotification", 'Succeeded in publishing notification.');
        });
      }).margin(10)

      Button("多行文本类型").onClick(() => {
        let notificationRequest: notificationManager.NotificationRequest = {
          id: 3,
          content: {
            notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE, // 多行文本类型通知
            multiLine: {
              title: 'test_title',
              text: 'test_text',
              briefText: 'test_briefText',
              longTitle: 'test_longTitle',
              lines: ['line_01', 'line_02', 'line_03', 'line_04'],
            }
          }
        };
        // 发布通知
        notificationManager.publish(notificationRequest, (err: BusinessError) => {
          if (err) {
            hilog.error(0x01, "publishNotification", `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
            return;
          }
          hilog.info(0x01, "publishNotification", 'Succeeded in publishing notification.');
        });
      }).margin(10)
      Button("进度条通知").onClick(() => {
        notificationManager.isSupportTemplate('downloadTemplate').then((data:boolean) => {
          hilog.info(0x01, "downloadTemplate", 'Succeeded in supporting download template notification.');
          let isSupportTpl: boolean = data; // isSupportTpl的值为true表示支持downloadTemplate模板类通知，false表示不支持
          if(isSupportTpl){
            let notificationRequest: notificationManager.NotificationRequest = {
              id: 5,
              content: {
                notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
                normal: {
                  title: 'test_title',
                  text: 'test_text',
                  additionalText: 'test_additionalText'
                }
              },
              // 构造进度条模板，name字段当前需要固定配置为downloadTemplate
              template: {
                name: 'downloadTemplate',
                data: { title: 'File Title', fileName: 'music.mp4', progressValue: 45 }
              }
            }

            // 发布通知
            notificationManager.publish(notificationRequest, (err: BusinessError) => {
              if (err) {
                hilog.error(0x01, "downloadTemplate", `Failed to publish notification. Code is ${err.code}, message is ${err.message}`);
                return;
              }
              hilog.info(0x01, "downloadTemplate", 'Succeeded in publishing notification.');
            });

          }else{
            promptAction.showToast({message: "不支持进度条类型"})
          }
        }).catch((err: BusinessError) => {
          hilog.error(0x01, "downloadTemplate", `Failed to support download template notification. Code is ${err.code}, message is ${err.message}`);
        });
      }).margin(10)
      Button("取消通知").onClick(() => {

      }).margin(10)
    }
  }
}