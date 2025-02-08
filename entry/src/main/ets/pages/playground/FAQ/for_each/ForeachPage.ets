import ActionBar from '../../../../comm/ActionBar';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { systemDateTime } from '@kit.BasicServicesKit';
import { intl } from '@kit.LocalizationKit';

@Entry
@Component
struct ForeachPage {
  @State foreachModelList: ForeachModel[] = []
  aboutToAppear(): void {
    // this.initData()
  }

  initData() {
    this.foreachModelList = []
    for (let i = 0; i < 5; i++) {
      let model: ForeachModel = new ForeachModel()
      model.name = `第 ${i} 项`
      if (i == 1) {
        model.defaultSelect = true
      } else {
        model.defaultSelect = false
      }
      this.foreachModelList.push(model)
    }
  }

  build() {
    Column() {
      ActionBar({ title: '循环渲染' })


      Row() {
        Button('重新赋值').onClick((_) => {
          hilog.error(0x01, 'ForeachPage', '重新赋值开始')
          this.initData()
          hilog.error(0x01, 'ForeachPage', '重新赋值结束')
        })
        Button('改变最后一项的值').onClick((_) => {
          hilog.error(0x01, 'ForeachPage', '改变最后一项的值开始')
          let length = this.foreachModelList.length
          this.foreachModelList[length-1].name = '改变后的值'
          hilog.error(0x01, 'ForeachPage', '改变最后一项值结束')
        })


      }

      Row() {
        Button('添加一项').onClick((_) => {
          hilog.error(0x01, 'ForeachPage', '添加一项开始')
          let model: ForeachModel = new ForeachModel()
          model.name = `第 ${this.foreachModelList.length} 项`
          this.foreachModelList.push(model)
          hilog.error(0x01, 'ForeachPage', '添加一项结束')
        })
        Button('删除一项').onClick((_) => {
          hilog.error(0x01, 'ForeachPage', '删除一项开始')
          if (this.foreachModelList.length > 1) {
            this.foreachModelList.pop()
            hilog.error(0x01, 'ForeachPage', '删除一项结束')
          }
        })
      }

      Row() {
        Button('插入一个').onClick((_) => {
          let model: ForeachModel = new ForeachModel()
          let dateFormat1 = new intl.DateTimeFormat('zh-CN', { timeStyle: 'full' });
          let formattedDate1 = dateFormat1.format(new Date()); // formattedDate1: 2021年9月17日星期五 中国标准时间 13:04:00

          model.name = formattedDate1
          this.foreachModelList.splice(1, 0, model);
        })
      }

      List() {
        ForEach(this.foreachModelList, (model: ForeachModel) => {
          ListItem() {
            SimpleView({ model: model })
          }

        }, (item: ForeachModel) => {
          let key = item.name + '__' + item.defaultSelect;
          hilog.error(0x01, 'ForeachPage', key)
          return key
        })
      }.layoutWeight(1)

    }
    .height('100%')
    .width('100%')
  }
}

@Reusable
@Component
struct SimpleView {
  @Watch('onForeachModelChange') @ObjectLink model: ForeachModel

  onForeachModelChange() {
    hilog.error(0x01, 'ForeachPage', `onForeachModelChange`)
  }

  build() {
    Row() {
      Text(`${this.model.name} , select :${this.model.defaultSelect}`)
      Circle()
        .width(20)
        .height(20)
        .fill(this.model.defaultSelect ? Color.Red : Color.Gray)
        .stroke(this.model.defaultSelect ? Color.Red : Color.Grey)
      Checkbox().select($$this.model.defaultSelect).onChange((checked: boolean) => {
        hilog.error(0x01, 'ForeachPage', `checked ${JSON.stringify(this.model.name)}`)
      })
    }.padding({ top: 10, bottom: 10 })
  }
}

@Observed
class ForeachModel {
  name: string = ''
  defaultSelect: boolean = false
}