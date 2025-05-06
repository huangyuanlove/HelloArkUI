import { hilog } from '@kit.PerformanceAnalysisKit'
import { promptAction } from '@kit.ArkUI'

@Entry
@ComponentV2 //修改为V2
struct ForeachPage {
  @Local couponDataList: CouponData[] = [] //修改为V2

  aboutToAppear(): void {
    this.initData()
  }

  initData() {

    this.couponDataList = []
    for (let i = 0; i < 5; i++) {
      let model: CouponData = new CouponData()
      model.id = i.toString()
      model.name = `优惠券 ${i + 1} 项`


      if (i == 1) {
        model.defaultSelect = true
      } else {
        model.defaultSelect = false
      }

      this.couponDataList.push(model)
    }

  }

  build() {
    Column() {
      Button("刷新").onClick((_) => {
        this.initData()
      })
      List() {
        ForEach(this.couponDataList, (model: CouponData) => {
          ListItem() {
            CouponView({
              model: model, onChangeSelect: (id: string, select: boolean) => {
                hilog.error(0x01, 'ForeachPage', `onChangeSelect ${id} ${select}`)
                this.couponDataList.forEach((data: CouponData) => {
                  if (data.id == id) {
                    data.defaultSelect = select
                  } else {
                    if (select) {
                      data.defaultSelect = false;
                    }
                  }
                })
              }
            })
          }

        }, (item: CouponData, index: number) => {
          let key = item.id + "__" + item.defaultSelect
          hilog.error(0x01, 'ForeachPage', key)
          return key
        })
      }.layoutWeight(1)

      Button("确定").onClick((_) => {
        let selectCouponID: string = '未选中';
        this.couponDataList.forEach((couponData: CouponData) => {
          if (couponData.defaultSelect) {
            selectCouponID = couponData.id
          }
        })
        promptAction.showToast({ message: `选中的优惠券是 ${selectCouponID}` })
      })

    }
    .height('100%')
    .width('100%')
  }
}


@ComponentV2   //修改为V2
struct CouponView {
  @Require @Param model: CouponData   //修改为V2
  @Event //修改为V2
  onChangeSelect: (id: string, select: boolean) => void = (id: string, select: boolean) => {
  }
  aboutToAppear(): void {
    hilog.error(0x01, 'ForeachPage', `aboutToAppear ${this.model.id}`)
  }

  build() {
    Row() {
      Text(`${this.model.name} , select :${this.model.defaultSelect}`)
      Circle()
        .width(20)
        .height(20)
        .fill(this.model.defaultSelect ? Color.Red : Color.Gray)
        .stroke(this.model.defaultSelect ? Color.Red : Color.Grey)

    }.padding({ top: 10, bottom: 10 }).onClick((_) => {
      this.onChangeSelect(this.model.id, !this.model.defaultSelect)

    })
  }
}

@ObservedV2 //修改为V2
class CouponData {
  id: string = ''
  @Trace name: string = '' //修改为V2
  @Trace defaultSelect: boolean = false //修改为V2
}

