
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
    }.width("100%").height("100%").padding({top:48})
  }

 }

