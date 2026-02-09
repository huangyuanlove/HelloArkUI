import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import { AbilityConstant, bundleManager, Configuration, ConfigurationConstant, Want } from '@kit.AbilityKit';
import { UIContext, window, uiObserver as observer } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { JSON } from '@kit.ArkTS';
import { HMRouterMgr } from '@hadss/hmrouter';
import { DialogHelper } from '@pura/harmony-dialog';
import { ExclusiveAppComponent, FlutterManager, MethodCall, MethodResult } from '@ohos/flutter_ohos';
import FlutterRouterPlugin from 'flutter_router';
import { Level, Logger, LogManager } from '@pie/log4a';
import { fileIo } from '@kit.CoreFileKit';
import { LLog, LynxServiceCenter, LynxEnv, LynxServiceType } from '@lynx/lynx';
import { LynxDevToolService } from '@lynx/lynx_devtool_service';
import { LynxLogService } from '@lynx/lynx_log_service';
import { LynxHttpService } from '@lynx/lynx_http_service';

export default class EntryAbility extends UIAbility implements ExclusiveAppComponent<UIAbility> {
  detachFromFlutterEngine(): void {
    // throw new Error('Method not implemented.');
  }

  getAppComponent(): UIAbility {
    return this;
  }


  private uiContext: UIContext | null = null;
  private logger: Logger = LogManager.getLogger(this);

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    const cacheDir = this.context.cacheDir;
    const logDir = `${cacheDir}/log`;
    const logFile = `${logDir}/router.log`;
    try {
      // 创建log目录（如果不存在）
      if (!fileIo.accessSync(logDir, fileIo.AccessModeType.EXIST)) {
        fileIo.mkdirSync(logDir);
      }
      // 创建日志文件（如果不存在）
      if (!fileIo.accessSync(logFile)) {
        const fd = fileIo.openSync(logFile, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE);
        fileIo.closeSync(fd);
      }
      console.error("创建日志文件成功")
    } catch (error) {
      const err = error as BusinessError;
      console.error("创建日志文件失败")
      console.error(`File operation failed: code=${err.code}, message=${err.message}`);
    }
    this.logger.addFileAppender(logFile, 'RouterLog', Level.INFO);


    DialogHelper.setDefaultConfig((config) => {
      config.uiAbilityContext = this.context;
    })
    HMRouterMgr.init({
      context: this.context
    })

    FlutterManager.getInstance().pushUIAbility(this);
    FlutterRouterPlugin.setRouterPushHandler((path: string, args: Record<string, Object> | undefined,
      result: MethodResult) => {
      console.error(`rouerHandler:path=> ${path} ,args=>${args}`)
      if (path == 'HMRouterAPage') {
        HMRouterMgr.push({ pageUrl: "pages/playground/hmrouter_page/HMRouterAPage", param: args, }, {
          onResult: (popInfo: PopInfo) => {
            if (popInfo) {
              result.success(popInfo.result)
            }
          }
        })
        return true;
      }
      if (path == 'pages/flutter/FromFlutterPage') {
        HMRouterMgr.push({ pageUrl: 'pages/flutter/FromFlutterPage', param: args }, {
          onResult: (popInfo: PopInfo) => {
            if (popInfo) {
              result.success(popInfo.result)
            } else {
              result.success("")
            }
          }
        })
        return true
      }


      return false;
    });

    FlutterRouterPlugin.setRouterPopHandler((call: MethodCall, result: MethodResult) => {
      console.error(`flutter 调用 pop  setRouterPopHandler:  ${call.method}  ${call.args}`)
      HMRouterMgr.pop({ param: call.args })
      return true;
    })

    // 注册监听，范围是abilityContext内的page
    observer.on('routerPageUpdate', this.context, (info: observer.RouterPageInfo) => {
      if (info.state === observer.RouterPageState.ABOUT_TO_APPEAR) {
        this.logger.log(`pageUpdate--> ${info.name} ABOUT_TO_APPEAR`)
        hilog.error(0x0000, 'routerPageUpdate', 'pageUpdate--> ' + info.name + " ABOUT_TO_APPEAR");
        //   //注册全局 HashMap，根据 info.name 获取对应业务名称
      }
    })


    // Init LynxDevtoolService
    LynxServiceCenter.registerService(LynxServiceType.DevTool, LynxDevToolService.instance);
    // Init LynxHttpService
    LynxServiceCenter.registerService(LynxServiceType.Http, LynxHttpService.instance);
    // Init LynxLogService
    LynxServiceCenter.registerService(LynxServiceType.Log, LynxLogService.instance);

    LLog.useSysLog(true);
    LynxEnv.initialize(this.context);
    let options = new Map<string, string>();
    options.set('App', 'LynxExplorer');
    options.set('AppVersion', '0.0.1');
    LynxEnv.setAppInfo(options);
    LynxEnv.enableDevtool(true);

  }


  onConfigurationUpdate(newConfig: Configuration): void {
    this.setColorMode(newConfig.colorMode == ConfigurationConstant.ColorMode.COLOR_MODE_DARK)
  }

  setColorMode(isDark: boolean) {
    if (isDark) {
      window.getLastWindow(this.context).then((win) => {
        console.error('设置状态栏为深色模式')
        win.setWindowSystemBarProperties({
          statusBarColor: "#ff0000",
          statusBarContentColor: "#000000",

        }).catch((error:BusinessError) => {
          console.error('设置状态栏为深色模式 出错 ' + error.message)
        })
      })
    } else {
      window.getLastWindow(this.context).then((win) => {
        console.error('设置状态栏为浅色模式')
        win.setWindowSystemBarProperties({
          statusBarColor: "#00ff00",
          statusBarContentColor: "#ffffff",

        }).catch((error:BusinessError) => {
          console.error('设置状态栏为浅色模式 出错 ' + error.message)
        })
      })
    }
  }


  onDestroy(): void {

    FlutterManager.getInstance().popUIAbility(this);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
    observer.off('routerPageUpdate', this.context)
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    FlutterManager.getInstance().pushWindowStage(this, windowStage);
    // new PageSpy({
    //   context: this.context,
    //   api: "192.168.1.25:6752",
    //   enableSSL: false,
    //   axios: axiosInstance
    // })

    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err) => {
      // windowStage.loadContent('pages/tel_inquiry_waiting_page/index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
      }
      this.setColorMode(this.context.config.colorMode == ConfigurationConstant.ColorMode.COLOR_MODE_DARK)
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
      windowStage.getMainWindow((err: BusinessError, data) => {
        let windowInfo: window.Window = data;


        // 获取UIContext实例
        this.uiContext = windowInfo.getUIContext();
        // 注册监听，范围是uiContext内的page
        observer.on('routerPageUpdate', this.uiContext, (info: observer.RouterPageInfo) => {
          hilog.error(0x0000, 'routerPageUpdate', `uiContext ${JSON.stringify(info)}`);
        })
      })
    });
  }

  onWindowStageDestroy(): void {
    FlutterManager.getInstance().popWindowStage(this);
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
    if (this.uiContext) {
      observer.off('routerPageUpdate', this.uiContext);
    }
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  onMemoryLevel(level: AbilityConstant.MemoryLevel) {
    let levelRes: number

    switch (level) {
      case AbilityConstant.MemoryLevel.MEMORY_LEVEL_MODERATE:
        levelRes = 5
        break
      case AbilityConstant.MemoryLevel.MEMORY_LEVEL_LOW:
        levelRes = 10
        break
      case AbilityConstant.MemoryLevel.MEMORY_LEVEL_CRITICAL:
        levelRes = 15
        break
    }
  }
}
