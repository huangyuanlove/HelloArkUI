
// 特别粗糙，可以参考这个：https://developer.huawei.com/consumer/cn/forum/topic/0201104583144305349?fid=0101587866109860105
import ActionBar from '../../comm/ActionBar'
@Entry
@Component
struct SignatureWithCanvas{

  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private path2Db: Path2D = new Path2D()

  private canvasWidth:number
  private canvasHeight:number

  @Builder
  buildOperation(){
    Row(){
      Radio({value:"",group:""}).checked(true)
    }.width("100%")
  }

  build(){
    Column(){
      ActionBar({title:"手写签名"})
      Canvas(this.context).width('100%')
      .layoutWeight(1)
      .onAreaChange( (oldValue,newValue)=>{
        this.canvasWidth = parseInt(newValue.width.toString())
        this.canvasHeight = parseInt(newValue.height.toString())
      })
      .onReady(()=>{
        this.context.lineCap = "round"
        this.context.lineWidth = 6
      })
      .onTouch((event:TouchEvent)=>{
        if (event.type === TouchType.Down) {
          this.context.beginPath()
          this.path2Db.moveTo(event.touches[0].x, event.touches[0].y)
        }
        if (event.type === TouchType.Up) {

        }
        if (event.type === TouchType.Move) {
          this.path2Db.lineTo(event.touches[0].x, event.touches[0].y)
          this.context.stroke(this.path2Db)

        }
      })
      Row(){
        Button("清除").onClick(()=>{
          this.context.clearRect(0,0,this.canvasWidth,this.canvasHeight)
          this.path2Db = new Path2D()
          this.context.beginPath()
        })
        Blank().width(100)
        Button("保存").onClick(()=>{

        })
      }
    }
  }
}