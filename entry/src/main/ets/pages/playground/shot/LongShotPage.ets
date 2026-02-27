import { HMRouter } from '@hadss/hmrouter';
import { ActionBar } from '../../../comm/ActionBar';
import { image } from '@kit.ImageKit';
import { DialogAction, DialogHelper } from '@pura/harmony-dialog';
import { BusinessError } from '@kit.BasicServicesKit';


const list_id = 'list_id'

@HMRouter({ pageUrl: "playground/shot/LongShotPage" })
@Entry
@ComponentV2
export struct LongShotPage {
  data: number[] =
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
  imageResource: Resource[] =
    [$r('app.media.product00'), $r('app.media.product01'), $r('app.media.product02'), $r('app.media.product03'),
      $r('app.media.product04')]
  private scroller: Scroller = new Scroller()
  private listHeight: number = 0
  private listWidth: number = 0
  private pixmapArray: image.PixelMap[] = []
  private currentScrollOffset: number = 0

  private lastOffset:number = 0
  private lastScrollHeight:number = 0


  @Local lastPixmap?:image.PixelMap

  @LocalBuilder
  previewLastPic(){
    Scroll(){
      Image(this.lastPixmap).width('100%')
    }

  }

  @LocalBuilder
  previewScreenShot() {
    Scroll() {
      Column() {
        ForEach(this.pixmapArray, (item: image.PixelMap, index: number) => {
          Image(item).width('100%')
        })
      }
    }.constraintSize({ maxHeight: 300 })

  }

  build() {
    Column() {
      ActionBar({ title: "长截图" })
      List({ space: 20, scroller: this.scroller }) {
        ForEach(this.data, (item: number, index: number) => {
          ListItem() {
            Row() {
              Image(this.imageResource[index % this.imageResource.length])
                .width(40)
                .height(40)
                .objectFit(ImageFit.Contain)
              Column() {
                Text('这是标题 ' + index).fontSize(18).fontColor("#333333")
                Text('这是长描述长描述长描述长描述').fontSize(14).fontColor("#666666")
              }.padding({ left: 8 }).layoutWeight(1).alignItems(HorizontalAlign.Start)
            }.width('100%').padding({ top: 10, bottom: 10 }).backgroundColor(Color.White).borderRadius(8)
          }.width('100%').padding({ left: 15, right: 15 })
        })
      }
      .width('100%')
      .layoutWeight(1)
      .edgeEffect(EdgeEffect.Fade)
      .id(list_id)
      .onAreaChange((oldValue, newValue) => {
        this.listHeight = newValue.height as number;
        this.listWidth = newValue.width as number;
      })
      .scrollBar(BarState.Off)


      Row() {
        Button('一键截图')
        Button('滚动截图')
          .onClick(async (_) => {
            let scrollCount: number = 0
            this.pixmapArray = []
            let pixmap = await this.getUIContext().getComponentSnapshot().get(list_id)
            this.pixmapArray.push(pixmap)
            while (!this.scroller.isAtEnd()) {
              scrollCount++
              this.scroller.scrollTo({
                xOffset: 0,
                yOffset: this.currentScrollOffset + this.listHeight
              })
              await sleep(200)
              this.currentScrollOffset += this.listHeight

              let pixmap = await this.getUIContext().getComponentSnapshot().get(list_id)
              this.pixmapArray.push(pixmap)

              this.lastScrollHeight = this.scroller.currentOffset().yOffset - this.lastOffset
              this.lastOffset = this.scroller.currentOffset().yOffset



            }
            let diff = this.currentScrollOffset - this.scroller.currentOffset().yOffset

            console.error(`滑动了 ${scrollCount} 次, 当前偏移量计算值  ${this.currentScrollOffset},  当前偏移量实际值 :${this.scroller.currentOffset()
              .yOffset}`)
            console.error(`最后一次滑动了 ${this.lastScrollHeight} ,计算偏差为 ${diff}`)

            DialogHelper.showCustomContentDialog({
              title: '预览',
              contentBuilder: () => {
                this.previewScreenShot()
              },
              maxHeight: "60%",
              onAction:async (action, dialogID) => {

                if(action == DialogAction.CANCEL){
                  let tmpPixMap = this.pixmapArray[this.pixmapArray.length -1]

                  let diff =this.listHeight -( this.currentScrollOffset - this.scroller.currentOffset().yOffset)
                  let cropRegion: image.Region = {
                    x: 0,
                    y: this.currentScrollOffset - this.scroller.currentOffset().yOffset,
                    size: {
                      height:  diff,
                      width: this.listWidth
                    }
                  };
                 await tmpPixMap.crop(cropRegion)
                  this.lastPixmap = tmpPixMap
                  DialogHelper.showCustomContentDialog({
                    title:"最后一张图片",
                    contentBuilder:()=>{
                      this.previewLastPic()
                    },
                    onAction:(action,dialogid)=>{

                    }
                  })

                }

                if (action == DialogAction.SURE) {
                  //最后一张图片需要裁掉的高度
                  let diff = this.currentScrollOffset - this.scroller.currentOffset().yOffset

                  let longPixelMap = image.createPixelMapSync({
                    editable: true,
                    pixelFormat: image.PixelMapFormat.BGRA_8888,
                    size: {
                      // You need to ensure that the width of the PixelMap is greater than the width of the area
                      width: this.listWidth,
                      height: this.scroller.currentOffset().yOffset
                    }
                  });


                  let imgPosition: number = 0;
                  for (let i = 0; i < this.pixmapArray.length ; i++) {
                    let pixelMap = this.pixmapArray[i]
                    let stride = pixelMap.getBytesNumberPerRow();
                    let bytesNumber = pixelMap.getPixelBytesNumber();
                    let buffer: ArrayBuffer = new ArrayBuffer(bytesNumber);

                    if(i == this.pixmapArray.length -1){
                      //最后一张图，判断一下是否需要裁剪
                      if(diff > 0){
                        let cropRegion: image.Region = {
                          x: 0,
                          y: diff,
                          size: {
                            height: this.listHeight - diff,
                            width: this.listWidth
                          }
                        };
                        // Crop roll area
                        await pixelMap.crop(cropRegion);
                      }
                    }


                    let imgInfo = pixelMap.getImageInfoSync();
                    let area: image.PositionArea = {
                      pixels: buffer,
                      offset: 0,
                      stride: stride,
                      region: {
                        size: {
                          width: imgInfo.size.width,
                          height: imgInfo.size.height
                        },
                        x: 0,
                        y: imgPosition
                      }
                    }
                    // Write data to a specified area
                    pixelMap.readPixelsSync(area);
                    imgPosition += area.region.size.height;
                    try {
                      longPixelMap.writePixelsSync(area);
                    } catch (err) {
                      let error = err as BusinessError<void>;
                      console.error(`writePixelsSync err, code: ${error.code}, message: ${error.message}`);
                    }
                  }


                }
              }
            })


          })
        Button('截图水印')
      }.width('100%').justifyContent(FlexAlign.SpaceEvenly)
    }.height('100%')
    .width('100%')
    .backgroundColor("#f7f7f7")
  }
}

function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}