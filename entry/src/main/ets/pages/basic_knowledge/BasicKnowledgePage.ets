import common from '@ohos.app.ability.common';
import router from '@ohos.router';
import { BaseListItem } from '../../comm/BaseListItem';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@kit.BasicServicesKit';
import { reminderAgentManager } from '@kit.BackgroundTasksKit';
import { notificationManager } from '@kit.NotificationKit';
import { promptAction } from '@kit.ArkUI';

@Preview
@Component
export default struct  BasicKnowledgePage{
  build(){
    Column(){
      Flex({ wrap: FlexWrap.Wrap, }) {
        BaseListItem({ label: '基础', path: 'pages/basic_knowledge/Base' })
        BaseListItem({ label: '生命周期', path: 'pages/basic_knowledge/LifeCirclePage' })
        BaseListItem({ label: '参数传递', path: 'pages/basic_knowledge/AboutParams' })
        BaseListItem({ label: '构建参数', path: 'pages/basic_knowledge/AboutBuildParams' })
        BaseListItem({ label: '@Styles装饰器', path: 'pages/basic_knowledge/AboutStyleAnno' })
        BaseListItem({ label: '@Extend装饰器', path: 'pages/basic_knowledge/AboutExtendAnno' })
        BaseListItem({ label: '@stateStyles', path: 'pages/basic_knowledge/AboutStateStyles' })
        BaseListItem({ label: '状态管理', path: 'pages/basic_knowledge/AboutStateManagement' })
        BaseListItem({ label: '通知', path: 'pages/basic_knowledge/NotificationPage' })

        Button() {
          Text('打开 UIAbility').fontSize(18)
            .padding(10)
        }
        .type(ButtonType.Normal)
        .borderRadius(10)
        .margin(10)
        .backgroundColor($r('app.color.green_39d169'))
        .onClick(() => {
          let context = getContext(this) as common.UIAbilityContext;
          let want:Want = {
            deviceId: '', // deviceId为空表示本设备
            bundleName: 'com.huangyuanlove.arkui_demo',
            abilityName: 'SecondAbility',
            moduleName: 'entry', // moduleName非必选
            parameters: { // 自定义信息
              info: '来自EntryAbility Index页面',
            },
          }
          //不接受返回结果，类似 Android startActivity
          // context.startAbility(want).then(()=>{
          //
          // }).catch((err)=>{
          //
          // })

          //接受返回结果 类似 Android startActivityForResult
          context.startAbilityForResult(want).then((data) => {
            if (data?.resultCode === 10001) {
              // 解析被调用方UIAbility返回的信息
              let info = data.want?.parameters?.info
            }
          }).catch((err:BusinessError) => {
            console.error(`startAbilityForResult failed, code is ${err.code}, message is ${err.message}`);
          })

        })
        Button("webview").onClick(()=>{
          router.pushUrl({url:"WebViewPage",params:{path:"https://www.chunyuyisheng.com"}})
        })
        Button('代理提醒').onClick((_)=>{
          let targetReminderAgent: reminderAgentManager.ReminderRequestAlarm = {
            reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_ALARM, // 提醒类型为闹钟类型
            hour: 22, // 指明提醒的目标时刻
            minute: 25, // 指明提醒的目标分钟
            daysOfWeek: [1,2,3,4,5,6], // 指明每周哪几天需要重复提醒
            actionButton: [ // 设置弹出的提醒通知信息上显示的按钮类型和标题
              {
                title: 'close',
                type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
              },
              {
                title: 'snooze',
                type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_SNOOZE
              },
            ],
            wantAgent: { // 点击提醒通知后跳转的目标UIAbility信息
              pkgName: 'com.example.myapplication',
              abilityName: 'EntryAbility'
            },
            ringDuration: 5, // 指明响铃时长（单位：秒）
            snoozeTimes: 2, // 指明延迟提醒次数
            timeInterval: 5*60, // 执行延迟提醒间隔（单位：秒）
            title: 'this is title', // 指明提醒标题
            content: 'this is content', // 指明提醒内容
            expiredContent: 'this reminder has expired', // 指明提醒过期后需要显示的内容
            snoozeContent: 'remind later', // 指明延迟提醒时需要显示的内容
            notificationId: 99, // 指明提醒使用的通知的ID号，相同ID号的提醒会覆盖
            slotType: notificationManager.SlotType.SOCIAL_COMMUNICATION // 指明提醒的Slot类型
          }


          reminderAgentManager.publishReminder(targetReminderAgent).then((res: number) => {
            console.info('Succeeded in publishing reminder. ');
            let reminderId: number = res; // 发布的提醒ID
            promptAction.showToast({message:'发布提醒成功 ' + reminderId})
          }).catch((err: BusinessError) => {
            console.error(`Failed to publish reminder. Code: ${err.code}, message: ${err.message}`);
          })

        })
      }
    }.width('100%').height('100%').padding({top:48})

  }
}


