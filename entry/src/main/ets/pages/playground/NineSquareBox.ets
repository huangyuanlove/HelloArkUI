import image from '@ohos.multimedia.image'
import promptAction from '@ohos.promptAction'
import ActionBar from '../../comm/ActionBar'

@Component
@Entry
struct NineSquareBox {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  private canvasRendering2:CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  @State private canvasWidth: number = 0
  @State private canvasHeight: number = 0
  private dividerWidth: number = 10

  build() {
    Scroll(){
      Column() {
        ActionBar({ title: "九宫格" })

        Image($r("app.media.cat")).onAreaChange((oldValue, newValue) => {
          this.canvasWidth = parseInt(newValue.width.toString())
          this.canvasHeight = parseInt(newValue.height.toString())
          promptAction.showToast({message:"宽高-->" + this.canvasWidth +"  " + this.canvasHeight})
        }).objectFit(ImageFit.Contain).autoResize(false).fitOriginalSize(true)

        if(this.canvasWidth != 0 && this.canvasHeight!=0){
          //直接在原图片上绘制直线，会覆盖住一部分图片
          Canvas(this.canvasRendering) {}
          .onAreaChange((oldValue, newValue) => {
            this.canvasRendering.clearRect(0, 0, parseInt(oldValue.width.toString()), parseInt(oldValue.height.toString()))
            this.canvasWidth = parseInt(newValue.width.toString())
            this.canvasHeight = parseInt(newValue.height.toString())

            let imageBitMap: ImageBitmap = new ImageBitmap("pages/playground/cat.webp")

            this.canvasRendering.drawImage(imageBitMap, 0, 0)


            //均分为三段，
            let perWidth = this.canvasWidth / 3
            this.canvasRendering.lineWidth = this.dividerWidth
            this.canvasRendering.lineCap = "square"
            this.canvasRendering.strokeStyle = "#ffffffff"

            //第一条竖线
            this.canvasRendering.moveTo(perWidth - this.dividerWidth / 2, 0)
            this.canvasRendering.lineTo(perWidth - this.dividerWidth / 2, this.canvasHeight)
            //第二条竖线
            this.canvasRendering.moveTo(perWidth * 2 - this.dividerWidth / 2, 0)
            this.canvasRendering.lineTo(perWidth * 2 - this.dividerWidth / 2, this.canvasHeight)


            let perHeight = this.canvasHeight / 3
            //第一条横线
            this.canvasRendering.moveTo(0, perHeight - this.dividerWidth / 2)
            this.canvasRendering.lineTo(this.canvasWidth, perHeight - this.dividerWidth / 2)
            //第二条横线
            this.canvasRendering.moveTo(0, perHeight * 2 - this.dividerWidth / 2)
            this.canvasRendering.lineTo(this.canvasWidth, perHeight * 2 - this.dividerWidth / 2)


            this.canvasRendering.stroke()


          }).width(this.canvasWidth).height(this.canvasHeight)
        }
        if(this.canvasWidth!=0 && this.canvasHeight!=0){
          //将原图切分为9块，然后放在对应的位置
          Canvas(this.canvasRendering2)
            .onAreaChange((oldValue,newValue)=>{
              let imageBitMap: ImageBitmap = new ImageBitmap("pages/playground/cat.webp")
              this.canvasRendering2.drawImage(imageBitMap, 0, 0)
              //计算每一块的宽高
              let perWidth = this.canvasWidth / 3
              let perHeight = this.canvasHeight/3

              let imageData1 = this.canvasRendering2.getImageData(0,0,perWidth,perHeight)
              let imageData2 = this.canvasRendering2.getImageData(perWidth,0,perWidth,perHeight)
              let imageData3 = this.canvasRendering2.getImageData(perWidth*2,0,perWidth,perHeight)

              let imageData4 = this.canvasRendering2.getImageData(0,perHeight,perWidth,perHeight)
              let imageData5 = this.canvasRendering2.getImageData(perWidth,perHeight,perWidth,perHeight)
              let imageData6 = this.canvasRendering2.getImageData(perWidth*2,perHeight,perWidth,perHeight)

              let imageData7 = this.canvasRendering2.getImageData(0,perHeight*2,perWidth,perHeight)
              let imageData8 = this.canvasRendering2.getImageData(perWidth,perHeight*2,perWidth,perHeight)
              let imageData9 = this.canvasRendering2.getImageData(perWidth*2,perHeight*2,perWidth,perHeight)


              this.canvasRendering2.clearRect(0,0,this.canvasWidth+this.dividerWidth*2,this.canvasHeight+this.dividerWidth*2)

              this.canvasRendering2.putImageData(imageData1,0,0)
              this.canvasRendering2.putImageData(imageData2,perWidth+this.dividerWidth,0)
              this.canvasRendering2.putImageData(imageData3,(perWidth+this.dividerWidth)*2,0)

              this.canvasRendering2.putImageData(imageData4,0,perHeight+this.dividerWidth)
              this.canvasRendering2.putImageData(imageData5,perWidth+this.dividerWidth,perHeight+this.dividerWidth)
              this.canvasRendering2.putImageData(imageData6,(perWidth+this.dividerWidth)*2,perHeight+this.dividerWidth)

              this.canvasRendering2.putImageData(imageData7,0, (perHeight+this.dividerWidth)*2 )
              this.canvasRendering2.putImageData(imageData8,perWidth+this.dividerWidth,(perHeight+this.dividerWidth)*2)
              this.canvasRendering2.putImageData(imageData9,(perWidth+this.dividerWidth)*2,(perHeight+this.dividerWidth)*2)



            })
            .width(this.canvasWidth+this.dividerWidth*2).height(this.canvasHeight+this.dividerWidth*2)
        }



      }.justifyContent(FlexAlign.Start).width("100%").height("100%")
    }


  }
}