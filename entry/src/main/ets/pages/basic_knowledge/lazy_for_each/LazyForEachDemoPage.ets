
import { ActionBar } from '../../../comm/ActionBar';
import { DemoDataSource } from './MyDataSource';

@Entry
@Component
struct LazyForEachDemoPage {
  private data: DemoDataSource = new DemoDataSource();


  @State dataString:string[] =[]

  aboutToAppear(): void {
    for(let i = 0;i<30;i++){
      this.data.pushData(`第 ${i+1} 项`)
      this.dataString.push(`foreach 第 ${i+1} 项`)
    }
  }

  build() {
    Column() {
     ActionBar({title:"LazyForEach demo"})
      Row(){
        List({space:4}){
          LazyForEach(this.data,(item:string,index:number)=>{
            ListItem(){
              DemoItem({item:item,onClickDelete:()=>{
                this.data.deleteDataByIndex(index)
                this.data.notifyDataReload()
              }})
            }.padding(10)
          }, (item: string, index: number) => item + index.toString())
        }.layoutWeight(1)

        List({space:4}){
          ForEach(this.dataString,(item:string,index:number)=>{
            ListItem(){
              DemoItem({item:item,onClickDelete:()=>{
                console.error(`delete index ${index}`)
                this.dataString.splice(index,1)
              }})
            }.padding(10)
          }, (item: string, index: number) => {
            let key = item + index.toString()
            console.error(`foreach ${index} key : ${key}`)
            return key
          })
        }.layoutWeight(1)
      }.alignItems(VerticalAlign.Top)

    }
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .width('100%')
  }
}

@Component
struct DemoItem{
  @Prop item:string
  onClickDelete:()=>void = ()=>{}

  aboutToAppear(): void {
    console.error(`DemoItem ${this.item} aboutToAppear`)
  }

  aboutToDisappear(): void {
    console.error(`DemoItem ${this.item} aboutToDisappear`)
  }

  build(){
    Row(){
      Text(this.item).layoutWeight(1)
      Button("delete").onClick(()=>{
        this.onClickDelete()
      })
    }

  }
}