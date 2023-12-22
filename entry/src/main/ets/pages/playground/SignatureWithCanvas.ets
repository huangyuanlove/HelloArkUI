// 特别粗糙，可以参考这个：https://developer.huawei.com/consumer/cn/forum/topic/0201104583144305349?fid=0101587866109860105
import ActionBar from '../../comm/ActionBar'
import picker from '@ohos.file.picker';
import image from '@ohos.multimedia.image';
import mediaLibrary from '@ohos.multimedia.mediaLibrary';
import fs from '@ohos.file.fs';
import { saveImage } from '../../util/FileUtils';

@Entry
@Component
struct SignatureWithCanvas {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private path2Db: Path2D = new Path2D()
  private canvasWidth: number
  private canvasHeight: number
  private prePointX: number = 0;
  private prePointY: number = 0;
  private lineType: number = 0

  private cleanCanvas(): void {
    this.canvasRendering.clearRect(0, 0, this.canvasWidth, this.canvasHeight)
    this.path2Db = new Path2D()
  }

  @Builder
  buildOperation() {
    Row() {
      Row() {
        Radio({ value: "直线", group: "line_type" }).checked(true).onChange((checked: boolean) => {
          if (checked) {
            this.lineType = 0;
          }
        })
        Text("直线")
      }.layoutWeight(1)

      Row() {
        Radio({ value: "二次贝赛尔曲线", group: "line_type" }).checked(false).onChange((checked: boolean) => {
          if (checked) {
            this.lineType = 1;
          }
        })
        Text("二次贝赛尔曲线")
      }.layoutWeight(1)

      Row() {
        Radio({ value: "三次贝赛尔曲线", group: "line_type" }).checked(false).onChange((checked: boolean) => {
          if (checked) {
            this.lineType = 2;
          }
        })
        Text("三次贝赛尔曲线")
      }.layoutWeight(1)

    }
  }

  build() {
    Column() {
      ActionBar({ title: "手写签名" })
      this.buildOperation()
      Canvas(this.canvasRendering)
        .width('100%')
        .layoutWeight(1)
        .onAreaChange((oldValue, newValue) => {
          this.canvasWidth = parseInt(newValue.width.toString())
          this.canvasHeight = parseInt(newValue.height.toString())
        })
        .onReady(() => {
          this.canvasRendering.lineCap = "round"
          this.canvasRendering.lineWidth = 6
          this.canvasRendering.fillStyle = "#111111"

        })
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Down) {
            this.canvasRendering.beginPath()
            this.path2Db.moveTo(event.touches[0].x, event.touches[0].y)
            this.prePointX = event.touches[0].x
            this.prePointY = event.touches[0].y
          }
          if (event.type === TouchType.Up) {

          }
          if (event.type === TouchType.Move) {
            let targetX: number = event.touches[0].x
            let targetY: number = event.touches[0].y

            if (this.lineType == 0) {
              this.path2Db.lineTo(targetX, targetY)
            } else if (this.lineType == 1) {
              let tmpX = (targetX + this.prePointX) / 2
              let tmpY = (targetY + this.prePointY) / 2
              this.path2Db.quadraticCurveTo(tmpX, tmpY, targetX, targetY)
            } else {

              let vx = targetX - this.prePointX
              let vy = targetY - this.prePointY

              let d = Math.sqrt(vx * vx + vy * vy) / 3

              let mx = (targetX + this.prePointX) / 2
              let my = (targetY + this.prePointY) / 2

              let tmpX1 = mx + d / 3 * (vx / d)
              let tmpY1 = my + d / 3 * (vy / d)

              let tmpX2 = mx - d / 3 * (vx / d)
              let tmpY2 = my - d / 3 * (vy / d)

              this.path2Db.bezierCurveTo(tmpX1, tmpY1, tmpX2, tmpY2, targetX, targetY)

            }

            this.prePointX = targetX
            this.prePointY = targetY
            this.canvasRendering.stroke(this.path2Db)

          }
        })
      Row() {
        Button("清除").onClick(() => {
          this.cleanCanvas()
        })
        Blank().width(100)
        Button("保存").onClick(() => {
          let pixelMap: PixelMap = this.canvasRendering.getPixelMap(0, 0, this.canvasWidth, this.canvasHeight)
          saveImage(pixelMap)



        })
      }
    }
  }
}


async function encode(component: Object, pixelMap: PixelMap) {
  const newPixelMap = pixelMap;
  // Packing image.
  const imagePackerApi = image.createImagePacker();
  const packOptions: image.PackingOption = {
    format: "image/jpeg",
    quality: 100
  }
  const imageData = await imagePackerApi.packing(newPixelMap, packOptions);
  console.error(`imageData's length is ${imageData.byteLength}`);
  // Get album's path.
  const context = getContext(component);
  const media = mediaLibrary.getMediaLibrary(context);
  const publicPath = await media.getPublicDirectory(mediaLibrary.DirectoryType.DIR_IMAGE);
  const currentTime = new Date().getTime();
  // Create image asset.
  const imageAssetInfo = await media.createAsset(
    mediaLibrary.MediaType.IMAGE,
    `image_${currentTime}.jpg`,
    publicPath
  );
  const imageFd = await imageAssetInfo.open("rw");
  await fs.write(imageFd, imageData);
  // Image resource release.
  await imageAssetInfo.close(imageFd);
  imagePackerApi.release();
  await media.release();
}