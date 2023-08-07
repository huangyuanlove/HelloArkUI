import { IndexItem } from './Index'

@Entry
@Component
struct AboutStateManagement {
  build() {
    Column() {
      IndexItem({ label: '@State装饰器：组件内状态', path: 'pages/state_manager/AboutStateAnno' })
      IndexItem({ label: '@Prop装饰器：父子单向同步', path:  'pages/state_manager/AboutPropAnno'})
      IndexItem({ label: '@Link装饰器：父子双向同步', path:  'pages/state_manager/AboutLinkAnno'})
    }
  }
}