import { HMDefaultGlobalAnimator, HMNavigation, HMPopInfo, HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { AttributeUpdater } from '@kit.ArkUI';
import { PageDurationLifecycle } from './hmrouter/PageDurationLifecycle';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { ActionBar } from '../../../comm/ActionBar';


@HMRouter({ pageUrl: 'pages/playground/hmrouter_page/HMRouterAPage', })
@Component
export struct HMRouterAPage {
  @State pageResultValue: string = ''

  build() {
    Column() {
      ActionBar({title:"HMRouterAPage"})
      Button('带参数跳转到新页面').onClick((_) => {
        HMRouterMgr.push({
          pageUrl: 'pages/playground/hmrouter_page/HMRouterBPage', param: {
            key1: 'value1',
            key2: 123,
            key3: true,
          }
        }, {
          onResult: (popInfo: HMPopInfo) => {
            this.pageResultValue = JSON.stringify(popInfo.result)
            hilog.error(0x01, 'hmrouter', '带参数跳转到新页面 页面返回值-->' + JSON.stringify(popInfo))
          },
          onArrival: (() => {
            hilog.error(0x01, 'hmrouter', '带参数跳转到新页面 onArrival')
          }),
          onLost: (() => {
            hilog.error(0x01, 'hmrouter', '带参数跳转到新页面 onLost')
          })
        })
      }).margin(10)

      Button('跳转多级页面后返回').onClick((_) => {
        HMRouterMgr.push({
          pageUrl: 'MultilevelPage1', param: {
            key1: 'value1',
            key2: 123,
            key3: true,
          }
        }, {
          onResult: (popInfo: HMPopInfo) => {
            this.pageResultValue = JSON.stringify(popInfo.result)
            hilog.error(0x01, 'hmrouter', '跳转多级页面后返回 页面返回值-->' + JSON.stringify(popInfo))
          },
          onArrival: (() => {
            hilog.error(0x01, 'hmrouter', '跳转多级页面后返回 onArrival')
          }),
          onLost: (() => {
            hilog.error(0x01, 'hmrouter', '跳转多级页面后返回 onLost')
          })
        })
      }).margin(10)

      Button('在弹窗页面跳转新页面，新页面返回后弹窗不关闭').onClick((_) => {
        HMRouterMgr.push({ pageUrl: 'protocol_dialog' })
      }).margin(10)

      Button('返回时根据条件判断是否需要弹窗').margin(10).onClick((_) => {
        HMRouterMgr.push({ pageUrl: 'back_confirm_page' })
      })
      if (this.pageResultValue) {
        Text(this.pageResultValue).margin(15)
      }
    }
    .height('100%')
    .width('100%')
  }
}
