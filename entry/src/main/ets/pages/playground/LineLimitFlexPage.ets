import { hilog } from '@kit.PerformanceAnalysisKit'

@Entry
@Component
struct LineLimitFlexPage {
  build() {
    Column() {
      CustomLayout({ builder: ColumnChildren ,hSpace:vp2px(10), vSpace:vp2px(6),maxLine:1}).width('100%')
        .backgroundColor(Color.Red)
      Text("自定义行数").fontColor(Color.Black).fontSize(20)
    }.backgroundColor(Color.Blue)
  }
}

const colors: string[] = ["#ff6134", "#1b91e0", "#39d167"]

@Builder
function ColumnChildren() {
  ForEach([1, 2, 3,4,5,6,7,8,9,10,11,12,13,14,15], (index: number) => { //暂不支持lazyForEach的写法
    Text('S' + index)
      .fontSize(30)
      .borderWidth(2).backgroundColor(colors[index%3])

  })
}

@Component
struct CustomLayout {
  hSpace: number = 0
  vSpace: number = 0
  maxLine: number = Number.MAX_VALUE

  @Builder
  doNothingBuilder() {
  };

  @BuilderParam builder: () => void = this.doNothingBuilder;
  @State startSize: number = 100;

  onMeasureSize(selfLayoutInfo: GeometryInfo, children: Array<Measurable>, constraint: ConstraintSizeOptions) {
    hilog.error(0x01, "LineLimitFlexPage",
      `onMeasureSize selfLayoutInfo: width-->${selfLayoutInfo.width}   height-->${selfLayoutInfo.height}`)
    hilog.error(0x01, "LineLimitFlexPage",
      `onMeasureSize constraint: minWidth-->${constraint.minWidth},maxWidth-->${constraint.maxWidth},   minHeight-->${constraint.minHeight}, maxHeight-->${constraint.maxHeight}`)

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
        totalWidth = result.width+ this.vSpace
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
    hilog.error(0x01,"LineLimitFlexPage",`onMeasureSize result--> width: ${result.width} ,height:${result.height}`)
    return result
  }

  onPlaceChildren(selfLayoutInfo: GeometryInfo, children: Array<Layoutable>, constraint: ConstraintSizeOptions) {
    hilog.error(0x01, "LineLimitFlexPage",
      `onPlaceChildren: selfLayoutInfo: width-->${selfLayoutInfo.width}   height-->${selfLayoutInfo.height}`)
    let startX = 0;
    let startY = 0;
    let lineCount = 1

    for(let i =0;i<children.length;i++){
      let child = children[i]
      let childWidth = child.measureResult.width;
      let childHeight = child.measureResult.height

      hilog.error(0x01, "LineLimitFlexPage", `第${i}个: childWidth-->${childWidth}   childHeight-->${childHeight}`)


      if (startX + childWidth > selfLayoutInfo.width) {
        startX = 0
        startY += childHeight + this.vSpace
        lineCount ++
        if(lineCount > this.maxLine){
          break
        }
      }
      hilog.error(0x01, "LineLimitFlexPage", `第${i}个layout: x-->${startX}   y-->${startY}`)
      child.layout({ x: startX, y: startY })
      startX += childWidth + this.hSpace

    }


  }

  build() {
    this.builder()
  }
}