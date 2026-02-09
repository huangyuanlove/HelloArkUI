import { KeyboardAvoidMode, window } from '@kit.ArkUI';
const more_function_list1:string[]=[
  '功能1',
  '功能2',
  '功能3',
  '功能4',

]
const more_function_list2:string[]=[

  '功能5',
  '功能6',
  '功能7',
  '功能8',
]

@Entry
@ComponentV2
struct ChatListKeyboardPage {
  @Local chatList:string[] = []
  @Local showSendButton:boolean =false
  @Local showMoreFunctionArea:boolean = false

  private keyboardHeight:number = 0
  @Local listOffset:number = 0
  aboutToAppear(): void {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.NONE)
    for(let i =0;i< 20 ;i++){
      this.chatList.push(`第 ${i} 个`)
    }
    try {
      window.getLastWindow(this.getUIContext().getHostContext()).then(currentWindow => {
        currentWindow.on('keyboardHeightChange', (data: number) => {
            this.keyboardHeight = this.getUIContext().px2vp(data);
            this.getUIContext().animateTo({
              duration: 500,
              curve: Curve.EaseOut,
              iterations: 1,
              playMode: PlayMode.Normal,
              onFinish: () => {
                console.error('刷新后恢复 play end');
              }
            }, () => {
              this.listOffset = this.keyboardHeight
            })


          console.error('键盘高度 ' + this.keyboardHeight)
        })
      })
    } catch (error) {
      let err = error as BusinessError;
      console.error( 'GetKeyboardHeightDemo'+
        `getLastWindow failed, error code=${err.code}, message=${err.message}`);
    }
  }


  build() {
    Column() {
      Text('会话页面').width('100%').textAlign(TextAlign.Center).padding({top:5,bottom:5}).expandSafeArea([SafeAreaType.KEYBOARD])
      List({space:20}){
        ForEach(this.chatList,(item:string,index:number)=>{
          ListItem(){
            if(index % 2 ==0){
              Row(){
                Text(item).backgroundColor(Color.White).borderRadius(8).padding(15)
              }.width("100%").justifyContent(FlexAlign.Start).padding({left:15})


            }else{
              Row(){
                Text(item).backgroundColor(Color.White).borderRadius(8).padding(15)
              }.width('100%').padding({right:15}).justifyContent(FlexAlign.End)


            }

          }.width('100%')
        })
      }.layoutWeight(1).width("100%").backgroundColor("#f1f1f1")
      .translate({
        y: this.keyboardHeight
      })
      Row(){
          TextInput().layoutWeight(1).onChange((value)=>{
            this.showSendButton = value.length >0
          })
          if(this.showSendButton){
            Button('发送')
          }else{
            Button('+').onClick((_)=>{
              this.showMoreFunctionArea = !this.showMoreFunctionArea
            })
          }
      }.width("100%").padding({top:10,bottom:10})
      if(this.showMoreFunctionArea){
        this.moreFunction()
      }
    }

    .height('100%')
    .width('100%')
  }

  @LocalBuilder
  moreFunction(){
    Column(){
      Row(){
        ForEach(more_function_list1,(item:string,index:number)=>{
            Text(item).textAlign(TextAlign.Center)
              .layoutWeight(1).aspectRatio(1)
        })
      }
      Row(){
        ForEach(more_function_list2,(item:string,index:number)=>{
            Text(item).textAlign(TextAlign.Center)
          .layoutWeight(1).aspectRatio(1)
        })
      }
    }
  }
}