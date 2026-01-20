import { ActionBar } from '../../../comm/ActionBar';
import { unifiedDataChannel, uniformDataStruct, uniformTypeDescriptor } from '@kit.ArkData';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { image } from '@kit.ImageKit';

@Entry
@Component
struct DragMainPage {
  @State targetImage: string = ''
  rawImageWidth: Length = 0
  rawImageHeight: Length = 0
  @State targetImageWidth: Length = 0
  @State targetImageHeight: Length = 0
  customDropAnimation =
    () => {
      this.getUIContext().animateTo({ duration: 1000, curve: Curve.EaseOut, playMode: PlayMode.Normal }, () => {
        this.targetImageWidth = this.rawImageWidth;
        this.targetImageHeight = this.rawImageHeight;
      })
    }

  @Builder
  pixelMapBuilder() {
    Column() {
      Image($r('app.media.startIcon')).fitOriginalSize(true)
    }
    .backgroundColor($r('sys.color.comp_background_primary'))
    .borderRadius(16)
  }

  build() {
    Column() {
      ActionBar({ title: "拖拽效果" })
      Image($r('app.media.cat'))
        .fitOriginalSize(true)
        .draggable(true)
        .onDragEnd((event: DragEvent) => {
          if (event.getResult() == DragResult.DRAG_SUCCESSFUL) {
            this.showToast("拖拽成功")
          } else {
            this.showToast("拖拽失败")
          }
        })
        .onAreaChange((oldValue, newValue) => {
          this.rawImageWidth = newValue.width
          this.rawImageHeight = newValue.height
        })
        .onDragStart(() => {
          let dragItemInfo: DragItemInfo = {
            builder: () => {
              this.pixelMapBuilder()
            },
          };
          return dragItemInfo;
        })


      Blank().height(50)

      Image(this.targetImage)
        .width(this.targetImageWidth)
        .height(this.targetImageHeight)
        .fitOriginalSize(true)
        .constraintSize({
          minWidth: "95%",
          minHeight: 100
        })
        .backgroundColor(Color.Gray)
        .borderRadius(12)
        //设置允许落入的数据类型
        .allowDrop([uniformTypeDescriptor.UniformDataType.IMAGE])
        .onDrop((event?: DragEvent) => {
          if (event) {
            event.useCustomDropAnimation = true;
            event.executeDropAnimation(this.customDropAnimation)
            //获取拖拽数据对象
            let dragData: UnifiedData = event.getData()
            let records: unifiedDataChannel.UnifiedRecord[] = dragData.getRecords();
            if (records) {
              //遍历一下数据
              records.forEach((value) => {
                let types = value.getTypes()

                if (types.includes(uniformTypeDescriptor.UniformDataType.FILE_URI)) {
                  const fileUriUds =
                    value.getEntry(uniformTypeDescriptor.UniformDataType.FILE_URI) as uniformDataStruct.FileUri;
                  let typeDescriptor = uniformTypeDescriptor.getTypeDescriptor(fileUriUds.fileType);
                  //拿到的数据是图片类型
                  if (typeDescriptor.belongsTo(uniformTypeDescriptor.UniformDataType.IMAGE)) {
                    this.targetImage = fileUriUds.oriUri;
                  }
                }
              })
            }
          }
        })

    }
    .height('100%')
    .width('100%')
  }

  showToast(msg: string) {
    this.getUIContext().getPromptAction().showToast({ message: msg })
  }
}