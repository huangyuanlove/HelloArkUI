import { IndexItem } from './Index'
@Entry
@Component
struct AboutStateManagement {
  build() {
    Column() {
      IndexItem({ label: '@State：组件内状态', path: 'pages/state_manager/AboutStateAnno' })
      IndexItem({ label: '@Link：父子双向同步', path: 'pages/state_manager/AboutLinkAnno' })
      IndexItem({ label: '@Provide 和 @Consume：与后代组件双向同步', path: 'pages/state_manager/AboutProvideAndConsumeAnno' })
      IndexItem({ label: '@Observed 和 @ObjectLink：嵌套类对象属性变化', path: 'pages/state_manager/AboutObservedAndObjectLinkAnno' })
    }
  }
}