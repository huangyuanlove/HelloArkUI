import ActionBar from '../../comm/ActionBar'
import { WaveView } from './WaveView'
@Entry
@Component
struct WaveLinePage {
  build() {
    Column() {
      ActionBar({title:"波浪效果"})
      WaveView().width("100%").height("50%")

    }
  }
}