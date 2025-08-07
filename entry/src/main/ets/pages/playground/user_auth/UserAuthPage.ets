import { ActionBar } from '../../../comm/ActionBar';
import { BusinessError } from  '@kit.BasicServicesKit';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { userAuth, UserAuthIcon } from '@kit.UserAuthenticationKit';
enum UserAuthState{
  not_support,//不支持
  not_satisfied, //功能未禁用，但认证安全等级低于业务指定时
  need_set_password ,//功能未禁用，但用户未注册凭据
  support,//正常使用
  expired //功能未禁用，但密码过期
}

@Entry
@Component
struct UserAuthPage {
  @State  supportFace: UserAuthState = UserAuthState.not_support;
  @State supportFinger: UserAuthState = UserAuthState.not_support;


  rand = cryptoFramework.createRandom();
  len: number = 16;
  randData: Uint8Array = this.rand?.generateRandomSync(this.len)?.data;
  faceAuthParam: userAuth.AuthParam = {
    challenge: this.randData,
    authType: [userAuth.UserAuthType.FACE, userAuth.UserAuthType.PIN],
    authTrustLevel: userAuth.AuthTrustLevel.ATL2
  };
  widgetParam: userAuth.WidgetParam = {
    title: '请进行身份认证'
  };


  fingerAuthParam: userAuth.AuthParam = {
    challenge: this.randData,
    authType: [userAuth.UserAuthType.FINGERPRINT, userAuth.UserAuthType.PIN],
    authTrustLevel: userAuth.AuthTrustLevel.ATL2
  };


  aboutToAppear(): void {

    try {
      userAuth.getAvailableStatus(userAuth.UserAuthType.FACE, userAuth.AuthTrustLevel.ATL2);
      console.info('current auth trust level is supported');
      this.supportFace = UserAuthState.support
    } catch (error) {
      const err: BusinessError<Object> = error as BusinessError<Object>;
      console.error(`FACE current auth trust level is not supported. Code is ${err?.code}, message is ${err?.message}`);
      if(err.code == 12500005){
        this.supportFace = UserAuthState.not_support
      }else if(err.code == 12500006){
        this.supportFace = UserAuthState.not_satisfied
      }else if(err.code == 12500010){
        this.supportFace = UserAuthState.need_set_password
      }else if(err.code == 12500013){
        this.supportFace = UserAuthState.expired
      }
    }


    try {
      userAuth.getAvailableStatus(userAuth.UserAuthType.FINGERPRINT, userAuth.AuthTrustLevel.ATL2);
      console.info('current auth trust level is supported');
      this.supportFinger = UserAuthState.support
    } catch (error) {
      const err: BusinessError<Object> = error as BusinessError<Object>;
      console.error(`FINGERPRINT current auth trust level is not supported. Code is ${err?.code}, message is ${err?.message}`);
      if(err.code == 12500005){
        this.supportFinger = UserAuthState.not_support
      }else if(err.code == 12500006){
        this.supportFinger = UserAuthState.not_satisfied
      }else if(err.code == 12500010){
        this.supportFinger = UserAuthState.need_set_password
      }else if(err.code == 12500013){
        this.supportFinger = UserAuthState.expired
      }
    }


  }

  build() {
    Column() {
      ActionBar({title:"生物识别认证"})

      Row(){
        UserAuthIcon({
          authParam: this.faceAuthParam,
          widgetParam: this.widgetParam,
          iconHeight: 200,
          iconColor: Color.Blue,
          onIconClick: () => {
            console.info('The user clicked the icon.');
            if(this.supportFace == UserAuthState.support){

            }
          },
          onAuthResult: (result: userAuth.UserAuthResult) => {
            console.info(`Get user auth result, result = ${JSON.stringify(result)}`);
          }
        })


        UserAuthIcon({
          authParam: this.fingerAuthParam,
          widgetParam: this.widgetParam,
          iconHeight: 200,
          iconColor: Color.Blue,
          onIconClick: () => {
            console.info('The user clicked the icon.');
          },
          onAuthResult: (result: userAuth.UserAuthResult) => {
            console.info(`Get user auth result, result = ${JSON.stringify(result)}`);
          }
        })

      }


    }
    .height('100%')
    .width('100%')
  }
}