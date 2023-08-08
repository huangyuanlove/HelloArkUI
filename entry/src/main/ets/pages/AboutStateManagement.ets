import { IndexItem } from './Index'

@Entry
@Component
struct AboutStateManagement {
  build() {
    Scroll() {
      Column() {
        IndexItem({ label: '@State：组件内状态', path: 'pages/state_manager/AboutStateAnno' })
        IndexItem({ label: '@Prop：父子单向同步', path: 'pages/state_manager/AboutPropAnno' })
        IndexItem({ label: '@Link：父子双向同步', path: 'pages/state_manager/AboutLinkAnno' })
        IndexItem({
          label: '@Provide 和 @Consume：与后代组件双向同步',
          path: 'pages/state_manager/AboutProvideAndConsumeAnno'
        })
        IndexItem({
          label: '@Observed 和 @ObjectLink：嵌套类对象属性变化',
          path: 'pages/state_manager/AboutObservedAndObjectLinkAnno'
        })
        IndexItem({
          label: 'LocalStorage：页面级UI状态存储',
          path: 'pages/state_manager/AboutLocalStorage'
        })
        IndexItem({
          label: 'AppStorage：应用全局的UI状态存储',
          path: 'pages/state_manager/AboutAppStorage'
        })
        IndexItem({
          label: 'PersistentStorage：持久化存储UI状态',
          path: 'pages/state_manager/AboutPersistentStorage'
        })
        IndexItem({
          label: 'Environment：设备环境查询',
          path: 'pages/state_manager/AboutEnvironment'
        })
        IndexItem({
          label: '@Watch装饰器：状态变量更改通知',
          path: 'pages/state_manager/AboutWatchAnno'
        })
        IndexItem({
          label: '$$语法：内置组件双向同步',
          path: 'pages/state_manager/AboutDoubleDollar'
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