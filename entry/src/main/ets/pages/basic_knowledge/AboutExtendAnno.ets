import ActionBar from '../../comm/ActionBar';
@Entry
@Component
struct AboutExtendAnno{

  @State label:string = 'hello @Extend()'
  @State fontSize:number = 20;
  onClickHandle(){
    this.label = 'hello ArkUI'
  }

  build(){
    Column(){
      ActionBar({ title: '@Extends装饰器' })
      Text('@Extends 基础用法').superFancyText(20)
      Text(`hello ${this.label}`)
      Text('@Extend装饰的方法的参数可以为function，作为Event事件的句柄。').makeMeClick(this.onClickHandle.bind(this))
      Text('@Extend的参数可以为状态变量，当状态变量改变时，UI可以正常的被刷新渲染。').changeFontSize(this.fontSize).onClick(()=>{
        this.fontSize = 30
      })



    }
    .height('100%')

  }
}

@Extend(Text) function changeFontSize(fontSize:number){
  .fontSize(fontSize)
  .fontColor(Color.Red)
}

@Extend(Text) function makeMeClick(onClick:()=>void){
  .backgroundColor(Color.Brown)
  .onClick(onClick)
}


@Extend(Text) function fancy (){
  .fontColor(Color.Yellow)
}

@Extend(Text) function superFancyText(fontSize:number){
  .fontSize(fontSize)
  .fontColor(Color.Green)
  .fancy()
  .fontColor(Color.Red)
  .padding(10)
  .margin(10)
}

