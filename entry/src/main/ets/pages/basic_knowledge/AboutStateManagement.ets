
import ActionBar from '../../comm/ActionBar'
import { BaseListItem } from '../../comm/BaseListItem'
@Entry
@Component
struct AboutStateManagement {
  build() {
    Scroll() {
      Column() {
        ActionBar({ title: '组件状态管理' })
        BaseListItem({ label: '@State：组件内状态', path: 'pages/basic_knowledge/state_manager/AboutStateAnno' })
        BaseListItem({ label: '@Prop：父子单向同步', path: 'pages/basic_knowledge/state_manager/AboutPropAnno' })
        BaseListItem({ label: '@Link：父子双向同步', path: 'pages/basic_knowledge/state_manager/AboutLinkAnno' })
        BaseListItem({
          label: '@Provide 和 @Consume：与后代组件双向同步',
          path: 'pages/basic_knowledge/state_manager/AboutProvideAndConsumeAnno'
        })
        BaseListItem({
          label: '@Observed 和 @ObjectLink：嵌套类对象属性变化',
          path: 'pages/basic_knowledge/state_manager/AboutObservedAndObjectLinkAnno'
        })
        BaseListItem({
          label: 'LocalStorage：页面级UI状态存储',
          path: 'pages/basic_knowledge/state_manager/AboutLocalStorage'
        })
        BaseListItem({
          label: 'AppStorage：应用全局的UI状态存储',
          path: 'pages/basic_knowledge/state_manager/AboutAppStorage'
        })
        BaseListItem({
          label: 'PersistentStorage：持久化存储UI状态',
          path: 'pages/basic_knowledge/state_manager/AboutPersistentStorage'
        })
        BaseListItem({
          label: 'Environment：设备环境查询',
          path: 'pages/basic_knowledge/state_manager/AboutEnvironment'
        })
        BaseListItem({
          label: '@Watch装饰器：状态变量更改通知',
          path: 'pages/basic_knowledge/state_manager/AboutWatchAnno'
        })
        BaseListItem({
          label: '$$语法：内置组件双向同步',
          path: 'pages/basic_knowledge/state_manager/AboutDoubleDollar'
        })
      }
    }
    .scrollable(ScrollDirection.Vertical)  // 滚动方向纵向
    .scrollBar(BarState.On)  // 滚动条常驻显示
    .scrollBarColor(Color.Gray)  // 滚动条颜色
    .scrollBarWidth(10) // 滚动条宽度
    .edgeEffect(EdgeEffect.None)
  }
}