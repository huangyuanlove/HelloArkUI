import { ActionBar } from '../../../comm/ActionBar'
import { JSON } from '@kit.ArkTS'

@Entry
@ComponentV2
struct ListDragPage {
  @Local numberData: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17]

  build() {
    Column() {
      ActionBar({ title: "列表拖拽排序" })
      Column() {
        List({ space: 20 }) {
          ForEach(this.numberData, (item: string) => {
            ListItem(){
              Text(`${item}`)
                .width('100%')
                .height(80)
                .textAlign(TextAlign.Center)
                .backgroundColor(Color.White)
                .fontColor(Color.Black)
            } .borderRadius(8)

          }, (item: number) => item.toString())
            .onMove((from: number, to: number) => {
              let tmp = this.numberData.splice(from, 1);
              this.numberData.splice(to, 0, tmp[0]);
            })
        }.width('100%').height(500)

      }.width('100%').padding(20).layoutWeight(1)


      Button('打印数据').onClick((_) => {
        console.error(`${JSON.stringify(this.numberData)}`)
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#FFDCDCDC')

  }
}