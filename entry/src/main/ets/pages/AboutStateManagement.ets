import { IndexItem } from './Index'
@Entry
@Component
struct AboutStateManagement {
  build() {
    Column() {
      IndexItem({ label: '@State装饰器：组件内状态', path: 'pages/state_menager/AboutStateAnno' })
    }
  }
}