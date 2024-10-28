import ActionBar from '../../../../comm/ActionBar';
import { ForeachModel } from './ForEachMode';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { systemDateTime } from '@kit.BasicServicesKit';

@Entry
@Component
struct ForeachPage {
  @State message: string = 'Hello World';

  @State foreachModelList:ForeachModel[]=[]


  refresh_time:number = 0

  aboutToAppear(): void {
this.initData()


  }
  initData(){
    this.refresh_time = systemDateTime.getTime()
    this.foreachModelList =[]
    for(let i=0;i<5;i++){
      let model:ForeachModel = new ForeachModel()
      model.name = `第 ${i} 项`
      if(i== 1){
        model.defaultSelect = true
      }else{
        model.defaultSelect = false
      }
      this.foreachModelList.push(model)
    }

  }



  build() {
    Column(){
      ActionBar({title:'循环渲染'})
      Row(){
        Button('重新赋值').onClick((_)=>{
          this.initData()
        })
        Button('添加一项').onClick((_)=>{
          let model:ForeachModel = new ForeachModel()
          model.name = `第 ${this.foreachModelList.length} 项`
          this.foreachModelList.push(model)
        })

      }

      ForEach(this.foreachModelList,(model:ForeachModel)=>{
        Row(){
          Text(model.name)
          Checkbox().select(model.defaultSelect).onChange((checked:boolean)=>{
            model.defaultSelect = checked
            hilog.error(0x01,'ForeachPage',`checked ${JSON.stringify(this.foreachModelList)}`)

          } )
        }
      },(item:ForeachModel,index:number)=>{
        //ForEach提供了一个名为keyGenerator的参数，这是一个函数，开发者可以通过它自定义键值的生成规则。如果开发者没有定义keyGenerator函数，则ArkUI框架会使用默认的键值生成函数，即(item: Object, index: number) => { return index + '__' + JSON.stringify(item); }。
        let key = index + '__' + JSON.stringify(item) +"__" + this.refresh_time;
        hilog.error(0x01,'ForeachPage',`key ${key}`)
        return   key
      })
    }
    .height('100%')
    .width('100%')
  }
}