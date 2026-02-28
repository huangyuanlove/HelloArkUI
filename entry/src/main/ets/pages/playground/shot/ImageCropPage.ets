import { ActionBar } from '../../../comm/ActionBar';
import image from '@ohos.multimedia.image';
import { JSON } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct ImageCropPage {
  @State message: string = 'Hello World';
@State pixmap?:image.PixelMap = undefined
  @State showCropImage:boolean = false

  aboutToAppear(): void {
    // 1. 获取ResourceManager
    const resManager = this.getUIContext().getHostContext()?.resourceManager;

    // 2. 获取DrawableDescriptor并转换为PixelMap
    const drawableDesc = resManager?.getDrawableDescriptor($r('app.media.screen').id);
    let tmp = drawableDesc?.getPixelMap();
    let imageInfo =  tmp?.getImageInfoSync()

    if(tmp && imageInfo){
      let arrayBuffer = new ArrayBuffer(tmp?.getPixelBytesNumber())
      tmp.readPixelsToBufferSync(arrayBuffer)

      let initializationOptions:image.InitializationOptions = {
        size: imageInfo.size,
        editable:true,
        pixelFormat:imageInfo.pixelFormat,
      }

      image.createPixelMap(arrayBuffer,initializationOptions).then((result)=>{
        console.error(`创建图片成功`)
        this.pixmap = result
      }).catch((error:BusinessError)=>{
        console.error(`创建图片失败 ${error}`)
      })
    }
  }

  build() {
    Column() {
      Row(){
        ActionBar({title:'图片裁剪'}).layoutWeight(1)
        Button('裁剪').onClick((_)=>{
          let cropRegion:image.Region = {
            size: {
              height:1000,
              width:1000
            },
            x: 100,
            y: 100
          }

          this.pixmap?.crop(cropRegion).then((_) => {
            console.error("裁剪成功")
            this.showCropImage = !this.showCropImage

          }).catch( (err:BusinessError) => {
            console.error(`裁剪失败 ${err}`)
          })
        })
        Button('复制').onClick((_)=>{
          let cropRegion:image.Region = {
            size: {
              height:1000,
              width:1000
            },
            x: 100,
            y: 100
          }

          if(this.pixmap){
            const area: image.PositionArea = {
              pixels: new ArrayBuffer(this.pixmap.getPixelBytesNumber()),
              offset: 0,
              stride: this.pixmap.getBytesNumberPerRow(),
              region: cropRegion
            };
            this.pixmap.readPixelsSync(area);
            const opts: image.InitializationOptions = {
              editable: true,
              // readPixelsSync使用的是BGRA_8888,转换时设置RGBA_8888
              pixelFormat: image.PixelMapFormat.RGBA_8888,
              size: { height: 1000, width: 1000 }
            };
            let snapshot = image.createPixelMapSync(opts);
            const snapshotArea: image.PositionArea = {
              pixels: area.pixels,
              offset: 0,
              stride: area.stride,
              region: {
                size: {
                  width: 1000,
                  height: 1000,
                },
                x: 0,
                y: 0
              }
            };
            snapshot.writePixelsSync(snapshotArea);
            this.pixmap = snapshot
            this.showCropImage = !this.showCropImage
          }

        })
      }.width('100%')
      if(this.showCropImage){
        Image(this.pixmap).objectFit(ImageFit.Contain).backgroundColor(Color.Pink).borderWidth(1).borderColor(Color.Red)
      }else{
        Image(this.pixmap).width('100%').objectFit(ImageFit.Contain).backgroundColor(Color.Orange).borderWidth(1).borderColor(Color.Red)
      }
    }
    .height('100%')
    .width('100%')
  }
}