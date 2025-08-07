import { emitter } from '@kit.BasicServicesKit';

@Entry
@Component
struct EventTwoPage {
  @State message: string = 'Hello World';



  emitterCallback: Callback<emitter.EventData> = (eventData: emitter.EventData) => {
    console.error(`EventTwoPage emitter 收到 EventHubEventOne: ${JSON.stringify(eventData)}`);
  }
  eventHubCallback(argOne: Context, argTwo: Context): void {
    console.error("EventTwoPage emitter 收到 EventHubEventOne")
  }

  aboutToAppear(): void {
    emitter.on("EmitterEventOne", this.emitterCallback)
    this.getUIContext().getHostContext()?.eventHub.on("EventHubEventOne", this.eventHubCallback)

  }

  aboutToDisappear(): void {
    emitter.off("EmitterEventOne",this.emitterCallback)
    this.getUIContext().getHostContext()?.eventHub.off("EventHubEventOne",this.eventHubCallback)
  }




  build() {
    RelativeContainer() {
      Text(this.message)
        .id('EventTwoPageHelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)

        .onClick(() => {
          this.message = 'Welcome';

          emitter.emit("EmitterEventOne")
          this.getUIContext().getHostContext()?.eventHub.emit("EventHubEventOne")


        })
    }
    .height('100%')
    .width('100%')
  }
}