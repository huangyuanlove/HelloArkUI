import BasicKnowledgePage from './basic_knowledge/BasicKnowledgePage'
import { PlayGroundIndex } from './playground/PlayGroundIndex'
import { promptAction } from '@kit.ArkUI'
import BuildProfile from 'BuildProfile'


@Entry
@Component
struct Index {
  scroller: Scroller = new Scroller()

  private tabText:string[] =["指南","实验"]

  private tabSelectIcon:Resource[] =[$r("app.media.tab_guide_select"),$r("app.media.tab_playground_select"),]
  private tabUnselectIcon:Resource[] =[$r("app.media.tab_guide_unselect"),$r("app.media.tab_playground_unselect"),]

  @State currentIndex:number = 0


  aboutToAppear(): void {

  }

  @Builder
  tabBar(index:number){
    Column(){
      Divider().vertical(false).color(0x999999).height(1).width("100%")
      Blank().height(4)
      Image( index==this.currentIndex?this.tabSelectIcon[index]:this.tabUnselectIcon[index] ).width(24).height(24)
      Text(this.tabText[index]).fontColor(index==this.currentIndex?0x1296db:0x515151)
    }.layoutWeight(1)
  }


  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
          BasicKnowledgePage()
        }.tabBar(this.tabBar(0))
        TabContent() {
          PlayGroundIndex().width('100%').height('100%')
        }.tabBar(this.tabBar(1))

      }.onChange((index)=>{
        this.currentIndex = index
      })
    }
  }
}