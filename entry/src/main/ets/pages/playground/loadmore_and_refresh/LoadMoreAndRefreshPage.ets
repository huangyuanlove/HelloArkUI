import { ActionBar } from '../../../comm/ActionBar'
import { systemDateTime } from '@kit.BasicServicesKit';


const formatter = new Intl.DateTimeFormat('zh-CN', {
  year: 'numeric',
  month: '2-digit',
  day: '2-digit',
  hour: '2-digit',
  minute: '2-digit',
  second: '2-digit',
  hour12: false // 24小时制
});

const numbers: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];

enum State{
  Loading,
  Idle,
}

@Entry
@ComponentV2
struct LoadMoreAndRefreshPage {

  @Local currentState:State = State.Idle

  @Local lastRefreshTime: number = 0

  getLastRefreshTime(): string {
    if (this.lastRefreshTime <= 0) {
      return ''
    }
    return formatter.format(this.lastRefreshTime)
  }

  @Local lastLoadMoreTime: number = 0

  getLastLoadMoreTime(): string {
    if (this.lastLoadMoreTime <= 0) {
      return ''
    }
    return formatter.format(this.lastLoadMoreTime)
  }

  private needRefreshOnDidScroll: boolean = false
  @Local refreshEnable: boolean = true
  @Local headerTransitionY: number = 0
  @Local headerImageRotate: number = 0
  @Local headerMaxTransition: number = 0
  @Local headerText: string = '下拉刷新'
  private needLoadMoreOnDidScroll: boolean = false
  @Local loadmoreEnable: boolean = true
  @Local footerTransitionY: number = 0
  @Local footerMaxTransition: number = 0
  @Local footerText: string = '上拉加载更多'
  private scroller: Scroller = new Scroller()


  @LocalBuilder
  header() {
    Column() {
      Row() {
        Image($r('app.media.tab_guide_unselect')).width(20).height(20).rotate({
          centerX: "50%",
          centerY: "50%",
          angle: this.headerImageRotate
        })
        Blank().width(10).height(0)
        Text(`${this.headerText} ${this.getLastRefreshTime()}`)
      }.width("100%").alignItems(VerticalAlign.Center).justifyContent(FlexAlign.Center)

    }
    .width("100%")
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .height(60)
    .backgroundColor(Color.Red)
    .onAreaChange((_, newValue) => {
      this.headerMaxTransition = newValue.height as number
    })
    .position({ top: -this.headerMaxTransition })
  }

  @LocalBuilder
  footer() {
    Column() {
      Text(`${this.footerText} ${this.getLastLoadMoreTime()}`).height(60).backgroundColor(Color.Green)
    }.width("100%").onAreaChange((_, newValue) => {
      this.footerMaxTransition = newValue.height as number
    }).position({ bottom: -this.footerMaxTransition }).backgroundColor(Color.Orange)
  }

  build() {
    Column() {
      ActionBar({ title: "刷新和加载更多" }).zIndex(10)

      Stack() {
        Stack({ alignContent: Alignment.Top }) {
          if (this.refreshEnable) {
            this.header()
          }
        }.translate({
          y: this.headerTransitionY
        }).height('100%')


        Stack({ alignContent: Alignment.Bottom }) {
          if (this.loadmoreEnable) {
            this.footer()
          }
        }.translate({
          y: this.footerTransitionY
        }).height('100%')

        List({ space: 20, scroller: this.scroller }) {
          ForEach(numbers, (item: number, index: number) => {
            ListItem() {
              Text(`第 ${index + 1} 个项目`).width("100%").textAlign(TextAlign.Center).fontSize(18)
                .height(40)
            }.onClick((_) => {
              this.getUIContext().getPromptAction().showToast({ message: `点击了 ${item}` })
            })
          })
        }
        .edgeEffect(EdgeEffect.None)
        .translate({
          y: this.headerTransitionY || this.footerTransitionY
        })

      }.layoutWeight(1).clip(true)
      .priorityGesture(
        PanGesture({ direction: PanDirection.Vertical })
          .onActionStart((event: GestureEvent) => {
            this.lastScroll = event.offsetY
            console.error(`onActionStart ${this.lastScroll}}`)
          })
          .onActionUpdate((event: GestureEvent) => {
          let diff = event.offsetY - this.lastScroll
          this.lastScroll = event.offsetY
          console.error(`PanGesture diff-> ${diff}  ,velocity-> ${event.velocity} `)
          if (diff) {
            if (event.velocity) {
              if (diff > 0) {
                this.scroller.fling(event.velocity)
              } else {
                this.scroller.fling(-event.velocity)
              }

            }
            this.handleScroll(diff)
          }
        })
          .onActionEnd((event: GestureEvent) => {
          console.error(`PanGesture onActionEnd needRefreshOnDidScroll-> ${this.needRefreshOnDidScroll}  needLoadMoreOnDidScroll-> ${this.needLoadMoreOnDidScroll}`)
          if (event.velocityY) {
            this.scroller.fling(event.velocityY)
          }
          if (this.needRefreshOnDidScroll && this.currentState != State.Loading) {
            this.currentState = State.Loading
            this.headerText = '刷新中'
            this.needRefreshOnDidScroll = false

            setTimeout(() => {
              this.headerText = '刷新成功'
              this.currentState = State.Idle
              this.lastRefreshTime = systemDateTime.getTime()
              setTimeout(() => {
                this.headerTransitionY = -this.headerMaxTransition
                this.getUIContext().animateTo({
                  duration: 500,
                  curve: Curve.EaseOut,
                  iterations: 1,
                  playMode: PlayMode.Normal,
                  onFinish: () => {
                    console.error('刷新后恢复 play end');
                  }
                }, () => {
                  this.headerTransitionY = 0
                })

              }, 1000)
            }, 2000)
          } else {
            this.resetHeaderTransition()
          }
          if (this.needLoadMoreOnDidScroll  && this.currentState != State.Loading) {
            this.currentState = State.Loading
            this.getUIContext().animateTo({
              duration: 500,
              curve: Curve.EaseOut,
              iterations: 1,
              playMode: PlayMode.Normal,
              onFinish: () => {
                console.error('加载更多时刚好漏出完整的 footer');
              }
            }, () => {
              this.footerTransitionY = -this.footerMaxTransition

            })


            this.footerText = '加载中'
            this.needLoadMoreOnDidScroll = false

            setTimeout(() => {
              this.footerText = '加载成功'
              this.currentState = State.Idle
              this.lastLoadMoreTime = systemDateTime.getTime()

              setTimeout(() => {
                this.footerTransitionY = this.footerMaxTransition
                this.getUIContext().animateTo({
                  duration: 500,
                  curve: Curve.EaseOut,
                  iterations: 1,
                  playMode: PlayMode.Normal,
                  onFinish: () => {
                    console.error('加载更多后恢复 play end');
                    this.footerText = '上拉加载更多'
                  }
                }, () => {
                  this.footerTransitionY = 0

                })
              }, 1000)
            }, 2000)
          } else {
            this.resetFooterTransition()
          }

        }).onActionCancel(() => {
          console.error(`PanGesture onActionCancel`)

        }))
      .layoutWeight(1)

    }
    .height('100%')
    .width('100%')
  }

  resetHeaderTransition() {
    this.getUIContext().animateTo({
      duration: 500,
      curve: Curve.EaseOut,
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: () => {
        console.error('刷新后恢复 play end');
      }
    }, () => {
      this.headerTransitionY = 0
    })

  }

  resetFooterTransition() {
    this.getUIContext().animateTo({
      duration: 500,
      curve: Curve.EaseOut,
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: () => {
        console.error('刷新后恢复 play end');
      }
    }, () => {
      this.footerTransitionY = 0
    })
  }

  handleScroll(offset: number) {
    if (offset < 0) {
      //向上滑动
      if (this.scroller.isAtEnd()) {
        console.error(`列表在底部，继续上拉`)
        //列表滑动到底部，继续上拉，
        if (Math.abs(this.footerTransitionY) > this.footerMaxTransition) {
          this.footerTransitionY += (offset * 0.2)
          if(this.currentState != State.Loading){
            this.footerText = '松开后加载更多'
            this.needLoadMoreOnDidScroll = true
          }

        } else {

          this.footerTransitionY += (offset * 0.3)
          if(this.currentState != State.Loading){
            this.footerText = '上拉加载更多'
            this.needLoadMoreOnDidScroll = false
          }

        }
      } else {
        console.error(`列表不在底部，继续上拉`)
        if (this.headerTransitionY > 0) {
          this.headerTransitionY += (offset * 0.3)
          this.headerImageRotate -= (offset * 1.5)
        } else {
          this.headerTransitionY = 0
          this.scroller.scrollBy(0, -offset)
        }

      }
    } else {
      //向下滑动
      if (this.scroller.currentOffset().yOffset == 0) {
        //列表滑动到顶部，继续下拉需要去处理刷新
        this.headerTransitionY += (offset * 0.3)
        this.headerImageRotate += (offset * 1.5)
        if (Math.abs(this.headerTransitionY) >= this.headerMaxTransition) {
          this.headerTransitionY = this.headerMaxTransition
          if(this.currentState != State.Loading){
            this.headerText = '松开后刷新'
            this.needRefreshOnDidScroll = true
          }

        } else {
          if(this.currentState != State.Loading){
            this.headerText = '下拉刷新'
            this.needRefreshOnDidScroll = false
          }

        }
      } else {
        if (this.footerTransitionY > 0) {
          this.footerTransitionY -= (offset * 0.3)
        } else {
          this.footerTransitionY = 0
          this.scroller.scrollBy(0, -offset)
        }


      }
    }
  }

  private lastScroll: number = 0
}