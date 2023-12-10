import common from '@ohos.app.ability.common'
import ActionBar from '../../../comm/ActionBar'
@Entry
@Component
struct AboutStateAnnoPage {

  url= 'https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/arkts-state-0000001474017162-V3?catalogVersion=V3'

  build() {
    Column(){

      ActionBar({ title: '@State' })

      Button('@State装饰器：组件内状态').onClick(()=>{
        let want = {
          // uncomment line below if wish to implicitly query only in the specific bundle.
          // bundleName: "com.example.myapplication",
          "action": "ohos.want.action.viewData",
          // entities can be omitted.
          "entities": [ "entity.system.browsable" ],
          "uri": this.url,
        }
        let context = getContext(this) as common.UIAbilityContext;
         context.startAbility(want)
        console.info(`explicit start ability succeed`)
      })    .backgroundColor(Color.Gray)
        .margin(10)
        .borderRadius(10)
        .height(30)

    // 此处指定的参数都将在初始渲染时覆盖本地定义的默认值，并不是所有的参数都需要从父组件初始化
    AboutStateAnno({ count: 1, increaseBy: 2 }).backgroundColor(Color.Brown)
    AboutStateAnno({ titleModel: new Model('Hello, World 2'), count: 7 })
    }  .height('100%')
    .width('100%')
  }
}


class Model {
  public value: string;

  constructor(value: string) {
    this.value = value;
  }
}

@Component
struct AboutStateAnno {
  @State titleModel: Model = new Model("Hello world");
  @State count: number = 0;
  private increaseBy: number = 1;

  build() {
    Column() {
      Text(`${this.titleModel.value}`).fontColor(Color.White)
      Button('click to change message').onClick(() => {
        // @State变量的更新将触发上面的Text组件内容更新
        this.titleModel.value = this.titleModel.value === 'Hello ArkUI' ? 'Hello World' : 'Hello ArkUI';
      }).margin(10)
      Button(`Click to increase count=${this.count}`).onClick(() => {
        // @State变量的更新将触发该Button组件的内容更新
        this.count += this.increaseBy;
      }).margin(10)
    }.margin(10).borderRadius(10).backgroundColor(Color.Gray).padding(10)
  }
}