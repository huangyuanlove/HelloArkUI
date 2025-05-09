import { ActionBar } from '../../comm/ActionBar';
import { WaveView } from './WaveView'
@Entry
@Component
struct WaveLinePage {

  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  build() {
    Column() {
      ActionBar({title:"波浪效果"})
      WaveView().width("100%").height("50%")
      Canvas(this.canvasRendering).width("100%").height("30%")
        .onAreaChange((oldValue,newValue)=>{
          this.canvasRendering.fillStyle = "#39d167"

          this.canvasRendering.strokeStyle = "#39d167"
          this.canvasRendering.lineWidth = 10
          let canvasWidth = parseInt(newValue.width.toString())
          let canvasHeight = parseInt(newValue.height.toString())

          let waveWidth = canvasWidth/2
          let waveHeight = 100
          let baseHeight =canvasHeight

          let path:Path2D = new Path2D()

          path.moveTo(0,baseHeight)
          path.quadraticCurveTo( waveWidth/2,baseHeight-waveHeight ,waveWidth,baseHeight)
          path.quadraticCurveTo(waveWidth+waveWidth/2,  baseHeight-waveHeight ,canvasWidth,baseHeight)
          this.canvasRendering.stroke(path)


          path = new Path2D()
          baseHeight /=3
          path.moveTo(0,baseHeight)
          path.quadraticCurveTo( waveWidth/2,baseHeight-waveHeight ,waveWidth,baseHeight)
          path.quadraticCurveTo(waveWidth+waveWidth/2,  baseHeight+waveHeight ,canvasWidth,baseHeight)
          this.canvasRendering.strokeStyle = "#1b91e0"
          this.canvasRendering.stroke(path)

        })

    }
  }
}