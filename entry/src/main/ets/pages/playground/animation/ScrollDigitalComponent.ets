@Component
export struct ScrollDigitalComponent {
  private dataItem: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  private currentData: number[] = new Array(10).fill(0);
  private preData: number[] = new Array(10).fill(0);
  @State scrollYList: number[] = [];

  refresh(): void {
    const tempArr: number[] = [];
    for (let i = 0; i < 10; i++) {
      tempArr.push(Math.floor(Math.random() * 10));
    }
    this.currentData = tempArr;
    this.currentData.forEach((item: number, index: number) => {
      this.getUIContext().animateTo({
        duration: Math.abs(item - this.preData[index]) * 200,
        curve: Curve.LinearOutSlowIn,
        onFinish: () => {
          this.preData = this.currentData;

        }
      }, () => {
        this.scrollYList[index] = -item * 26
      });
    });


  }

  build() {
    Row() {
      ForEach(this.currentData, (value: number, dataIndex: number) => {
        Column() {
          ForEach(this.dataItem, (subItem: number, index: number) => {
            Text(subItem.toString())
              .fontColor(Color.Orange)
              .fontWeight(FontWeight.Bold)
              .height("100%")
              .textAlign(TextAlign.Center)
              .translate({
                x: 0,
                y: this.scrollYList[dataIndex]
              })
          },(item: number) => JSON.stringify(value))
        }

      })
      Blank().layoutWeight(1)
      Button("刷新").fontColor(Color.White).buttonStyle(ButtonStyleMode.NORMAL).onClick((_) => {
        this.refresh()
      })
    }.width("100%").clip(true)

  }
}