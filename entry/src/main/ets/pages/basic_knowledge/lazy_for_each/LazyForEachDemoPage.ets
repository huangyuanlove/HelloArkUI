
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
          LazyForEach(this.data,(item:string)=>{
            ListItem(){
              DemoItem({item:item})
            }.padding(10)
          })
        }.layoutWeight(1)

        List({space:4}){
          ForEach(this.dataString,(item:string)=>{
            ListItem(){
              DemoItem({item:item})
            }.padding(10)
          })
        }.layoutWeight(1)
      }

    }
    .height('100%')
    .width('100%')
  }
}

@Component
struct DemoItem{
  @Prop item:string

  aboutToAppear(): void {
    console.error(`DemoItem ${this.item} aboutToAppear`)
  }

  aboutToDisappear(): void {
    console.error(`DemoItem ${this.item} aboutToDisappear`)
  }

  build(){
    Text(this.item)
  }
}