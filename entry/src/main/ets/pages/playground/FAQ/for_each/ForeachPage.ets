import ActionBar from '../../../../comm/ActionBar';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { systemDateTime } from '@kit.BasicServicesKit';

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
          hilog.error(0x01,'ForeachPage','重新赋值开始')
          this.initData()
          hilog.error(0x01,'ForeachPage','重新赋值结束')
        })
        Button('改变最后一项的值').onClick((_) => {
          hilog.error(0x01,'ForeachPage','改变最后一项的值开始')
          let length = this.foreachModelList.length
          this.foreachModelList[length-1].name = '改变后的值'
          hilog.error(0x01,'ForeachPage','改变最后一项值结束')
        })


      }
      Row(){
        Button('添加一项').onClick((_) => {
          hilog.error(0x01,'ForeachPage','添加一项开始')
          let model: ForeachModel = new ForeachModel()
          model.name = `第 ${this.foreachModelList.length} 项`
          this.foreachModelList.push(model)
          hilog.error(0x01,'ForeachPage','添加一项结束')
        })
        Button('删除一项').onClick((_) => {
          hilog.error(0x01,'ForeachPage','删除一项开始')
          if (this.foreachModelList.length > 1) {
            this.foreachModelList.pop()
            hilog.error(0x01,'ForeachPage','删除一项结束')
          }
        })
      }

      ForEach(this.foreachModelList, (model: ForeachModel) => {
        SimpleView({ model: model })
      }, (item: ForeachModel, index: number) => {
        let key = index + '__' + item.name + '__' + item.defaultSelect;
        hilog.error(0x01, 'ForeachPage', key)
        return key
      })

    }
    .height('100%')
    .width('100%')
  }
}

@Component
struct SimpleView {
 @Watch('onForeachModelChange')  @ObjectLink model: ForeachModel

  onForeachModelChange(){
    hilog.error(0x01, 'ForeachPage', `onForeachModelChange`)
  }

  build() {
    Row() {
      Text(this.model.name)
      Checkbox().select(this.model.defaultSelect).onChange((checked: boolean) => {
        this.model.defaultSelect = checked
        hilog.error(0x01, 'ForeachPage', `checked ${JSON.stringify(this.model.name)}`)
      })
    }
  }
}

@Observed
class ForeachModel {
  name: string = ''
  defaultSelect: boolean = false
}