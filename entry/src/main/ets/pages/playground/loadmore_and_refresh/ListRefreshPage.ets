import { ActionBar } from '../../../comm/ActionBar';

const numbers: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];
@Entry
@ComponentV2
struct ListRefreshPage {
  @Local isRefreshing:boolean = false
  @Local data:number[]=numbers
  @Local refreshText:string ='继续下拉进行刷新'

  @Local hasMore:boolean = true
  @Local isLoading:boolean = false

  private scroller:Scroller = new Scroller()

  build() {
    Column() {
      ActionBar({title:"下拉刷新和上拉加载更多"})
      Refresh({refreshing:$$this.isRefreshing,promptText:this.refreshText}){
        List({space:20,scroller:this.scroller}){
          ForEach(this.data,(item:number,index:number)=>{
            ListItem(){
              Text(`第 ${index + 1} 个`).height(50)
            }
          })
          if(this.hasMore){
            ListItem(){
              Row(){
                Text('正在加载...').width("100%").padding(10).textAlign(TextAlign.Center)
              }
            }
          }
        }.onScrollIndex((start: number, end: number, center: number) =>{
          if(end >= this.data.length -1 && !this.isLoading && this.hasMore){
            this.isLoading =true
            setTimeout(()=>{
              this.isLoading =false
              this.data.push(...numbers)
              this.hasMore = false
            },2000)
          }
        }).onReachEnd(()=>{
          console.error("onReachEnd")
        })
        .onScrollFrameBegin((offset: number, state: ScrollState)=>{
          if(this.scroller.isAtEnd()){
            console.error("加载更多")
          }
          return {offsetRemain:offset}
        })
        .edgeEffect(EdgeEffect.Spring,{alwaysEnabled:true})

      }.onStateChange((refreshStatus: RefreshStatus) => {
        if(refreshStatus == RefreshStatus.Drag){
          this.refreshText = '继续下拉进行刷新'
        }else if(refreshStatus == RefreshStatus.OverDrag){
          this.refreshText = '松开刷新'
        }else if(refreshStatus == RefreshStatus.Refresh){
          this.refreshText = '刷新中'
        }
      })
      .onRefreshing(() => {
        setTimeout(() => {
          this.isRefreshing = false;
        }, 2000)

      })
      .layoutWeight(1)
      .width("100%")
    }
    .height('100%')
    .width('100%')
  }
}