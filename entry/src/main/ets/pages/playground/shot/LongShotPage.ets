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
  private scrollOffsetArray: number [] = []
  @Local lastPixmap?: image.PixelMap

  @LocalBuilder
  previewLastPic() {
    Scroll() {
      Image(this.lastPixmap).width('100%').borderColor(Color.Red).borderWidth(1).objectFit(ImageFit.Contain).backgroundColor(Color.Yellow)
    }.constraintSize({ maxHeight: 300 }).borderColor(Color.Yellow).borderWidth(1)

  }

  @LocalBuilder
  previewScreenShot() {
    Scroll() {
      Column() {
        ForEach(this.pixmapArray, (item: image.PixelMap, index: number) => {
          Image(item).fitOriginalSize(true).width('100%')
        })
      }
    }.constraintSize({ maxHeight: 300 })

  }

  private async snapShort() {
    let pixmap = await this.getUIContext().getComponentSnapshot().get(list_id,{waitUntilRenderFinished:true})
    this.pixmapArray.push(pixmap)
    this.scrollOffsetArray.push(this.scroller.currentOffset().yOffset)
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
            this.pixmapArray = []
            await this.snapShort()
            while (!this.scroller.isAtEnd()) {
              this.scroller.scrollTo({
                xOffset: 0,
                yOffset: this.scroller.currentOffset().yOffset + this.listHeight
              })
              await sleep(200)
              await this.snapShort()
            }

            for (let i = 0; i < this.scrollOffsetArray.length - 1; i++) {

              let diff = this.scrollOffsetArray[i+1] - this.scrollOffsetArray[i]
              console.error(`第${i + 1}次滚动了 ${this.getUIContext().vp2px(diff)}`)

            }
            for (let i = 0; i < this.pixmapArray.length; i++) {
              let imageInfo: image.ImageInfo = this.pixmapArray[i].getImageInfoSync()
              console.error(`第${i + 1}次截图高度 ${imageInfo.size.height}`)
            }


            DialogHelper.showCustomContentDialog({
              title: '预览',
              contentBuilder: () => {
                this.previewScreenShot()
              },
              maxHeight: "60%",
              onAction: async (action, dialogID) => {

                if (action == DialogAction.CANCEL) {
                  let tmpPixMap = this.pixmapArray[this.pixmapArray.length -1]

                  let imageInfo = tmpPixMap.getImageInfoSync()

                  let len = this.scrollOffsetArray.length
                  let lastScrollHeight = Math.ceil(this.getUIContext().vp2px(this.scrollOffsetArray[len-1] -  this.scrollOffsetArray[len-2]))
                  console.error(`最后一次滚动了  ${lastScrollHeight},截图高度 ${imageInfo.size.height}，isEditable ${tmpPixMap.isEditable}`)



                  let pixelMapBuffer = new ArrayBuffer(tmpPixMap.getPixelBytesNumber())
                  tmpPixMap.readPixelsToBuffer(pixelMapBuffer)

                let editablePixelMap = await  image.createPixelMap(pixelMapBuffer,{
                    editable:true,
                    pixelFormat:imageInfo.pixelFormat,
                    size:imageInfo.size
                  })



                  let cropRegion: image.Region = {
                    x: 0,
                    y: imageInfo.size.height - lastScrollHeight,
                    // y: 0,
                    size: {
                      height: lastScrollHeight,
                      width: imageInfo.size.width
                    }
                  };
                  //
                  // const area: image.PositionArea = {
                  //   pixels: new ArrayBuffer(tmpPixMap.getPixelBytesNumber()),
                  //   offset: 0,
                  //   stride: tmpPixMap.getBytesNumberPerRow(),
                  //   region: cropRegion
                  // };
                  // tmpPixMap.readPixelsSync(area);
                  //
                  // const opts: image.InitializationOptions = {
                  //   editable: true,
                  //   // readPixelsSync使用的是BGRA_8888,转换时设置RGBA_8888
                  //   pixelFormat: image.PixelMapFormat.RGBA_8888,
                  //   size: { height: lastScrollHeight, width: imageInfo.size.width }
                  // };
                  // let snapshot = image.createPixelMapSync(opts);
                  // const snapshotArea: image.PositionArea = {
                  //   pixels: area.pixels,
                  //   offset: 0,
                  //   stride: area.stride,
                  //   region: {
                  //     size: {
                  //       width: imageInfo.size.width,
                  //       height: lastScrollHeight
                  //     },
                  //     x: 0,
                  //     y: 0
                  //   }
                  // };
                  // snapshot.writePixelsSync(snapshotArea);

                try {
                  await editablePixelMap.crop(cropRegion)
                }catch (error) {
                  console.error(`裁剪错误  ${error} ${error.code}  ${error.message}`)
                }


                  this.lastPixmap = editablePixelMap
                  let cropedImageInfo = this.lastPixmap.getImageInfoSync()
                  console.error(`裁剪后的图片高度 ${cropedImageInfo.size.height}`)
                  DialogHelper.showCustomContentDialog({
                    title: "最后一张图片",
                    contentBuilder: () => {
                      this.previewLastPic()
                    },
                    onAction: (action, dialogid) => {

                    }
                  })

                }

                if (action == DialogAction.SURE) {
                  //最后一张图片需要裁掉的高度
                  let len = this.scrollOffsetArray.length
                  let diff =
                    Math.ceil(this.getUIContext().vp2px(this.scrollOffsetArray[len-2] - this.scrollOffsetArray[len-1]))

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
                  for (let i = 0; i < this.pixmapArray.length; i++) {
                    let pixelMap = this.pixmapArray[i]
                    let stride = pixelMap.getBytesNumberPerRow();
                    let bytesNumber = pixelMap.getPixelBytesNumber();
                    let buffer: ArrayBuffer = new ArrayBuffer(bytesNumber);

                    if (i == this.pixmapArray.length - 1) {
                      //最后一张图，判断一下是否需要裁剪
                      if (diff > 0) {
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