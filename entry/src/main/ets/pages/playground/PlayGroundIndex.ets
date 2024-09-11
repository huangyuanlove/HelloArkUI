
import { BaseListItem } from '../../comm/BaseListItem'

@Component
export struct  PlayGroundIndex {

  build(){
    Flex({wrap:FlexWrap.Wrap}){
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
      BaseListItem({ label: '设置节点通用属性和事件回调', path: 'pages/playground/frame_node/CommonAttributeAndEvent' })
      BaseListItem({ label: '自定义测量与绘制', path: 'pages/playground/frame_node/MeasureAndDraw' })
      BaseListItem({ label: '倒计时', path: 'pages/playground/timer/TimerPage' })
      BaseListItem({ label: '验证码输入“TextInput实现”', path: 'pages/playground/input/InputVerificationCode' })
      BaseListItem({ label: '验证码“Text实现”', path: 'pages/playground/input/InputVerificationByText' })
      BaseListItem({ label: '验证码“Canvas实现”', path: 'pages/playground/input/CanvasInputVerificationCode' })
      BaseListItem({ label: '限制行数的Flex', path: 'pages/playground/LineLimitFlexPage' })
    }.width("100%").height("100%").padding({top:48})
  }

 }

