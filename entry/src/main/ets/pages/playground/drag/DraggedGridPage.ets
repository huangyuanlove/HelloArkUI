import { curves, display, window } from "@kit.ArkUI";
import { HashSet } from "@kit.ArkTS";

@Entry
@Component
struct DraggedGridPage {
  scroller: Scroller = new Scroller();
  @State text: string = 'drag';

  @State data: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
  private deleteViewHeight: number = 100
  @State deleteViewOffset: number = this.deleteViewHeight
  @State screenHeight: number = 0
  @State deleteViewRawPositionY: number = 0
  @State deleteViewTop: number = 0
  @State statusBarHeight: number = 0
  @State bottomNavBar: number = 0

  @Builder
  pixelMapBuilder() { // 拖拽过程样式
    Column() {
      Text(this.text)
        .fontSize(16)
        .backgroundColor(0xF9CF93)
        .width(90)
        .height(90)
        .textAlign(TextAlign.Center)
        .borderRadius(8)
    }
  }

  aboutToAppear(): void {
    this.screenHeight = this.getUIContext().px2vp(display.getDefaultDisplaySync().height)
    console.error(`DraggedGridPage:screenHeight -> ${this.screenHeight}`)
    window.getLastWindow(this.getUIContext().getHostContext()).then((win) => {
      this.bottomNavBar = this.getUIContext().px2vp(win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height)
      console.error(`DraggedGridPage bottomNavBar-> ${this.bottomNavBar}`)
      this.statusBarHeight =
        this.getUIContext().px2vp(win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height)
      console.error(`DraggedGridPage:statusBarHeight-> ${this.getUIContext().px2vp(this.statusBarHeight)}`)
      this.deleteViewTop = this.screenHeight - this.statusBarHeight - this.deleteViewHeight
      console.error(`DraggedGridPage:deleteViewTop-> ${this.deleteViewTop}`)
    })

  }

  build() {
    Column() {
      Blank().height(200).width(0)
      Grid(this.scroller) {
        ForEach(this.data, (day: number) => {
          GridItem() {
            Text(day.toString())
              .fontSize(16)
              .backgroundColor(0xF9CF93)
              .width(80)
              .height(80)
              .textAlign(TextAlign.Center)
              .borderRadius(8)
          }
        }, (day: string) => day)
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .backgroundColor(Color.Orange)
      .height(300)
      .editMode(true) // 设置Grid是否进入编辑模式，进入编辑模式可以拖拽Grid组件内部GridItem
      .supportAnimation(true) // 设置支持动画
      .onItemDragStart((event: ItemDragInfo, itemIndex: number) => { // 第一次拖拽此事件绑定的组件时，触发回调。
        this.text = this.data[itemIndex].toString();
        this.getUIContext().animateTo({
          duration: 1000,
          curve: curves.interpolatingSpring(0, 1, 400, 38)
        }, () => {
          this.deleteViewOffset = 0
        })
        return this.pixelMapBuilder(); // 设置拖拽过程中显示的图片。
      })

      .onItemDrop((event: ItemDragInfo, itemIndex: number, insertIndex: number,
        isSuccess: boolean) => {
        let top = this.deleteViewTop + 80
        console.error(`onItemDrop: isSuccess->${isSuccess} y->${event.y}     top-> ${top}`)
        if (isSuccess) {
          let tmp = this.data.splice(itemIndex, 1);
          this.data.splice(insertIndex, 0, tmp[0]);
        } else {
          if (event.y > top) {
            console.error(`item 进入删除区域,删除第 ${itemIndex} 个`)
            this.data.splice(itemIndex, 1)
            console.error(`删除后的数据 ${JSON.stringify(this.data)}`)
          } else {
            console.error(`item没有进入删除区域`)
          }
        }
        this.getUIContext().animateTo({
          duration: 1000,
          curve: curves.interpolatingSpring(0, 1, 400, 38)
        }, () => {
          this.deleteViewOffset = this.deleteViewHeight
        })
      })

      Text('删除')
        .fontColor(Color.White)
        .backgroundColor(Color.Red)
        .width('100%')
        .height(this.deleteViewHeight)
        .textAlign(TextAlign.Center)
        .position({ bottom: -this.bottomNavBar - this.deleteViewOffset })
        .onAreaChange((oldValue, newValue) => {
          console.error(`onAreaChange newValue: position.y-> ${newValue.position.y} , globalPosition.y-> ${newValue.globalPosition.y}`)
          this.deleteViewRawPositionY = newValue.position.y as number
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Pink)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}
