
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
    }.width("100%").height("100%").padding({top:48})
  }

 }

