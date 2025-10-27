import { camera } from '@kit.CameraKit';
import { BusinessError, systemDateTime } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { display, promptAction } from '@kit.ArkUI';
import { DialogHelper } from '@pura/harmony-dialog/src/main/ets/dialog/DialogHelper';
import { image } from '@kit.ImageKit';
import { fileIo, fileUri } from '@kit.CoreFileKit';
import { ActionBar } from '../../../comm/ActionBar';


const TAG: string = 'TakePhotoPage'

const defaultWidth = 1920
const defaultHeight = 1080


@Entry
@Component
struct TakePhotoPage {
  private mXComponentController: XComponentController = new XComponentController;
  private cameraManager: camera.CameraManager = this.getCameraManager(getContext(this))
  private cameraList: Array<camera.CameraDevice> = []
  private surfaceId: string = ''
  private currentCamera: camera.CameraDevice | undefined = undefined
  @State supportPhotoProfileArray: camera.Profile[] = []
  @State supportPreviewProfileArray: camera.Profile[] = []
  @State currentPhotoProfile: camera.Profile | undefined = undefined
  @State currentWidth: number = defaultWidth
  @State currentHeight: number = defaultHeight
  @State supportFlashMode: number [] = []
  @State zoomRatioRangeStart: number = 1
  @State zoomRatioRangeEnd: number = 1
  private photoOutput: camera.PhotoOutput | undefined = undefined
  private photoSession: camera.PhotoSession | undefined = undefined

  aboutToAppear(): void {
    this.cameraList = this.getCameraDevices()
    //默认选择第一个相机
    if (this.cameraList.length) {
      this.currentCamera = this.cameraList[0]
    }
    this.onCameraStatusChange()

  }

  build() {
    Column() {
      ActionBar({ title: "TakePhotoPage" })
      Scroll() {
        Row() {
          Text(this.cameraList.length + ' 个可用相机').onClick((_) => {
            DialogHelper.showSelectDialog({
              radioContent: this.getAllCamerasPositionStr(this.cameraList),
              confirm: '确认',
              title: '选择相机',
              onCheckedChanged: (index) => {

              },
              onAction: (action, dialogId, value) => {
                promptAction.showToast({ message: `${action} --- ${value}` })
                if (value) {
                  this.currentCamera = this.cameraList[value]
                }
              }
            })
          }).margin(10).padding(10)
          Text(this.supportPhotoProfileArray.length + ' 个可选像素').onClick((_) => {
            DialogHelper.showSelectDialog({
              radioContent: this.getAllSupportSizeStr(this.supportPhotoProfileArray),
              confirm: '确认',
              title: '选择像素',
              onCheckedChanged: (index) => {

              },
              onAction: (action, dialogId, value) => {
                promptAction.showToast({ message: `${action} --- ${value}` })
                if (value) {
                  this.currentPhotoProfile = this.supportPhotoProfileArray[value]
                  this.currentWidth = this.currentPhotoProfile?.size.width
                  this.currentHeight = this.currentPhotoProfile?.size.height
                }
              }
            })
          }).margin(10).padding(10)

          if (this.supportFlashMode.length) {
            Text('闪光灯模式').margin(10).padding(10).onClick((_) => {
              DialogHelper.showSelectDialog({
                radioContent: this.getSupportFlashModeStrs(),
                confirm: '确认',
                title: '闪光灯模式',
                onCheckedChanged: (index) => {

                },
                onAction: (action, dialogId, value) => {
                  promptAction.showToast({ message: `${action} --- ${value}` })
                  if (value && this.photoSession) {
                    this.photoSession.setFlashMode(this.supportFlashMode[value])
                  }
                }
              })
            })
          }
          if (this.zoomRatioRangeStart != this.zoomRatioRangeEnd) {
            Text('变焦比').margin(10).padding(10).onClick((_) => {

            })
          }

        }.justifyContent(FlexAlign.Start)

      }.scrollable(ScrollDirection.Horizontal)

      XComponent({
        id: 'componentId',
        type: XComponentType.SURFACE,
        controller: this.mXComponentController,
      })
        .onLoad(async () => {
          this.surfaceId = this.mXComponentController.getXComponentSurfaceId();
          this.startPreviewOutput()

        })
        .width('100%')

        .height(px2vp(this.currentWidth * display.getDefaultDisplaySync().width / this.currentHeight ))

        .borderWidth(4)
        .borderColor(Color.Red)

      Row() {
        Button('拍照').onClick((_) => {
          this.takePhoto()
        })
      }
    }

  }

  getPreviewProfileBySize(): camera.Profile | undefined {
    if (this.supportPreviewProfileArray && this.supportPreviewProfileArray.length) {
      for (let i = 0; i < this.supportPreviewProfileArray.length; i++) {
        let previewProfile = this.supportPreviewProfileArray[i]
        if (previewProfile.size.width === this.currentWidth && previewProfile.size.height === this.currentHeight) {
          return previewProfile
        }
      }
    }
    hilog.error(0x01, TAG, `没找到对应的 previewProfile,width:${this.currentWidth} , height:${this.currentHeight}`)
    return undefined
  }

  getPhotoProfileBySize(): camera.Profile | undefined {
    if (this.supportPhotoProfileArray && this.supportPhotoProfileArray.length) {
      for (let i = 0; i < this.supportPhotoProfileArray.length; i++) {
        let photoProfile = this.supportPhotoProfileArray[i]
        if (photoProfile.size.width === this.currentWidth && photoProfile.size.height === this.currentHeight) {
          return photoProfile
        }
      }
    }
    hilog.error(0x01, TAG, `没找到对应的 photoProfile ,width:${this.currentWidth} , height:${this.currentHeight}`)
    return undefined
  }

  //展示在弹窗中的列表
  getAllSupportSizeStr(profileArray: camera.Profile[]): string[] {
    let result: string[] = []
    for (let i = 0; i < profileArray.length; i++) {
      result.push(this.getSupportSizeStr(profileArray[i]))
    }
    return result
  }

  getSupportSizeStr(profile: camera.Profile): string {
    return `宽：${profile.size.width} , 高：${profile.size.height}`
  }

  //展示在弹窗列表中的闪光灯模式说明
  getSupportFlashModeStrs(): string[] {
    let result: string [] = []
    this.supportFlashMode.forEach((value) => {
      if (value === camera.FlashMode.FLASH_MODE_CLOSE) {
        result.push('闪光灯关闭')
      } else if (value === camera.FlashMode.FLASH_MODE_OPEN) {
        result.push('闪光灯打开')
      } else if (value === camera.FlashMode.FLASH_MODE_AUTO) {
        result.push('自动闪光灯')
      } else if (value === camera.FlashMode.FLASH_MODE_ALWAYS_OPEN) {
        result.push('闪光灯常亮')
      }
    })
    return result
  }

  //展示在弹窗中相机列表
  getAllCamerasPositionStr(devices: camera.CameraDevice[]): string[] {
    let result: string[] = []
    for (let i = 0; i < devices.length; i++) {
      result.push(this.getCameraPositionStr(devices[i]))
    }
    return result
  }

  getCameraPositionStr(device: camera.CameraDevice): string {
    let result = ''
    if (device.cameraPosition == camera.CameraPosition.CAMERA_POSITION_UNSPECIFIED) {
      result += '未指定'
    } else if (device.cameraPosition == camera.CameraPosition.CAMERA_POSITION_BACK) {
      result += '后置相机'
    } else if (device.cameraPosition == camera.CameraPosition.CAMERA_POSITION_FRONT) {
      result += '前置相机'
    } else if (device.cameraPosition == camera.CameraPosition.CAMERA_POSITION_FOLD_INNER) {
      result += '折叠态相机'
    }
    return result
  }

  //相机管理
  getCameraManager(context: common.BaseContext): camera.CameraManager {
    let cameraManager: camera.CameraManager = camera.getCameraManager(context);
    return cameraManager;
  }

  //获取可用相机列表
  getCameraDevices(): Array<camera.CameraDevice> {
    let cameraArray: Array<camera.CameraDevice> = this.cameraManager.getSupportedCameras();
    hilog.error(0x01, TAG, '-------getCameraDevices----');
    if (cameraArray != undefined && cameraArray.length > 0) {
      for (let index = 0; index < cameraArray.length; index++) {
        let camera: camera.CameraDevice = cameraArray[index]
        hilog.info(0x01, TAG, 'cameraId : ' + camera.cameraId); // 获取相机ID
        hilog.info(0x01, TAG, 'cameraPosition : ' + camera.cameraPosition); // 获取相机位置
        hilog.info(0x01, TAG, 'cameraType : ' + camera.cameraType); // 获取相机类型
        hilog.info(0x01, TAG, 'connectionType : ' + camera.connectionType); // 获取相机连接类型
      }
      return cameraArray;
    } else {
      hilog.error(0x01, TAG, "cameraManager.getSupportedCameras error");
      return [];
    }
  }

  // 监听相机状态
  onCameraStatusChange(): void {
    this.cameraManager.on('cameraStatus', (err: BusinessError, cameraStatusInfo: camera.CameraStatusInfo) => {
      if (err !== undefined && err.code !== 0) {
        hilog.error(0x01, TAG, `Callback Error, errorCode: ${err.code}`);
        return;
      }
      // 如果当通过USB连接相机设备时，回调函数会返回新的相机出现状态
      if (cameraStatusInfo.status == camera.CameraStatus.CAMERA_STATUS_APPEAR) {
        hilog.info(0x01, TAG, `New Camera device appear.`);
      }
      // 如果当断开相机设备USB连接时，回调函数会返回相机被移除状态
      if (cameraStatusInfo.status == camera.CameraStatus.CAMERA_STATUS_DISAPPEAR) {
        hilog.info(0x01, TAG, `Camera device has been removed.`);
      }
      // 相机被关闭时，回调函数会返回相机可用状态
      if (cameraStatusInfo.status == camera.CameraStatus.CAMERA_STATUS_AVAILABLE) {
        hilog.info(0x01, TAG, `Current Camera is available.`);
      }
      // 相机被打开/占用时，回调函数会返回相机不可用状态
      if (cameraStatusInfo.status == camera.CameraStatus.CAMERA_STATUS_UNAVAILABLE) {
        hilog.info(0x01, TAG, `Current Camera has been occupied.`);
      }
      hilog.info(0x01, TAG, `camera: ${cameraStatusInfo.camera.cameraId}`);
      hilog.info(0x01, TAG, `status: ${cameraStatusInfo.status}`);
    });
  }

  //创建相机输入流
  createInput(): camera.CameraInput | undefined {
    // 创建相机输入流
    let cameraInput: camera.CameraInput | undefined = undefined;
    try {
      cameraInput = this.cameraManager.createCameraInput(this.currentCamera);
    } catch (error) {
      let err = error as BusinessError;
      console.error('Failed to createCameraInput errorCode = ' + err.code);
    }
    if (cameraInput === undefined) {
      return undefined;
    }
    // 监听cameraInput错误信息
    cameraInput.on('error', this.currentCamera, (error: BusinessError) => {
      console.error(`Camera input error code: ${error.code}`);
    });

    return cameraInput;
  }

  getSupportedOutputCapability(): camera.CameraOutputCapability | undefined {
    // 获取相机设备支持的输出流能力
    let cameraOutputCapability: camera.CameraOutputCapability =
      this.cameraManager.getSupportedOutputCapability(this.currentCamera, camera.SceneMode.NORMAL_PHOTO)

    if (!cameraOutputCapability) {
      console.error("cameraManager.getSupportedOutputCapability error");
      return undefined;
    }
    return cameraOutputCapability;
  }

  async switchOutput(photoSession: camera.PhotoSession, videoOutput: camera.VideoOutput,
    photoOutput: camera.PhotoOutput): Promise<void> {
    try {
      await photoSession.stop();
    } catch (error) {
      let err = error as BusinessError;
      console.error(`Failed to stop. error: ${JSON.stringify(err)}`);
    }

    try {
      photoSession.beginConfig();
    } catch (error) {
      let err = error as BusinessError;
      console.error(`Failed to beginConfig. error: ${JSON.stringify(err)}`);
    }
    // 从会话中移除拍照输出流
    try {
      photoSession.removeOutput(photoOutput);
    } catch (error) {
      let err = error as BusinessError;
      console.error(`Failed to remove photoOutput. error: ${JSON.stringify(err)}`);
    }
    // 向会话中添加视频输出流
    try {
      photoSession.addOutput(videoOutput);
    } catch (error) {
      let err = error as BusinessError;
      console.error(`Failed to add videoOutput. error: ${JSON.stringify(err)}`);
    }
  }

  createSession() {
    //创建会话

    try {
      this.photoSession = this.cameraManager.createSession(camera.SceneMode.NORMAL_PHOTO) as camera.PhotoSession;
    } catch (error) {
      let err = error as BusinessError;
      console.error('Failed to create the session instance. errorCode = ' + err.code);
    }
    if (this.photoSession === undefined) {
      return;
    }
    // 监听session错误信息
    this.photoSession.on('error', (error: BusinessError) => {
      console.error(`Capture session error code: ${error.code}`);
    });
  }

  async configSession(cameraInput: camera.CameraInput, previewOutput: camera.PreviewOutput) {
    if (!this.photoSession) {
      return
    }

    // 开始配置会话
    try {
      this.photoSession.beginConfig();
    } catch (error) {
      let err = error as BusinessError;
      console.error('Failed to beginConfig. errorCode = ' + err.code);
    }

    // 向会话中添加相机输入流
    try {
      this.photoSession.addInput(cameraInput);
    } catch (error) {
      let err = error as BusinessError;
      console.error('Failed to addInput. errorCode = ' + err.code);
    }

    // 向会话中添加预览输出流
    try {
      this.photoSession.addOutput(previewOutput);
    } catch (error) {
      let err = error as BusinessError;
      console.error('Failed to addOutput(previewOutput). errorCode = ' + err.code);
    }

    // 向会话中添加拍照输出流
    try {
      this.photoSession.addOutput(this.photoOutput);
    } catch (error) {
      let err = error as BusinessError;
      console.error('Failed to addOutput(photoOutput). errorCode = ' + err.code);
    }

    // 提交会话配置
    await this.photoSession.commitConfig();
  }

  getSupportFlashMode() {
    this.supportFlashMode = []
    if (!this.photoSession) {
      return
    }
    // 判断设备是否支持闪光灯
    let flashStatus: boolean = false;
    try {
      flashStatus = this.photoSession.hasFlash();
    } catch (error) {
      let err = error as BusinessError;
      console.error('Failed to hasFlash. errorCode = ' + err.code);
    }
    console.info('Returned with the flash light support status:' + flashStatus);

    if (flashStatus) {
      // 判断支持的闪光灯模式
      try {
        let status: boolean = this.photoSession.isFlashModeSupported(camera.FlashMode.FLASH_MODE_CLOSE);
        if (status) {
          this.supportFlashMode.push(camera.FlashMode.FLASH_MODE_CLOSE)
        }
      } catch (error) {
        let err = error as BusinessError;
        console.error('Failed to check whether the flash mode is supported. errorCode = ' + err.code);
      }

      try {
        let status: boolean = this.photoSession.isFlashModeSupported(camera.FlashMode.FLASH_MODE_OPEN);
        if (status) {
          this.supportFlashMode.push(camera.FlashMode.FLASH_MODE_OPEN)
        }
      } catch (error) {
        let err = error as BusinessError;
        console.error('Failed to check whether the flash mode is supported. errorCode = ' + err.code);
      }

      try {
        let status: boolean = this.photoSession.isFlashModeSupported(camera.FlashMode.FLASH_MODE_AUTO);
        if (status) {
          this.supportFlashMode.push(camera.FlashMode.FLASH_MODE_AUTO)
        }
      } catch (error) {
        let err = error as BusinessError;
        console.error('Failed to check whether the flash mode is supported. errorCode = ' + err.code);
      }

      try {
        let status: boolean = this.photoSession.isFlashModeSupported(camera.FlashMode.FLASH_MODE_ALWAYS_OPEN);
        if (status) {
          this.supportFlashMode.push(camera.FlashMode.FLASH_MODE_ALWAYS_OPEN)
        }
      } catch (error) {
        let err = error as BusinessError;
        console.error('Failed to check whether the flash mode is supported. errorCode = ' + err.code);
      }
    }
  }

  setAutoContinuousFocus() {
    if (!this.photoSession) {
      return
    }
    // 判断是否支持连续自动变焦模式
    let focusModeStatus: boolean = false;
    try {
      let status: boolean = this.photoSession.isFocusModeSupported(camera.FocusMode.FOCUS_MODE_CONTINUOUS_AUTO);
      focusModeStatus = status;
    } catch (error) {
      let err = error as BusinessError;
      console.error('Failed to check whether the focus mode is supported. errorCode = ' + err.code);
    }

    if (focusModeStatus) {
      // 设置连续自动变焦模式
      try {
        this.photoSession.setFocusMode(camera.FocusMode.FOCUS_MODE_CONTINUOUS_AUTO);
      } catch (error) {
        let err = error as BusinessError;
        console.error('Failed to set the focus mode. errorCode = ' + err.code);
      }
    }

  }

  getZoomRatioRange() {
    if (!this.photoSession) {
      return
    }
    // 获取相机支持的可变焦距比范围
    let zoomRatioRange: Array<number> = [];
    try {
      zoomRatioRange = this.photoSession.getZoomRatioRange();
    } catch (error) {
      let err = error as BusinessError;
      console.error('Failed to get the zoom ratio range. errorCode = ' + err.code);
    }
    if (zoomRatioRange.length <= 0) {
      return;
    }
    this.zoomRatioRangeStart = zoomRatioRange[0]
    this.zoomRatioRangeEnd = zoomRatioRange[1]

  }

  setZoomRatio(zoom?: number) {
    if (!this.photoSession) {
      return
    }
    if (!zoom) {
      zoom = 1
    }
    if (zoom > this.zoomRatioRangeEnd || zoom < this.zoomRatioRangeStart) {
      zoom = 1
    }

    // 设置可变焦距比
    try {
      this.photoSession.setZoomRatio(zoom);
    } catch (error) {
      let err = error as BusinessError;
      console.error('Failed to set the zoom ratio value. errorCode = ' + err.code);
    }
  }

  takePhoto() {
    if (!this.photoOutput) {
      return
    }
    let photoCaptureSetting: camera.PhotoCaptureSetting = {
      quality: camera.QualityLevel.QUALITY_LEVEL_HIGH, // 设置图片质量高
      rotation: camera.ImageRotation.ROTATION_0 // 设置图片旋转角度0
    }
    // 使用当前拍照设置进行拍照
    this.photoOutput.capture(photoCaptureSetting, (err: BusinessError) => {
      if (err) {
        console.error(`Failed to capture the photo ${err.message}`);
        return;
      }
      console.info('Callback invoked to indicate the photo capture request success.');
    });
  }

  async startPreviewOutput(): Promise<void> {
    if (!this.cameraManager) {
      return
    }

    // 创建相机输入流
    let cameraInput: camera.CameraInput | undefined = undefined;
    try {
      cameraInput = this.createInput()
    } catch (error) {
      let err = error as BusinessError;
      console.error('Failed to createCameraInput errorCode = ' + err.code);
    }
    if (cameraInput === undefined) {
      return;
    }


    // 打开相机
    await cameraInput.open();

    // 获取支持的模式类型
    let sceneModes: Array<camera.SceneMode> = this.cameraManager.getSupportedSceneModes(this.currentCamera);
    let isSupportPhotoMode: boolean = sceneModes.indexOf(camera.SceneMode.NORMAL_PHOTO) >= 0;
    if (!isSupportPhotoMode) {
      console.error('photo mode not support');
      return;
    }
    // 获取相机设备支持的输出流能力
    let cameraOutputCap = this.getSupportedOutputCapability()
    if (!cameraOutputCap) {
      console.error("cameraManager.getSupportedOutputCapability error");
      return;
    }
    console.info("outputCapability: " + JSON.stringify(cameraOutputCap));

    this.supportPreviewProfileArray = cameraOutputCap.previewProfiles;


    if (!this.supportPreviewProfileArray) {
      console.error("createOutput previewProfilesArray == null || undefined");
    }

    this.supportPhotoProfileArray = cameraOutputCap.photoProfiles;
    if (!this.supportPhotoProfileArray) {
      console.error("createOutput photoProfilesArray == null || undefined");
    }


    if (!this.currentPhotoProfile) {
      this.currentPhotoProfile = this.getPhotoProfileBySize()
    }
    if (!this.currentPhotoProfile) {
      console.error("getPhotoProfileBySize == null || undefined");
      return
    }
    // 创建拍照输出流
    try {
      this.photoOutput = this.cameraManager.createPhotoOutput(this.currentPhotoProfile);
    } catch (error) {
      let err = error as BusinessError;
      console.error('Failed to createPhotoOutput errorCode = ' + err.code);
    }
    if (this.photoOutput === undefined) {
      return;
    }

    // 创建预览输出流,其中参数 surfaceId 参考上文 XComponent 组件，预览流为XComponent组件提供的surface
    let previewProfile = this.getPreviewProfileBySize()
    if (!previewProfile) {
      console.error("getPreviewProfileBySize == null || undefined");
      return
    }


    let previewOutput: camera.PreviewOutput | undefined = undefined;
    try {
      previewOutput = this.cameraManager.createPreviewOutput(previewProfile, this.surfaceId);
    } catch (error) {
      let err = error as BusinessError;
      console.error(`Failed to create the PreviewOutput instance. error code: ${err.code}`);
    }
    if (previewOutput === undefined) {
      return;
    }




    // 监听预览输出错误信息
    previewOutput.on('error', (error: BusinessError) => {
      console.error(`Preview output error code: ${error.code}`);
    });


    //调用上面的回调函数来保存图片
    this.setPhotoOutputCb();


    //创建会话
    this.createSession()
    //配置会话
    this.configSession(cameraInput, previewOutput)


    //设置预览旋转角度
    let initDisplayRotation = display.getDefaultDisplaySync().rotation;
    let imageRotation = initDisplayRotation * camera.ImageRotation.ROTATION_90;
    let previewRotation: camera.ImageRotation = camera.ImageRotation.ROTATION_0;

    try {
      previewRotation = previewOutput.getPreviewRotation(imageRotation);
      console.log(`Preview rotation is: ${previewRotation}`);
    } catch (error) {
      // 失败返回错误码error.code并处理
      let err = error as BusinessError;
      console.error(`The previewOutput.getPreviewRotation call failed. error code: ${err.code}`);
    }
    previewOutput.setPreviewRotation(previewRotation, false);


    // 启动会话
    if (this.photoSession) {
      await this.photoSession.start().then(() => {
        console.info('Promise returned to indicate the session start success.');
      });
    } else {
      return
    }

    //获取支持的闪光灯模式
    this.getSupportFlashMode()
    //设置连续自动对焦
    this.setAutoContinuousFocus()
    //获取并设置变焦范围
    this.getZoomRatioRange()
    this.setZoomRatio()



    //
    // // 需要在拍照结束之后调用以下关闭摄像头和释放会话流程，避免拍照未结束就将会话释放。
    // // 停止当前会话
    // await photoSession.stop();
    //
    // // 释放相机输入流
    // await cameraInput.close();
    //
    // // 释放预览输出流
    // await previewOutput.release();
    //
    // // 释放拍照输出流
    // await photoOutput.release();
    //
    // // 释放会话
    // await photoSession.release();
    //
    // // 会话置空
    // photoSession = undefined;

  }

  setPhotoOutputCb(): void {
    if (!this.photoOutput) {
      return
    }
    //设置回调之后，调用photoOutput的capture方法，就会将拍照的buffer回传到回调中
    this.photoOutput.on('photoAvailable', (errCode: BusinessError, photo: camera.Photo): void => {
      console.info('getPhoto start');
      console.info(`err: ${JSON.stringify(errCode)}`);
      if (errCode || photo === undefined) {
        console.error('getPhoto failed');
        return;
      }
      let imageObj = photo.main;
      imageObj.getComponent(image.ComponentType.JPEG, (errCode: BusinessError, component: image.Component): void => {
        console.info('getComponent start');
        if (errCode || component === undefined) {
          console.error('getComponent failed');
          return;
        }
        let buffer: ArrayBuffer;
        if (component.byteBuffer) {
          buffer = component.byteBuffer;
          let filePath = getContext().cacheDir + '/' + systemDateTime.getTime() + '.jpg'
          let file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE)
          fileIo.writeSync(file.fd, buffer)
          fileIo.closeSync(file)

          let fileUrl = fileUri.getUriFromPath(filePath)
          promptAction.showToast({message:fileUrl})


          let id: number = 0
          promptAction.openCustomDialog({
            builder: () => {
              this.saveImageToAlbumDialog(fileUrl, () => {
                promptAction.closeCustomDialog(id)
              })
            }
          }).then((dialogID) => {
            id = dialogID
          })

        } else {
          console.error('byteBuffer is null');
          return;
        }
        imageObj.release();
      });
    });
  }

  @Builder
  saveImageToAlbumDialog(fileUrl: string, dismiss: () => void) {

    Column() {
      Image(fileUrl).objectFit(ImageFit.Contain)
      Row() {
        Button().onClick((_) => {
          dismiss()
        })
        SaveButton({ text: SaveDescription.SAVE_IMAGE }).onClick((_) => {
          dismiss()
        })
      }
    }
  }
}