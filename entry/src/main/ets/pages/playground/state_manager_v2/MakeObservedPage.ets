import { UIUtils } from '@kit.ArkUI'
import { hilog } from '@kit.PerformanceAnalysisKit'

@Entry
@Component
struct MakeObservedPage {
  @State chatModel: ChatModel = new ChatModel()

  aboutToAppear(): void {
    this.reload()
  }

  loadMore() {
    for (let i = 0; i < 6; i++) {
      let chatItem: MediaChatItem ={

      } as MediaChatItem
      chatItem.isSelf = (i % 2 == 0)
      chatItem.duration = Math.floor(Math.random() * 100)
      chatItem.currentPosition = Math.floor(Math.random() * chatItem.duration)
      this.chatModel.chatList.push(UIUtils.makeObserved( chatItem))
    }
    hilog.error(0x01,'MakeObservedPage',`长度：${this.chatModel.chatList.length}`)
  }

  reload() {
    this.chatModel.chatList = []
    this.loadMore()
  }

  build() {
    Column() {
      Row() {
        Button('修改进度').onClick((_) => {
          this.chatModel.chatList.forEach((item: MediaChatItem) => {
            item.currentPosition = Math.floor(Math.random() * item.duration)
          })
        }).margin(6)
        Button('刷新').onClick((_) => {
          this.reload()
        }).margin(6)
        Button('加载更多').onClick((_) => {
          this.loadMore()
        }).margin(6)
      }

      List() {
        ForEach(this.chatModel.chatList, (mediaChatItem: MediaChatItem, index: number) => {
          ListItem() {
            ChatItemView({mediaChatItem:mediaChatItem})
          }
          .margin({
            top: 10,
            bottom: 10,
            left: mediaChatItem.isSelf ? 70 : 15,
            right: mediaChatItem.isSelf ? 15 : 70
          })
          .padding(10)
          .borderRadius(6)
          .borderWidth(1)
          .borderColor(mediaChatItem.isSelf ? Color.Pink : Color.Green)
        })
      }
      .divider({
        strokeWidth: 2,
        color: 0xFFFFFF,
        startMargin: 20,
        endMargin: 20
      })
    }
    .height('100%')
    .width('100%')
  }
}

@Component
struct ChatItemView{
  @ObjectLink mediaChatItem:MediaChatItem
  build() {
    Progress({ value: this.mediaChatItem.currentPosition, total: this.mediaChatItem.duration, type: ProgressType.Linear })
  }
}

@Observed
class MediaChatItem {
   isSelf: boolean = false
   id: number = -1
   duration: number = -1
   currentPosition: number = -1
}

@Observed
class ChatModel {
   conversationID: string = ''
   chatList: MediaChatItem[] = []
}