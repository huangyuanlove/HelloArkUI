import { display, promptAction, router } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { camera } from '@kit.CameraKit';
import { media } from '@kit.MediaKit';
import { fileUri } from '@kit.CoreFileKit';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import Logger from './Logger';
import { FileUtil } from './FileUtil';
import { CommonConstants } from './CommonConstants';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'Record';
let context = getContext(this) as common.UIAbilityContext;

@Entry
@Component
struct VideoRecorderPage {
  @State xComponentWidth: number = 0;
  @State xComponentHeight: number = 0;
  @State videoUri: string = '';
  @State recording: boolean = false;
  @State path: string = '';
  @State cameraManager: camera.CameraManager | undefined = undefined;
  @State videoOutput: camera.VideoOutput | undefined = undefined;
  @State captureSession: camera.VideoSession | camera.PhotoSession | undefined = undefined;
  @State cameraInput: camera.CameraInput | undefined = undefined;
  @State previewOutput: camera.PreviewOutput | undefined = undefined;
  @State avRecorder: media.AVRecorder | undefined = undefined;
  private mXComponentController: XComponentController = new XComponentController;
  private surfaceId: string = '';
  url: string = '';
  //是否展示切换摄像头
  @State needShowSwitchCameraView: boolean = false;
  //当前使用的哪个摄像头
  private currentCameraIndex = 0
  //最长录制时间
  private maxRecorderDuration: number = 10 * 1000
  @State currenDuration: number = 0
  @State availableWidth: number = 0
  @State availableHeight: number = 0
  @State videoAspectRatio: number = 1
  zoomRatioRange: Array<number> = [];
  currentZoomRatioIndex = 1
  //定时器 id
  private intervalID: number = -1

  aboutToAppear(): void {
    this.availableWidth = display.getDefaultDisplaySync().width
    this.availableHeight = display.getDefaultDisplaySync().height
    this.videoAspectRatio = 9 / 16
  }

  aboutToDisappear(): void {
    this.stopRecord()
    if (this.intervalID < 0) {
      clearInterval(this.intervalID)
    }
  }

  initVideoFilePath() {
    this.path = context.filesDir + '/' + 'VIDEO_' + Date.parse(new Date().toString()) + '.mp4';
    let file = FileUtil.createOrOpen(this.path);
    this.url = 'fd://' + file.fd;
    this.videoUri = fileUri.getUriFromPath(this.path);
  }

  switchCamera() {
    this.currentCameraIndex++
    this.currenDuration = 0
    this.stopRecord()
    this.initCamera(getContext(this), this.surfaceId);
  }

  build() {

      Stack({ alignContent: Alignment.Top }) {
        XComponent({
          id: 'componentId',
          type: XComponentType.SURFACE,
          controller: this.mXComponentController,
        })
          .onLoad(async () => {
            this.surfaceId = this.mXComponentController.getXComponentSurfaceId();
            await this.initCamera(getContext(this), this.surfaceId);
          })
          .width(px2vp(this.availableWidth))
          .height(px2vp(this.availableWidth / this.videoAspectRatio))
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
              Circle().width(60).height(60).fill(Color.White)
              Progress({ value: this.currenDuration, total: this.maxRecorderDuration, type: ProgressType.Ring })
                .width(60)
                .color("#1b91e0")
                .backgroundColor(Color.White)
                .style({ strokeWidth: 2, enableScanEffect: true })
                .onTouch(async (event) => {
                  if (event.type === TouchType.Down) {
                    //延迟 500 毫秒开始录制
                    setTimeout(async () => {
                      this.recording = true
                      this.startRecord();
                    }, 500)
                  } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
                    //停止录像，计算时长；展示录像预览、返回、确认按钮
                    if (this.recording) {
                      this.recording = false
                      await this.stopRecord();
                      router.pushUrl({url:'pages/playground/video_recorder/PlayLocalVideoPage',params:{
                        data:this.path
                      }})
                    }

                  }
                })
            }

            Blank().width(20)
            if (this.needShowSwitchCameraView) {
              Image($r('app.media.switch_camera')).width(35).height(26).onClick((_) => {
                this.switchCamera()
              })
            }
          }
          .width(CommonConstants.FULL_PERCENT)

          .margin({ bottom: 20 })
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
        }
        .width(CommonConstants.FULL_PERCENT)
        .height(CommonConstants.FULL_PERCENT)
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)
      }.backgroundColor(Color.Black)
      .width("100%")
      .height("100%")

  }

  async initCamera(context: common.Context, surfaceId: string) {
    this.initVideoFilePath()
    this.cameraManager = camera.getCameraManager(context);
    if (!this.cameraManager) {
      Logger.error(TAG, 'camera.getCameraManager error');
      return;
    }

    this.cameraManager.on('cameraStatus', (err: BusinessError, cameraStatusInfo: camera.CameraStatusInfo) => {
      Logger.info(TAG, `camera : ${cameraStatusInfo.camera.cameraId}`);
      Logger.info(TAG, `status:  ${cameraStatusInfo.status}`);
    });

    let cameraArray: Array<camera.CameraDevice> = [];
    try {
      cameraArray = this.cameraManager.getSupportedCameras();
      cameraArray.forEach((cameraDevice: camera.CameraDevice) => {
        hilog.error(0x01, TAG,
          cameraDevice.cameraId + "  " + cameraDevice.cameraPosition + "  " + cameraDevice.cameraType + "  " +
          cameraDevice.connectionType + "  " + cameraDevice.cameraOrientation)
      })
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getSupportedCameras call failed. error code: ${err.code}`);
    }

    if (cameraArray.length <= 0) {
      Logger.error(TAG, 'cameraManager.getSupportedCameras error');
      promptAction.showToast({ message: "无可用相机" })
      return;
    }
    if (cameraArray.length == 1) {
      this.needShowSwitchCameraView = false
    } else {
      this.needShowSwitchCameraView = true
    }

    let cameraIndex = this.currentCameraIndex % cameraArray.length

    let cameraOutputCap: camera.CameraOutputCapability =
      this.cameraManager.getSupportedOutputCapability(cameraArray[cameraIndex], camera.SceneMode.NORMAL_VIDEO);
    if (!cameraOutputCap) {
      Logger.error(TAG, 'cameraManager.getSupportedOutputCapability error');
      return;
    }


    Logger.info(TAG, 'outputCapability: ' + JSON.stringify(cameraOutputCap));
    Logger.info(TAG, 'availableWidth: ' + this.availableWidth);
    Logger.info(TAG, 'availableHeight: ' + this.availableHeight);

    let finalWidth = 1920
    let finalHeight = 1080


    cameraOutputCap.videoProfiles.forEach((videoProfile: camera.VideoProfile) => {
      Logger.info(TAG, 'videoProfile: ' + JSON.stringify(videoProfile));

    })
    Logger.error(TAG, `选择了width: ${finalWidth}   height: ${finalHeight}`);

    let previewProfilesArray: Array<camera.Profile> = cameraOutputCap.previewProfiles;
    if (!previewProfilesArray) {
      Logger.error(TAG, 'createOutput previewProfilesArray === null || undefined');
    } else {

    }


    let videoProfilesArray: Array<camera.VideoProfile> = cameraOutputCap.videoProfiles;
    if (!videoProfilesArray) {
      Logger.error(TAG, 'createOutput videoProfilesArray === null || undefined');
    }


    let videoSize: camera.Size = {
      width: finalWidth,
      height: finalHeight
    }
    let videoProfile: undefined | camera.VideoProfile = videoProfilesArray.find((profile: camera.VideoProfile) => {
      return profile.size.width === videoSize.width && profile.size.height === videoSize.height;
    });

    if (!videoProfile) {
      Logger.error(TAG, 'videoProfile is not found');
      return;
    }

    let aVRecorderProfile: media.AVRecorderProfile = {
      audioBitrate: 48000,
      audioChannels: 2,
      audioCodec: media.CodecMimeType.AUDIO_AAC,
      audioSampleRate: 48000,
      fileFormat: media.ContainerFormatType.CFT_MPEG_4,
      videoBitrate: 2000000,
      videoCodec: media.CodecMimeType.VIDEO_AVC,
      videoFrameWidth: videoSize.width,
      videoFrameHeight: videoSize.height,
      videoFrameRate: 30
    };

    let aVRecorderConfig: media.AVRecorderConfig = {
      audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
      videoSourceType: media.VideoSourceType.VIDEO_SOURCE_TYPE_SURFACE_YUV,
      profile: aVRecorderProfile,
      url: this.url,
      rotation: cameraArray[cameraIndex].cameraOrientation
    };


    try {
      this.avRecorder = await media.createAVRecorder();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `createAVRecorder call failed. error code: ${err.code}`);
    }

    if (this.avRecorder === undefined) {
      return;
    }

    try {
      await this.avRecorder.prepare(aVRecorderConfig);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `prepare call failed. error code: ${err.code}`);
    }

    let videoSurfaceId: string | undefined = undefined;
    try {
      videoSurfaceId = await this.avRecorder.getInputSurface();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getInputSurface call failed. error code: ${err.code}`);
    }
    if (videoSurfaceId === undefined) {
      return;
    }

    try {
      this.videoOutput = this.cameraManager.createVideoOutput(videoProfile, videoSurfaceId);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to create the videoOutput instance. error: ${JSON.stringify(err)}`);
    }
    if (this.videoOutput === undefined) {
      return;
    }
    this.videoOutput.on('frameStart', () => {
      Logger.info(TAG, 'Video frame started');
    });

    this.videoOutput.on('error', (error: BusinessError) => {
      Logger.info(TAG, `Preview output error code: ${error.code}`);
    });

    try {
      this.captureSession = this.cameraManager.createSession(camera.SceneMode.NORMAL_VIDEO) as camera.VideoSession;
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, 'Failed to create the CaptureSession instance. errorCode = ' + err.code);
    }
    if (this.captureSession === undefined) {
      return;
    }

    this.captureSession.on('focusStateChange', (err: BusinessError, focusState: camera.FocusState) => {
      let focusStateStr = ''
      if (focusState == camera.FocusState.FOCUS_STATE_SCAN) {
        focusStateStr = '触发对焦'
      } else if (focusState == camera.FocusState.FOCUS_STATE_FOCUSED) {
        focusStateStr = '对焦成功'
      } else if (focusState == camera.FocusState.FOCUS_STATE_UNFOCUSED) {
        focusStateStr = '未完成对焦'
      }
      Logger.error(TAG, `focusStateChange  ${focusStateStr}`);
      if (!err) {
        Logger.error(TAG, 'focusStateChange error ' + JSON.stringify(err));
      }
    })


    try {
      this.captureSession.beginConfig();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, 'Failed to beginConfig. errorCode = ' + err.code);
    }

    let cameraInput: camera.CameraInput | undefined = undefined;
    try {
      cameraInput = this.cameraManager.createCameraInput(cameraArray[cameraIndex]);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to createCameraInput. error: ${JSON.stringify(err)}`);
    }
    if (cameraInput === undefined) {
      return;
    }


    let cameraDevice: camera.CameraDevice = cameraArray[cameraIndex];
    cameraInput.on('error', cameraDevice, (error: BusinessError) => {
      Logger.info(TAG, `Camera input error code: ${error.code}`);
    });

    try {
      await cameraInput.open();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to open cameraInput. error: ${JSON.stringify(err)}`);
    }

    try {
      this.captureSession.addInput(cameraInput);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to add cameraInput. error: ${JSON.stringify(err)}`);
    }

    let previewOutput: camera.PreviewOutput | undefined = undefined;
    try {

      let previewProfile: undefined | camera.Profile = previewProfilesArray.find((profile: camera.Profile) => {
        return profile.size.width === videoSize.width && profile.size.height === videoSize.height;
      });

      if (!previewProfile) {
        Logger.error(TAG, `没有找到对应的预览配置文件`);
        previewProfile = previewProfilesArray[0]
      }
      previewOutput = this.cameraManager.createPreviewOutput(previewProfile, surfaceId);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to create the PreviewOutput instance. error: ${JSON.stringify(err)}`);
    }

    if (previewOutput === undefined) {
      return;
    }

    try {
      this.captureSession.addOutput(previewOutput);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to add previewOutput. error: ${JSON.stringify(err)}`);
    }

    try {
      this.captureSession.addOutput(this.videoOutput);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to add videoOutput. error: ${JSON.stringify(err)}`);
    }

    try {
      await this.captureSession.commitConfig();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `captureSession commitConfig error: ${JSON.stringify(err)}`);
    }


    try {
      this.zoomRatioRange = this.captureSession.getZoomRatioRange();
      // this.captureSession.setZoomRatio(1)
      Logger.error(TAG, `支持的变焦比范围 ${this.zoomRatioRange}`);
    } catch (error) {
      // 失败返回错误码error.code并处理
      let err = error as BusinessError;
      Logger.error(TAG, `The getZoomRatioRange call failed. error code: ${err.code}`);
    }

    try {
      let currentZoomRatio = this.captureSession.getZoomRatio();
      Logger.error(TAG, `当前变焦比 ${currentZoomRatio}`);
    } catch (error) {
      // 失败返回错误码error.code并处理
      let err = error as BusinessError;
      Logger.error(TAG, `The getZoomRatioRange call failed. error code: ${err.code}`);
    }


    let supportFocusModeContinuousAuto: boolean = false;
    try {
      // 以检查是否支持连续自动对焦模式为例
      supportFocusModeContinuousAuto =
        this.captureSession.isFocusModeSupported(camera.FocusMode.FOCUS_MODE_CONTINUOUS_AUTO);
    } catch (error) {
      // 失败返回错误码error.code并处理
      let err = error as BusinessError;
      Logger.error(TAG, `The isFocusModeSupported call failed. error code: ${err.code}`);
    }
    if (supportFocusModeContinuousAuto) {
      try {
        // 设置自动对焦模式
        this.captureSession.setFocusMode(camera.FocusMode.FOCUS_MODE_CONTINUOUS_AUTO);
        // 设置对焦点
        // const focusPoint: camera.Point = {x: this.availableWidth/2, y: this.availableWidth / this.videoAspectRatio/2};
        // this.captureSession.setFocusPoint(focusPoint);
      } catch (error) {
        // 失败返回错误码error.code并处理
        let err = error as BusinessError;
        Logger.error(TAG, `The setFocusMode and setFocusPoint call failed. error code: ${err.code}`);
      }
    } else {
      Logger.error(TAG, `不支持 FOCUS_MODE_CONTINUOUS_AUTO`);
    }

    try {
      await this.captureSession.start();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `captureSession start error: ${JSON.stringify(err)}`);
    }

    this.videoOutput.start((err: BusinessError) => {
      if (err) {
        Logger.error(TAG, `Failed to start the video output. error: ${JSON.stringify(err)}`);
        return;
      }
      Logger.info(TAG, 'Callback invoked to indicate the video output start success.');
    });
  }

  async startRecord() {
    if (this.avRecorder) {
      try {
        await this.avRecorder.start();

        this.intervalID = setInterval(() => {
          this.currenDuration += 500
          if (this.currenDuration > this.maxRecorderDuration) {
            clearInterval(this.intervalID)
            this.intervalID = -1
            this.stopRecord()
          }
        }, 500)

      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `avRecorder start error: ${JSON.stringify(err)}`);
      }
    }
  }

  async stopRecord() {
    if(this.intervalID > 0){
      clearInterval(this.intervalID)
    }


    if (this.avRecorder) {
      try {
        if (this.videoOutput) {
          this.videoOutput.stop((err: BusinessError) => {
            if (err) {
              Logger.error(TAG, `Failed to stop the video output. error: ${JSON.stringify(err)}`);
              return;
            }
            Logger.info(TAG, 'Callback invoked to indicate the video output stop success.');
          });
        }
        try {
          await this.avRecorder.stop();
          await this.avRecorder.release();
        } catch (error) {
          let err = error as BusinessError;
          Logger.error(TAG, `avRecorder stop error: ${JSON.stringify(err)}`);
        }
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `avRecorder stop error: ${JSON.stringify(err)}`);
      }

      if (this.captureSession) {
        try {
          this.captureSession.stop();
        } catch (error) {
          let err = error as BusinessError;
          Logger.error(TAG, `captureSession.stop error: ${JSON.stringify(err)}`);
        }
      }
      if (this.cameraInput) {
        try {
          this.cameraInput.close();
        } catch (error) {
          let err = error as BusinessError;
          Logger.error(TAG, `cameraInput.close error: ${JSON.stringify(err)}`);
        }
      }
      if (this.previewOutput) {
        try {
          this.previewOutput.release();
        } catch (error) {
          let err = error as BusinessError;
          Logger.error(TAG, `previewOutput.release error: ${JSON.stringify(err)}`);
        }
      }
      if (this.videoOutput) {
        try {
          this.videoOutput.release();
        } catch (error) {
          let err = error as BusinessError;
          Logger.error(TAG, `videoOutput.release error: ${JSON.stringify(err)}`);
        }
      }
      if (this.captureSession) {
        try {
          this.captureSession.release();
        } catch (error) {
          let err = error as BusinessError;
          Logger.error(TAG, `captureSession.release error: ${JSON.stringify(err)}`);
        }
      }

      if (this.captureSession) {
        this.captureSession = undefined;
      }
    }
  }
}

