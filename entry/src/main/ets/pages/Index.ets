import router from '@ohos.router'
import BasicKnowledgePage from './basic_knowledge/BasicKnowledgePage'


@Entry
@Component
struct Index {
  scroller: Scroller = new Scroller()

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
          BasicKnowledgePage()
        }.tabBar("指南")
        TabContent() {
          Column().width('100%').height('100%')
        }.tabBar("API")
        TabContent() {
          Column(){
            Button("手写签名").onClick(()=>{
              router.pushUrl({url:"pages/playground/SignatureWithCanvas"})
            })
          }.width('100%').height('100%').backgroundColor('#FFBF00').padding({top:48})
        }.tabBar("实验")
      }
    }
  }
}