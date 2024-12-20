import { abilityAccessCtrl, bundleManager, common, Permissions, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';


// 使用UIExtensionAbility：将common.UIAbilityContext 替换为common.UIExtensionContext
export function reqPermissionsFromUser(permissions: Array<Permissions>, context: common.UIAbilityContext,uiContext:UIContext,
  callback?: RequestPermissionCallBack): void {
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
  atManager.requestPermissionsFromUser(context, permissions).then((data) => {
    let grantStatus: Array<number> = data.authResults;
    let denyPermissions: string[] = []
    for (let i = 0; i < grantStatus.length; i++) {
      if (grantStatus[i] === 0) {
        // 用户授权，可以继续访问目标操作
      } else {
        // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
        denyPermissions.push(permissions[i])
      }
    }

    if (denyPermissions.length == 0) {
      if (callback && callback.onGrant) {
        callback.onGrant()
      }
    } else {
      promptAction.showToast({message:"需要授权才能进行下一步操作"})

      let permissionNames :string =''

      for(let i = 0;i<denyPermissions.length;i++){
        permissionNames += getPermissionName(denyPermissions[i])
        if(i != denyPermissions.length-1){
          permissionNames += '、'
        }
      }
      uiContext.showAlertDialog(
        {
          title: '权限申请',
          message: `需要授权${permissionNames}才能进行下一步操作`,
          autoCancel: true,
          alignment: DialogAlignment.Bottom,
          gridCount: 3,
          confirm: {
            value: '去设置',
            action: async () => {
              let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
              let wantInfo: Want = {
                bundleName: 'com.huawei.hmos.settings',
                abilityName: 'com.huawei.hmos.settings.MainAbility',
                uri: 'application_info_entry',
                parameters: {
                  pushParams: bundleInfo.name //app的bundleName 也就是包名
                }
              }
              context.startAbility(wantInfo).then(() => {

              }).catch((err: BusinessError) => {
              })

            }
          }
        }
      )



     // let dialogControllerConfirm: CustomDialogController = new CustomDialogController({
     //    builder: AlertDialog({
     //      primaryTitle: '权限提醒',
     //      content: `需要 ${permissionNames} 继续操作`,
     //      primaryButton: {
     //        value: '取消',
     //        action: () => {
     //        },
     //      },
     //      secondaryButton: {
     //        value: '去开启',
     //        role: ButtonRole.ERROR,
     //        action: () => {
     //          console.info('Callback when the second button is clicked')
     //        }
     //      },
     //    }),
     //  })
     //  dialogControllerConfirm.open()
    }

  }).catch((err: BusinessError) => {
    console.error(`Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`);
  })
}


function getPermissionName(permission:string):string{

  switch (permission){
    case 'ohos.permission.MICROPHONE':
      return '麦克风'
  }

  return ''
}


export class RequestPermissionCallBack {
  onGrant: (() => void) | undefined
  onDeny: ((denyPermissions: string[]) => void) | undefined
}