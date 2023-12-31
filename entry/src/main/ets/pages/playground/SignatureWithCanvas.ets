// 特别粗糙，可以参考这个：https://developer.huawei.com/consumer/cn/forum/topic/0201104583144305349?fid=0101587866109860105
import ActionBar from '../../comm/ActionBar'
import picker from '@ohos.file.picker';
import image from '@ohos.multimedia.image';
import mediaLibrary from '@ohos.multimedia.mediaLibrary';
import fs from '@ohos.file.fs';
import fileIo from '@ohos.file.fs';
import { saveImageDataUrl } from '../../util/FileUtils';
import util from '@ohos.util';
import buffer from '@ohos.buffer';
import promptAction from '@ohos.promptAction';
import { ShowDialogSuccessResponse } from '@system.prompt';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import common from '@ohos.app.ability.common';

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

  reqPermissionsFromUser(permissions: Array<Permissions>): void {
    let context = getContext(this) as common.UIAbilityContext;
    let atManager = abilityAccessCtrl.createAtManager();
    // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
    atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      let grantStatus: Array<number> = data.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i++) {
        if (grantStatus[i] === 0) {
          // 用户授权，可以继续访问目标操作
        } else {
          // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
          return;
        }
      }
      // 授权成功
    }).catch((err) => {
      console.error(`requestPermissionsFromUser failed, code is ${err.code}, message is ${err.message}`);
    })
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
          this.canvasRendering.strokeStyle = "#111111"

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
        Blank().width(10)
        Button("申请权限").onClick(() => {
          this.reqPermissionsFromUser(['ohos.permission.WRITE_MEDIA'])
        })
        Blank().width(10)
        Button("保存").onClick(() => {

          let data = this.canvasRendering.toDataURL()
          saveImageDataUrl(data.split(',')[1])


          // let pixelMap = this.canvasRendering.getPixelMap(0,0,this.canvasWidth,this.canvasHeight)
          //
          // const readBuffer = new ArrayBuffer(pixelMap.getPixelBytesNumber());  //96为需要创建的像素buffer大小，取值为：height * width *4
          //
          // pixelMap.readPixelsToBuffer(readBuffer, (err, res) => {
          //
          //   if(err) {
          //
          //     console.log('Failed to read image pixel data.');  //不符合条件则进入
          //
          //   } else {
          //
          //     try {
          //       let photoSaveOptions = new picker.PhotoSaveOptions();
          //       //保存图片默认名称
          //       const currentTime = new Date().getTime();
          //       photoSaveOptions.newFileNames = [`image_${currentTime}.png`]; // 保存文件名（可选）
          //       let photoPicker = new picker.PhotoViewPicker();
          //       //调起系统的图片保存功能
          //       photoPicker.save(photoSaveOptions).then((PhotoSaveResult) => {
          //        this.saveImageUri = PhotoSaveResult[0];
          //
          //         promptAction.showDialog({
          //           title:"确认保存图片",
          //           buttons:[
          //             {
          //               text: '确认',
          //               color: '#000000',
          //             },
          //             {
          //               text: '取消',
          //               color: '#000000',
          //             }
          //           ]
          //
          //         }).then((result:ShowDialogSuccessResponse)=>{
          //           if(result.index == 0){
          //             promptAction.showToast({message:"正在保存"})
          //             //打开文件
          //             let file = fs.openSync(this.saveImageUri, fs.OpenMode.READ_WRITE);
          //
          //             //写入文件
          //             fs.writeSync(file.fd, readBuffer);
          //             //关闭文件
          //             fs.closeSync(file);
          //             promptAction.showToast({message:"保存完成"})
          //           }else{
          //             promptAction.showToast({message:"取消保存"})
          //           }
          //         })
          //
          //       }).catch((err: Error) => {
          //         console.error(err + '');
          //       })
          //     } catch (e) {
          //       console.error(e);
          //     }
          //
          //
          //
          //
          //   }
          //
          // })
        })
      }
    }
  }

}
