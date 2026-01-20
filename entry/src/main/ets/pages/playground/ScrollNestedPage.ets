import { ActionBar } from '../../comm/ActionBar';

@Entry
@ComponentV2
struct ScrollNestedPage {
  @Local scrollOffset: number = 0;
  @Local text1Height: number = 0;
  @Local text2Height: number = 0;
  @Local text2OffsetY: number = 0;
  scroller: Scroller = new Scroller();
  @Local data:number[] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]

  build() {
    Column() {
      ActionBar({ title: "嵌套滚动与吸顶效果" })

      Stack({ alignContent: Alignment.TopStart }) {
        Scroll(this.scroller) {
          Column() {
            // Text1 - 自由滚动
            Text("Text1 - 自由滚动内容\n可以向上滑动")
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .padding(20)
              .width('100%')
              .backgroundColor('#FFE4E4FF')
              .textAlign(TextAlign.Center)
              .onAreaChange((oldValue: Area, newValue: Area) => {
                this.text1Height = (newValue.height as number) || 0;
              })

            // Text2 - 占位符，用于计算原始位置
            Text("Text2 - 吸顶内容\n向上滑动时停留在顶部")
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .padding(20)
              .width('100%')
              .backgroundColor('#FFE1F5FF')
              .textAlign(TextAlign.Center)
              .id('text2')
              .onAreaChange((oldValue: Area, newValue: Area) => {
                this.text2Height = (newValue.height as number) || 0;
              })

            // List - 可滚动列表
            List() {
              ForEach(this.data, (item: number) => {
                ListItem() {
                  Text(`列表项 ${item}`)
                    .fontSize(16)
                    .padding(15)
                    .width('100%')
                    .backgroundColor(item % 2 === 0 ? '#FFF5F5F5' : '#FFFFFFFF')
                }
              })
            }
            .width('100%')
            .backgroundColor('#FFFFFFFF')
            .divider({ strokeWidth: 1, color: '#FFE0E0E0' })
          }
        }
        .scrollBar(BarState.On)
        .onScroll((xOffset: number, yOffset: number) => {
          this.scrollOffset = yOffset;
          // 计算 Text2 吸顶时的偏移
          // 当滚动距离 < Text1 高度时，不吸顶
          // 当滚动距离 >= Text1 高度时，Text2 上移的距离 = 滚动距离 - Text1 高度
          if (yOffset >= this.text1Height) {
            this.text2OffsetY = -(yOffset - this.text1Height);
          } else {
            this.text2OffsetY = 0;
          }
        })
        .width('100%')
        .layoutWeight(1)

        // 吸顶的 Text2（浮层）
        if (this.scrollOffset >= this.text1Height) {
          Text("Text2 - 吸顶内容\n向上滑动时停留在顶部111")
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .padding(20)
            .width('100%')
            .backgroundColor('#FFE1F5FF')
            .textAlign(TextAlign.Center)
            .offset({ y: this.text2OffsetY })
            .zIndex(10)
        }
      }
      .layoutWeight(1)
      .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}
