@Component
export struct HelloComponent{
  @State message:string = "hello"
  @State count:Number = 0;
  build(){

    Row(){
    Text(this.message)
      .onClick(()=>{
        this.message = `you had click for ${this.count} times`
      })
      .fontColor('#999999')
      .fontSize(14)
      .fontWeight(FontWeight.Regular)
    }

  }
}
