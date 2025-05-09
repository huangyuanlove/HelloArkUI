
import hilog from '@ohos.hilog';
import json from '@ohos.util.json';
import { ActionBar } from '../../comm/ActionBar';

@Entry
@ComponentV2
struct GestureImagePage {


  @Local imageScale:number = 1
  @Local imageScaleCenterX:number | string = '50%'
  @Local imageScaleCenterY:number  | string ='50%'
  @Local preImageScale:number =1

  @Local imageOffsetX:number = 0
  @Local imageOffsetY:number = 0
  @Local imagePreOffsetX:number =0
  @Local imagePreOffsetY:number = 0

  @Local imageWidth :number =0
  @Local imageHeight:number = 0



  resetImage(){
    this.imageScale =1
    this.imageScaleCenterX = '50%'
    this.imageScaleCenterY = '50%'
    this.preImageScale = this.imageScale
    this.imageOffsetX = 0
    this.imageOffsetY =0
    this.imagePreOffsetX = 0
    this.imagePreOffsetY =0
  }

  build() {
    Column() {
      ActionBar({title:"图片预览"})
      Column(){
        Image("https://resourced.chunyu.mobi/-fQAAAAk1QL92SkY-9ab874af-889c-4f21-a4dc-13801f303865_w1200_h799_.jpeg")
        // Image("https://pic.quanjing.com/lj/a0/QJ9130478514.jpg@%21537hs")
          .draggable(false)
          .enableAnalyzer(false)

          .objectFit(ImageFit.Auto)
          .translate({x:this.imageOffsetX,y:this.imageOffsetY})
          .scale({x:this.imageScale,y:this.imageScale,centerX:this.imageScaleCenterX,centerY:this.imageScaleCenterY})
          .onComplete((event)=>{
            if(event && event.loadingStatus == 1){
              hilog.error(0x01,'GestureImagePage',`onComplete ${json.stringify(event)}`)
            }
          })
          .gesture(
            TapGesture({count:2}).onAction((event)=>{
              if(this.imageScale != 5){
                this.imageScale = 5
                this.preImageScale = this.imageScale
              }else{
                this.imageScale = 1
                this.resetImage()
              }

            })
          )
          .gesture(
            TapGesture({count:1}).onAction((event)=>{
              this.imageScale =1
              this.resetImage()
            })
          )
          .gesture(
            PinchGesture()
              .onActionStart((event)=>{
                this.preImageScale = this.imageScale
              })
              .onActionUpdate((event)=>{
                this.imageScaleCenterX = event.pinchCenterX
                this.imageScaleCenterY = event.pinchCenterY
                this.imageScale = this.preImageScale * event.scale
              })
              .onActionEnd((event)=>{
                if(this.imageScale < 1){
                  this.imageScale = 1
                  this.resetImage()
                }else{
                this.preImageScale = this.imageScale
                }

              })
          )
          .gesture(
            PanGesture()
              .onActionStart((event)=>{
                this.imagePreOffsetX =  this.imageOffsetX
                this.imagePreOffsetY = this.imageOffsetY
              })
              .onActionUpdate((event)=>{
                this.imageOffsetX = (this.imagePreOffsetX + (event.offsetX*this.imageScale))
                this.imageOffsetY = (this.imagePreOffsetY + (event.offsetY*this.imageScale))


              })
              .onActionEnd((event)=>{

              })
          )


      }.layoutWeight(1).width('100%').justifyContent(FlexAlign.Center)


    }
    .height('100%')
    .width('100%')
  }
}