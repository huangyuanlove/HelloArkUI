import common from '@ohos.app.ability.common';
import router from '@ohos.router';
import { BaseListItem } from '../../comm/BaseListItem';
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
          let want = {
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
          }).catch((err) => {

          })

        })
        Button("webview").onClick(()=>{
          router.pushUrl({url:"WebViewPage",params:{path:"https://www.chunyuyisheng.com"}})
        })
      }
    }.width('100%').height('100%').padding({top:48})

  }
}


