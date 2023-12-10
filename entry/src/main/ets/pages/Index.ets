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
          Column().width('100%').height('100%').backgroundColor('#FFBF00')
        }.tabBar("实验")
      }
    }
  }
}