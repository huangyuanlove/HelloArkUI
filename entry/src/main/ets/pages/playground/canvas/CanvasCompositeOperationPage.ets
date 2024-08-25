import { CompositeOperationView } from './CompositeOperationView'

@Entry
@Component
struct CanvasCompositeOperationPage{
  compositeOperation:string[]=["source-over","source-in","source-out","source-atop","destination-over","destination-in","destination-out","destination-atop","lighter","copy","xor"]
  build() {
    Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, }){
      ForEach(this.compositeOperation,(item:string)=>{
        Column(){
          Text(item)
          CompositeOperationView({compositeOperation:item}).width("100%").height("80%")
        }.width("30%").height("20%")
      })
    }
  }
}

