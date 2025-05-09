import { ActionBar } from  '../../../comm/ActionBar';
@Entry
@Component
struct AboutLinkAnno{

  @State totalCount:number =0;
  build(){
    Column(){
      ActionBar({ title: '@Link' })
      Text(`总点击数量--> ${this.totalCount}`)
        .onClick(()=>{
          this.totalCount++
        })

      Item({countNumber:$totalCount}).margin(10)
      Divider()
      Item({countNumber:$totalCount}).margin(10)
      Divider()
      Item({countNumber:$totalCount}).margin(10)


    }.width('100%').height('100%')
  }
}

@Component
struct Item{
  @Link countNumber:number;


  build(){
      Counter(){
        Text(this.countNumber.toString())
      }.onInc(()=>{
        this.countNumber ++
      }).onDec(()=>{
        this.countNumber --
      })
  }
}