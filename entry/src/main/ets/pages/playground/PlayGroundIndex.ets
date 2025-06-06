import { BaseListItem } from '../../comm/BaseListItem'
import { router, UIContext } from '@kit.ArkUI'
import { common } from '@kit.AbilityKit'
import { reqPermissionsFromUser, RequestPermissionCallBack } from '../../util/PermissionUtils'
import { HMPopInfo, HMRouterMgr } from '@hadss/hmrouter'
import hilog from '@ohos.hilog'
import { FlutterPath, MyFlutterRouter } from '../flutter/MyFlutterRouter'

@Component
export struct PlayGroundIndex {
  build() {
    Scroll() {


      Flex({ wrap: FlexWrap.Wrap }) {
        BaseListItem({ label: '常见问题', path: "pages/playground/FAQ/IndexPage" })
        BaseListItem({ label: '手写签名', path: 'pages/playground/SignatureWithCanvas' })
        BaseListItem({ label: '3D翻转卡片', path: 'pages/playground/Image3D' })
        BaseListItem({ label: '球面动画', path: 'pages/playground/AnimationOfSphericalPaths' })
        BaseListItem({ label: '九宫格', path: 'pages/playground/NineSquareBox' })
        BaseListItem({ label: '相册', path: 'pages/playground/PhotoAlbumPage' })
        BaseListItem({ label: '波浪线', path: 'pages/playground/WaveLinePage' })
        BaseListItem({ label: '刮奖', path: 'pages/playground/ScratchOffPage' })
        BaseListItem({ label: '图片手势缩放', path: 'pages/playground/ImageScaleWithGesture' })
        BaseListItem({ label: '闹钟', path: 'pages/playground/AlarmClockPage' })
        BaseListItem({ label: '画布复合操作', path: 'pages/playground/canvas/CanvasCompositeOperationPage' })
        BaseListItem({ label: '妖娆刻度尺', path: 'pages/playground/canvas/ruler/RulerPage' })
        BaseListItem({ label: '自定义节点', path: 'pages/playground/nodeContainer/CustomNode' })
        BaseListItem({ label: '操作节点树', path: 'pages/playground/frame_node/OperationNodeTree' })
        BaseListItem({
          label: '设置节点通用属性和事件回调',
          path: 'pages/playground/frame_node/CommonAttributeAndEvent'
        })
        BaseListItem({ label: '自定义测量与绘制', path: 'pages/playground/frame_node/MeasureAndDraw' })
        BaseListItem({ label: '倒计时', path: 'pages/playground/timer/TimerPage' })
        BaseListItem({ label: '验证码输入“TextInput实现”', path: 'pages/playground/input/InputVerificationCode' })
        BaseListItem({ label: '记录键盘输入', path: 'pages/playground/input/RecordKeyboardInputPage' })
        BaseListItem({ label: '验证码“Text实现”', path: 'pages/playground/input/InputVerificationByText' })
        BaseListItem({ label: '验证码“Canvas实现”', path: 'pages/playground/input/CanvasInputVerificationCode' })
        BaseListItem({ label: '限制行数的Flex', path: 'pages/playground/LineLimitFlexPage' })
        BaseListItem({ label: '富文本解析', path: 'pages/playground/html_parse/HtmlParsePage' })
        BaseListItem({ label: 'Observe', path: "pages/playground/observed_and_objectLink/ObservedLinkPage" })
        BaseListItem({ label: 'JSON解析', path: "pages/playground/JSONParsePage" })
        BaseListItem({ label: '滑块验证码', path: "pages/playground/slide_verification/SlideVerificationPage" })
        BaseListItem({ label: '手势图片', path:     "pages/playground/GestureImagePage" })
        BaseListItem({ label: '属性字符串', path:     "pages/playground/StyledStringValuePage" })

        Button('自定义拍照').onClick((_) => {

          const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
          const uiContent = this.getUIContext()
          reqPermissionsFromUser(['ohos.permission.CAMERA'], context, uiContent, {
            onGrant: () => {
              router.pushUrl({ url: 'pages/playground/take_photo/TakePhotoPage' })
            }
          } as RequestPermissionCallBack)

        })
        Button('自定义录像').onClick((_) => {

          const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
          const uiContent = this.getUIContext()
          reqPermissionsFromUser(['ohos.permission.MICROPHONE', 'ohos.permission.CAMERA'], context, uiContent, {
            onGrant: () => {
              router.pushUrl({ url: 'pages/playground/video_recorder/VideoRecorderPage' })
            }
          } as RequestPermissionCallBack)

        })
        Button('状态管理 V2').onClick((_) => {
          router.pushUrl({ url: 'pages/playground/state_manager_v2/StateManagerV2Page' })
        })
        Button('HMRouter').onClick((_) => {
          HMRouterMgr.push({ pageUrl: 'pages/playground/hmrouter_page/HMRouterAPage' }, {
            onResult: (popInfo: HMPopInfo) => {
              hilog.error(0x01, 'hmrouter', 'HMRouterAPageNav 页面返回值-->' + JSON.stringify(popInfo))
            },
            onArrival: (() => {
              hilog.error(0x01, 'hmrouter', 'HMRouterAPageNav onArrival')
            }),
            onLost: (() => {
              hilog.error(0x01, 'hmrouter', 'HMRouterAPageNav onLost')
            })
          })
        })

        Button('Flutter测试').onClick((_) => {
          HMRouterMgr.push({ pageUrl: 'pages/flutter/FlutterMainPage' }, {
            onResult: (popInfo: HMPopInfo) => {
              hilog.error(0x01, 'hmrouter', 'FlutterMainPage 页面返回值-->' + JSON.stringify(popInfo))
            },
            onArrival: (() => {
              hilog.error(0x01, 'hmrouter', 'FlutterMainPage onArrival')
            }),
            onLost: (() => {
              hilog.error(0x01, 'hmrouter', 'FlutterMainPage onLost')
            })
          })
        })
      }
    }
  }
}

