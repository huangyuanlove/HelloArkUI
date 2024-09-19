import { hilog } from '@kit.PerformanceAnalysisKit'

@Entry
@Component
struct LineLimitFlexPage {
  @State maxLine: number = 2
  @State showAll: boolean = false

  build() {
    Column() {

      CustomLayout({
        builder: ColumnChildren,
        hSpace: vp2px(6),
        vSpace: vp2px(4),
        maxLine: this.maxLine,
        showAll: this.showAll
      }).onClick((_) => {
        if (this.showAll) {
          this.maxLine = 2
        } else {
          this.maxLine = Number.MAX_VALUE
        }
        this.showAll = !this.showAll
      }
      )}
  }
}

const colors: string[] = ["#ff6134", "#1b91e0", "#39d167"]
const tag:string[]= ["明月", "星光", "北极光", "创新者", "晨曦", "悠然见南山", "科技创业者", "一缕阳光", "夜静春山空", "落英缤纷"]
@Builder
function ColumnChildren() {
  ForEach([0,1, 2, 3, 4, 5, 6, 7, 8, 9], (index: number) => { //暂不支持lazyForEach的写法
    Text(tag[index])
      .fontSize(20)
      .borderWidth(2).backgroundColor(colors[index%3])

  })
}

@Component
struct CustomLayout {
  hSpace: number = 0
  vSpace: number = 0
  @Prop maxLine: number
  @Prop showAll: boolean

  @Builder
  doNothingBuilder() {
  };

  @BuilderParam builder: () => void = this.doNothingBuilder;

  onMeasureSize(selfLayoutInfo: GeometryInfo, children: Array<Measurable>, constraint: ConstraintSizeOptions): SizeResult {
    hilog.error(0x01, "LineLimitFlexPage", `onMeasureSize selfLayoutInfo: ${JSON.stringify(selfLayoutInfo)}`)
    hilog.error(0x01, "LineLimitFlexPage", `onMeasureSize constraint: ${JSON.stringify(constraint)}`)

    let totalWidth = 0
    let totalHeight = 0
    let lineHeight = 0;
    let firstLineHeight = 0
    let lineCount = 1
    for (let i = 0; i < children.length; i++) {

      let child = children[i]
      //测量当前控件的宽高
      let result: MeasureResult = child.measure({
        minHeight: 0,
        minWidth: 0,
        maxWidth: selfLayoutInfo.width,
        maxHeight: selfLayoutInfo.height
      })
      //累计当前行宽度
      totalWidth += result.width
      //记录当前行的最大高度
      lineHeight = Math.max(lineHeight, result.height)


      if (totalWidth > selfLayoutInfo.width) {
        //记录一下第一行高度
        if (firstLineHeight == 0) {
          firstLineHeight = lineHeight;
        }
        //如果加上当前控件超过了父控件宽度，则换行
        lineCount++
        if (lineCount > this.maxLine) {
          break;
        }
        totalHeight += lineHeight + this.vSpace
        totalWidth = result.width + this.vSpace
        lineHeight = 0
      } else {
        //如果加上当前控件没有超过父控件宽度，加上水平间距
        totalWidth += this.hSpace
      }


    }

    let result: SizeResult = {
      width: lineCount > 1 ? selfLayoutInfo.width : totalWidth,
      height: totalHeight + firstLineHeight
    };
    return result
  }

  onPlaceChildren(selfLayoutInfo: GeometryInfo, children: Array<Layoutable>, constraint: ConstraintSizeOptions) {
    hilog.error(0x01, "LineLimitFlexPage", `onPlaceChildren: selfLayoutInfo: ${JSON.stringify(selfLayoutInfo)}`)
    hilog.error(0x01, "LineLimitFlexPage", `onPlaceChildren: constraint: ${JSON.stringify(constraint)}`)
    let startX = 0;
    let startY = 0;
    let lineCount = 1

    for (let i = 0; i < children.length; i++) {
      let child = children[i]
      let childWidth = child.measureResult.width;
      let childHeight = child.measureResult.height


      if (startX + childWidth > selfLayoutInfo.width) {
        startX = 0
        startY += childHeight + this.vSpace
        lineCount++
        if (lineCount > this.maxLine) {
          break
        }
      }
      child.layout({ x: startX, y: startY })
      startX += childWidth + this.hSpace

    }
  }

  build() {
    if (this.showAll ) {
      this.builder()
    }else{
      this.builder()
    }
  }
}