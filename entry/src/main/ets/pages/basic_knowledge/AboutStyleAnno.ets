import ActionBar from '../../comm/ActionBar';
@Entry
@Component
struct AboutStyleAnno{

  @State heightValue:number = 100;

  @Styles fancy(){
    .width(200)
    .height(this.heightValue)
    .backgroundColor(Color.Yellow)
    .onClick(() => {
      console.log('需要变成200')
      this.heightValue = 200
    })
  }



  build(){
    Column({space:10}){
      ActionBar({ title: '@Style注解' })
      Text('globalFancy')
        .globalFancy ()
        .fontSize(30)
      Text('fancy，会被当前属性覆盖')
        .fancy()
        .fontSize(30)
        .onClick(()=>{
          console.log('需要变成400')
          this.heightValue =400
        })
    }
  }
}

@Styles function globalFancy(){
  .width(100)
    .height(100)
    .backgroundColor(Color.Pink)
}