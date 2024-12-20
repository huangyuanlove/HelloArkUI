import { camera } from '@kit.CameraKit';
import { BusinessError, systemDateTime } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { image } from '@kit.ImageKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { promptAction, router } from '@kit.ArkUI';
import { FileUtil } from '../video_recorder/FileUtil';

const TAG: string = 'TakePhotoPage'

@Entry
@Component
struct TakePhotoPage {

  @State photoLocalPath:string = ''


  private surfaceId: string = '';
  private mXComponentController: XComponentController = new XComponentController;
  //是否展示切换摄像头
  @State needShowSwitchCameraView: boolean = false;
  //当前使用的哪个摄像头
  private currentCameraIndex = 0

  private photoOutput : camera.PhotoOutput | undefined


  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({
      cancel: () => {
      },
      confirm: () => {
      },
      imagePath:this.photoLocalPath
    }),
  })


  build() {

    Stack({ alignContent: Alignment.Top }) {
      XComponent({
        id: 'componentId',
        type: XComponentType.SURFACE,
        controller: this.mXComponentController,
      })
        .onLoad(async () => {
          this.surfaceId = this.mXComponentController.getXComponentSurfaceId();
          await this.initCamera();
        })
        .width('100%')

        .borderWidth(4)
        .borderColor(Color.Red)

      Column() {
        Blank()
        Row() {


          Text('取消').fontColor(Color.White).fontSize(16).onClick((_) => {
            router.back()
          })
          Blank().width(20)
          Stack(){
            Circle().width(60).height(60).fill(Color.White).onClick((_)=>{
              if(this.photoOutput){
                let settings: camera.PhotoCaptureSetting = {
                  quality: camera.QualityLevel.QUALITY_LEVEL_HIGH,  // 设置图片质量高
                  rotation: camera.ImageRotation.ROTATION_0,  // 设置图片旋转角度的camera.ImageRotation.ROTATION_0是通过说明中获取拍照角度的getPhotoRotation方法获取的值进行设置
                  mirror: false  // 设置镜像使能开关(默认关)
                };
               this. photoOutput.capture(settings, (err: BusinessError) => {
                  if (err) {
                    hilog.error(0x01,TAG, `Failed to capture the photo. error: ${JSON.stringify(err)}`);
                    return;
                  }
                 hilog.error(0x01,TAG,'Callback invoked to indicate the photo capture request success.');
                });
              }
            })
          }

          Blank().width(20)
          if (this.needShowSwitchCameraView) {
            Image($r('app.media.switch_camera')).width(35).height(26).onClick((_) => {

            })
          }
        }
        .width("100%")

        .margin({ bottom: 20 })
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
      }
      .width("100%")
      .height("100%")
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)

    }
  }

  async initCamera() {
    let cameraManager = getCameraManager(getContext(this))
    if (!cameraManager) {
      hilog.error(0x01, TAG, 'camera.getCameraManager error')
      return;
    }

    //添加监听
    onCameraStatusChange(cameraManager)

    let cameraArray: Array<camera.CameraDevice> = getCameraDevices(cameraManager)
    if (cameraArray.length <= 0) {
      hilog.error(0x01, TAG, 'cameraManager.getSupportedCameras error');
      promptAction.showToast({ message: "无可用相机" })
      return;
    }
    cameraArray.forEach((cameraDevice: camera.CameraDevice) => {
      hilog.error(0x01, TAG,
        cameraDevice.cameraId + "  " + cameraDevice.cameraPosition + "  " + cameraDevice.cameraType + "  " +
        cameraDevice.connectionType + "  " + cameraDevice.cameraOrientation)
    })

    //是否需要展示切换摄像头按钮
    if (cameraArray.length == 1) {
      this.needShowSwitchCameraView = false
    } else {
      this.needShowSwitchCameraView = true
    }
    let cameraIndex = this.currentCameraIndex % cameraArray.length
    let currenCamera = cameraArray[cameraIndex]


    let supportSceneMode: Array<camera.SceneMode> = getSupportedSceneMode(currenCamera, cameraManager)
    supportSceneMode.forEach((sceneMode:camera.SceneMode)=>{
      hilog.error(0x01,TAG,`sceneMode -> ${sceneMode}`)
    })
    let cameraOutputCap: camera.CameraOutputCapability | undefined =
      await getSupportedOutputCapability(currenCamera, cameraManager, camera.SceneMode.NORMAL_PHOTO)

    if (!cameraOutputCap) {
      hilog.error(0x01, TAG, 'cameraManager.getSupportedOutputCapability error');
      return;
    }
    hilog.error(0x01, TAG, 'outputCapability: ' + JSON.stringify(cameraOutputCap));
    cameraOutputCap.photoProfiles.forEach((photoProfile: camera.Profile) => {
      hilog.error(0x01, TAG, 'photoProfile: ' + JSON.stringify(photoProfile));
    })
    cameraOutputCap.previewProfiles.forEach((previewProfile: camera.Profile) => {
      hilog.error(0x01, TAG, 'previewProfile: ' + JSON.stringify(previewProfile));
    })

    let photoSession = getSession(cameraManager)
    if (!photoSession) {
      hilog.error(0x01, TAG, 'getSession error');
      return;
    }



    let cameraInput: camera.CameraInput | undefined = await createInput(currenCamera, cameraManager)
    if (!cameraInput) {
      hilog.error(0x01, TAG, 'cameraInput is null');
      return
    }

    this.photoOutput = getPhotoOutput(cameraManager,cameraOutputCap)
    if(!this.photoOutput){
      hilog.error(0x01, TAG, 'photoOutput is null');
      return
    }

    let previewOutput = getPreviewOutput(cameraManager,cameraOutputCap,this.surfaceId)
    if(!previewOutput){
      hilog.error(0x01, TAG, 'previewOutput is null');
      return
    }
    this.setPhotoOutputCb(this.photoOutput)

    beginConfig(photoSession)
    configuringSession(photoSession)
    startSession(photoSession, cameraInput, previewOutput, this.photoOutput)

  }


   setPhotoOutputCb(photoOutput: camera.PhotoOutput) {
  //设置回调之后，调用photoOutput的capture方法，就会将拍照的buffer回传到回调中
  photoOutput.on('photoAvailable', (errCode: BusinessError, photo: camera.Photo): void => {
    hilog.error(0x01, TAG, 'getPhoto start');
    hilog.error(0x01, TAG, `err: ${JSON.stringify(errCode)}`);
    if (errCode || photo === undefined) {
      hilog.error(0x01, TAG, 'getPhoto failed');
      return;
    }
    let imageObj: image.Image = photo.main;
    imageObj.getComponent(image.ComponentType.JPEG, (errCode: BusinessError, component: image.Component): void => {
      hilog.error(0x01, TAG, 'getComponent start');
      if (errCode || component === undefined) {
        hilog.error(0x01, TAG, 'getComponent failed');
        return;
      }
      let buffer: ArrayBuffer;
      if (component.byteBuffer) {
        buffer = component.byteBuffer;
      } else {
        hilog.error(0x01, TAG, 'byteBuffer is null');
        return;
      }
      // 如需要在图库中看到所保存的图片、视频资源，请使用用户无感的安全控件创建媒体资源。
      let path = getContext().cacheDir +'/' + systemDateTime.getTime() +'.jpg'
      let result = FileUtil.writeBufferToFile(path,buffer)

      hilog.error(0x01, TAG, `${result}  finish save file ` + path);
      if(result > 0){
        this.photoLocalPath = path
      }

      // buffer处理结束后需要释放该资源，如果未正确释放资源会导致后续拍照获取不到buffer
      imageObj.release();
      this.dialogController?.open()
    });
  });
}
}

//获取cameraManager对象。
function getCameraManager(context: common.BaseContext): camera.CameraManager {
  let cameraManager: camera.CameraManager = camera.getCameraManager(context);
  return cameraManager;
}

//获取当前设备支持的相机列表，列表中存储了设备支持的所有相机ID。若列表不为空，则说明列表中的每个ID都支持独立创建相机对象；否则，说明当前设备无可用相机，不可继续后续操作。
function getCameraDevices(cameraManager: camera.CameraManager): Array<camera.CameraDevice> {
  let cameraArray: Array<camera.CameraDevice> = cameraManager.getSupportedCameras();
  if (cameraArray != undefined && cameraArray.length > 0) {
    for (let index = 0; index < cameraArray.length; index++) {
      hilog.error(0x01, TAG, 'cameraId : ' + cameraArray[index].cameraId); // 获取相机ID
      hilog.error(0x01, TAG, 'cameraPosition : ' + cameraArray[index].cameraPosition); // 获取相机位置
      hilog.error(0x01, TAG, 'cameraType : ' + cameraArray[index].cameraType); // 获取相机类型
      hilog.error(0x01, TAG, 'connectionType : ' + cameraArray[index].connectionType); // 获取相机连接类型
    }
    return cameraArray;
  } else {
    hilog.error(0x01, TAG, "cameraManager.getSupportedCameras error");
    return [];
  }
}

//在相机应用开发过程中，可以随时监听相机状态，包括新相机的出现、相机的移除、相机的可用状态
function onCameraStatusChange(cameraManager: camera.CameraManager): void {
  cameraManager.on('cameraStatus', (err: BusinessError, cameraStatusInfo: camera.CameraStatusInfo) => {
    if (err !== undefined && err.code !== 0) {
      hilog.error(0x01, TAG, `Callback Error, errorCode: ${err.code}`);
      return;
    }
    // 如果当通过USB连接相机设备时，回调函数会返回新的相机出现状态
    if (cameraStatusInfo.status == camera.CameraStatus.CAMERA_STATUS_APPEAR) {
      hilog.error(0x01, TAG, `New Camera device appear.`);
    }
    // 如果当断开相机设备USB连接时，回调函数会返回相机被移除状态
    if (cameraStatusInfo.status == camera.CameraStatus.CAMERA_STATUS_DISAPPEAR) {
      hilog.error(0x01, TAG, `Camera device has been removed.`);
    }
    // 相机被关闭时，回调函数会返回相机可用状态
    if (cameraStatusInfo.status == camera.CameraStatus.CAMERA_STATUS_AVAILABLE) {
      hilog.error(0x01, TAG, `Current Camera is available.`);
    }
    // 相机被打开/占用时，回调函数会返回相机不可用状态
    if (cameraStatusInfo.status == camera.CameraStatus.CAMERA_STATUS_UNAVAILABLE) {
      hilog.error(0x01, TAG, `Current Camera has been occupied.`);
    }
    hilog.error(0x01, TAG, `camera: ${cameraStatusInfo.camera.cameraId}`);
    hilog.error(0x01, TAG, `status: ${cameraStatusInfo.status}`);
  });
}

async function createInput(cameraDevice: camera.CameraDevice,
  cameraManager: camera.CameraManager): Promise<camera.CameraInput | undefined> {
  // 创建相机输入流
  let cameraInput: camera.CameraInput | undefined = undefined;
  try {
    cameraInput = cameraManager.createCameraInput(cameraDevice);
  } catch (error) {
    let err = error as BusinessError;
    hilog.error(0x01, TAG, 'Failed to createCameraInput errorCode = ' + err.code);
  }
  if (cameraInput === undefined) {
    return undefined;
  }
  // 监听cameraInput错误信息
  cameraInput.on('error', cameraDevice, (error: BusinessError) => {
    hilog.error(0x01, TAG, `Camera input error code: ${error.code}`);
  });
  // 打开相机
  await cameraInput.open();
  return cameraInput;
}

function getSupportedSceneMode(cameraDevice: camera.CameraDevice,
  cameraManager: camera.CameraManager): Array<camera.SceneMode> {
  // 获取相机设备支持的模式列表
  let sceneModeArray: Array<camera.SceneMode> = cameraManager.getSupportedSceneModes(cameraDevice);
  if (sceneModeArray != undefined && sceneModeArray.length > 0) {
    for (let index = 0; index < sceneModeArray.length; index++) {
      hilog.error(0x01, TAG, 'Camera SceneMode : ' + sceneModeArray[index]);
    }
    return sceneModeArray;
  } else {
    hilog.error(0x01, TAG, "cameraManager.getSupportedSceneModes error");
    return [];
  }
}

async function getSupportedOutputCapability(cameraDevice: camera.CameraDevice, cameraManager: camera.CameraManager,
  sceneMode: camera.SceneMode): Promise<camera.CameraOutputCapability | undefined> {
  // 获取相机设备支持的输出流能力
  let cameraOutputCapability: camera.CameraOutputCapability =
    cameraManager.getSupportedOutputCapability(cameraDevice, sceneMode);
  if (!cameraOutputCapability) {
    hilog.error(0x01, TAG, "cameraManager.getSupportedOutputCapability error");
    return undefined;
  }
  console.info("outputCapability: " + JSON.stringify(cameraOutputCapability));
  // 以NORMAL_PHOTO模式为例，需要添加预览流、拍照流
  // previewProfiles属性为获取当前设备支持的预览输出流
  let previewProfilesArray: Array<camera.Profile> = cameraOutputCapability.previewProfiles;
  if (!previewProfilesArray) {
    hilog.error(0x01, TAG, "createOutput previewProfilesArray == null || undefined");
  }
  //photoProfiles属性为获取当前设备支持的拍照输出流
  let photoProfilesArray: Array<camera.Profile> = cameraOutputCapability.photoProfiles;
  if (!photoProfilesArray) {
    hilog.error(0x01, TAG, "createOutput photoProfilesArray == null || undefined");
  }
  return cameraOutputCapability;
}

function getSession(cameraManager: camera.CameraManager): camera.PhotoSession | undefined {
  let session: camera.PhotoSession | undefined = undefined;
  try {
    session = cameraManager.createSession(camera.SceneMode.NORMAL_PHOTO) as camera.PhotoSession;
  } catch (error) {
    let err = error as BusinessError;
    hilog.error(0x01, TAG, `Failed to create the session instance. error: ${JSON.stringify(err)}`);
  }
  return session;
}

function beginConfig(photoSession: camera.PhotoSession): void {
  try {
    photoSession.beginConfig();
  } catch (error) {
    let err = error as BusinessError;
    hilog.error(0x01, TAG, `Failed to beginConfig. error: ${JSON.stringify(err)}`);
  }
}


async function startSession(photoSession: camera.PhotoSession, cameraInput: camera.CameraInput,
  previewOutput: camera.PreviewOutput, photoOutput: camera.PhotoOutput): Promise<void> {
  try {
    photoSession.addInput(cameraInput);
  } catch (error) {
    let err = error as BusinessError;
    hilog.error(0x01, TAG, `Failed to addInput. error: ${JSON.stringify(err)}`);
  }
  try {
    photoSession.addOutput(previewOutput);
  } catch (error) {
    let err = error as BusinessError;
    hilog.error(0x01, TAG, `Failed to add previewOutput. error: ${JSON.stringify(err)}`);
  }
  try {
    photoSession.addOutput(photoOutput);
  } catch (error) {
    let err = error as BusinessError;
    hilog.error(0x01, TAG, `Failed to add photoOutput. error: ${JSON.stringify(err)}`);
  }
  try {
    await photoSession.commitConfig();
  } catch (error) {
    let err = error as BusinessError;
    hilog.error(0x01, TAG, `Failed to commitConfig. error: ${JSON.stringify(err)}`);
  }

  try {
    await photoSession.start();
  } catch (error) {
    let err = error as BusinessError;
    hilog.error(0x01, TAG, `Failed to start. error: ${JSON.stringify(err)}`);
  }
}

async function switchOutput(photoSession: camera.PhotoSession, videoOutput: camera.VideoOutput,
  photoOutput: camera.PhotoOutput): Promise<void> {
  try {
    await photoSession.stop();
  } catch (error) {
    let err = error as BusinessError;
    hilog.error(0x01, TAG, `Failed to stop. error: ${JSON.stringify(err)}`);
  }

  try {
    photoSession.beginConfig();
  } catch (error) {
    let err = error as BusinessError;
    hilog.error(0x01, TAG, `Failed to beginConfig. error: ${JSON.stringify(err)}`);
  }
  // 从会话中移除拍照输出流
  try {
    photoSession.removeOutput(photoOutput);
  } catch (error) {
    let err = error as BusinessError;
    hilog.error(0x01, TAG, `Failed to remove photoOutput. error: ${JSON.stringify(err)}`);
  }
  // 向会话中添加视频输出流
  try {
    photoSession.addOutput(videoOutput);
  } catch (error) {
    let err = error as BusinessError;
    hilog.error(0x01, TAG, `Failed to add videoOutput. error: ${JSON.stringify(err)}`);
  }
}

function getPreviewOutput(cameraManager: camera.CameraManager, cameraOutputCapability: camera.CameraOutputCapability,
  surfaceId: string): camera.PreviewOutput | undefined {

  let previewProfile: undefined | camera.Profile =
    cameraOutputCapability.previewProfiles.find((previewProfile: camera.Profile) => {
      return previewProfile.size.width === 1920 && previewProfile.size.height === 1080;
    });
  let previewOutput: camera.PreviewOutput | undefined = undefined;
  try {
     previewOutput = cameraManager.createPreviewOutput(previewProfile, surfaceId);
  } catch (error) {
    let err = error as BusinessError;
    hilog.error(0x01, TAG, "Failed to create the PreviewOutput instance. error code: " + err.code);
  }
  return previewOutput;
}

function getPhotoOutput(cameraManager: camera.CameraManager,
  cameraOutputCapability: camera.CameraOutputCapability): camera.PhotoOutput | undefined {


  let photoProfile: undefined | camera.Profile =
    cameraOutputCapability.photoProfiles.find((photoProfile: camera.Profile) => {
      return photoProfile.size.width === 1920 && photoProfile.size.height === 1080;
    });
  let photoProfilesArray: Array<camera.Profile> = cameraOutputCapability.photoProfiles;
  if (!photoProfilesArray) {
    hilog.error(0x01, TAG, "createOutput photoProfilesArray == null || undefined");
  }
  let photoOutput: camera.PhotoOutput | undefined = undefined;
  try {
    photoOutput = cameraManager.createPhotoOutput(photoProfile)
  } catch (error) {
    let err = error as BusinessError;
    hilog.error(0x01, TAG, `Failed to createPhotoOutput. error: ${JSON.stringify(err)}`);
  }
  return photoOutput;
}





function configuringSession(photoSession: camera.PhotoSession): void {
  // 判断设备是否支持闪光灯
  let flashStatus: boolean = false;
  try {
    flashStatus = photoSession.hasFlash();
  } catch (error) {
    let err = error as BusinessError;
    hilog.error(0x01, TAG, `Failed to hasFlash. error: ${JSON.stringify(err)}`);
  }
  hilog.error(0x01, TAG, `Returned with the flash light support status: ${flashStatus}`);
  if (flashStatus) {
    // 判断是否支持自动闪光灯模式
    let flashModeStatus: boolean = false;
    try {
      let status: boolean = photoSession.isFlashModeSupported(camera.FlashMode.FLASH_MODE_AUTO);
      flashModeStatus = status;
    } catch (error) {
      let err = error as BusinessError;
      hilog.error(0x01, TAG, `Failed to check whether the flash mode is supported. error: ${JSON.stringify(err)}`);
    }
    if (flashModeStatus) {
      // 设置自动闪光灯模式
      try {
        photoSession.setFlashMode(camera.FlashMode.FLASH_MODE_AUTO);
      } catch (error) {
        let err = error as BusinessError;
        hilog.error(0x01, TAG, `Failed to set the flash mode. error: ${JSON.stringify(err)}`);
      }
    }
  }
  // 判断是否支持连续自动变焦模式
  let focusModeStatus: boolean = false;
  try {
    let status: boolean = photoSession.isFocusModeSupported(camera.FocusMode.FOCUS_MODE_CONTINUOUS_AUTO);
    focusModeStatus = status;
  } catch (error) {
    let err = error as BusinessError;
    hilog.error(0x01, TAG, `Failed to check whether the focus mode is supported. error: ${JSON.stringify(err)}`);
  }
  if (focusModeStatus) {
    // 设置连续自动变焦模式
    try {
      photoSession.setFocusMode(camera.FocusMode.FOCUS_MODE_CONTINUOUS_AUTO);
    } catch (error) {
      let err = error as BusinessError;
      hilog.error(0x01, TAG, `Failed to set the focus mode. error: ${JSON.stringify(err)}`);
    }
  }
  // 获取相机支持的可变焦距比范围
  let zoomRatioRange: Array<number> = [];
  try {
    zoomRatioRange = photoSession.getZoomRatioRange();
  } catch (error) {
    let err = error as BusinessError;
    hilog.error(0x01, TAG, `Failed to get the zoom ratio range. error: ${JSON.stringify(err)}`);
  }
  if (zoomRatioRange.length <= 0) {
    return;
  }
  // 设置可变焦距比
  try {
    photoSession.setZoomRatio(zoomRatioRange[0]);
  } catch (error) {
    let err = error as BusinessError;
    hilog.error(0x01, TAG, `Failed to set the zoom ratio value. error: ${JSON.stringify(err)}`);
  }
}



@CustomDialog
@Component
export struct CustomDialogExample {
  textValue='textValue'
  inputValue='inputValue'
  imagePath=''
  controller?: CustomDialogController
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  build() {
    Column() {
        Image(this.imagePath)
        Button('confirm')
          .onClick(() => {
            if (this.controller != undefined) {
              this.inputValue = this.textValue
              this.controller.close()
              this.confirm()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
  }
}