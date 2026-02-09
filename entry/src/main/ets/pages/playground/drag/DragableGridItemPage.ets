import { GridDataSource } from './GridDataSource';
@Entry
@Component
struct DragableGridItemPage {
  dataList: GridDataSource<MyData> = new GridDataSource([]);


  private draggedItemIndex:number = -1
  private targetItemIndex:number = -1


  aboutToAppear(): void {
    let list: MyData[] = [];
    for (let index = 0; index < 10; index++) {
      let tmp:MyData = new MyData(index.toString(),true)
      list.push(tmp);
    }
    this.dataList = new GridDataSource(list);
  }

  changeIndex(from: number, to: number) { // 交换数组位置
    console.info('changeIndex from -> ' +from + ' to->' + to);
    this.dataList.change(from,to)

  }
  build() {
    Column({ space: 5 }) {
      Grid() {
        LazyForEach(this.dataList, (item: MyData, index: number) => {
          GridItem() {
            Text(item.text)
              .fontSize(16)
              .backgroundColor(0xF9CF93)
              .width('100%').aspectRatio(1)
              .borderRadius(8)
              .textAlign(TextAlign.Center)

          }
          .visibility(item.visible?Visibility.Visible:Visibility.Hidden)
          .width(90)
          .height(90)
          .selectable(true)
          .selected(true)
          .allowDrop([])
          .onDragStart((event: DragEvent) => {
            this.draggedItemIndex = index
            console.error("开始拖动--> " + index)
            return { extraInfo: index + '' };
          })
          .onDragEnter((event: DragEvent, extraParams?: string) => {
            console.error(`将 ${this.draggedItemIndex} 拖动到了 ${index}`)
            this.changeIndex(this.draggedItemIndex, index);
            this.draggedItemIndex = index

          })
          .onDragEnd((event: DragEvent, extraParams?: string) => {
            console.info('onDragEnd index-> ' + index + ' extraParams: ' + extraParams);
          })
          .onDrop((event?: DragEvent, extraParams?: string) => {
            console.info('onDrop: item-> ' + item + ' extraParams' + extraParams + JSON.stringify(event!));


          })
        }, (item: MyData, index: number) =>{
          let key = item.text +' ' +item.visible
          console.error(`${index} key is ${key}`)
          return key}   )
      }
      .columnsGap(5)
      .rowsGap(5)
      .columnsTemplate('1fr 1fr 1fr 1fr')
    }
    .width('100%')
  }

  changeVisible(index:number,visible:boolean){
    this.dataList.getData(index).visible = visible
    this.dataList.notifyDataChange(index)
  }

}


class MyData{
  text:string
  visible:boolean

  constructor(text: string, visible: boolean) {
    this.text = text;
    this.visible = visible;
  }

}