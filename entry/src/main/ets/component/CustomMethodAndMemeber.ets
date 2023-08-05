@Component
export struct MyComponent {
  @State message: string = "hello"
  public controller : MyComponentController = null;
  aboutToAppear(){
    if(this.controller){
      this.controller.setItem(this);
    }
  }

  build() {
    Text(this.message)
      .fontColor('#ff6134')
      .fontSize(20)
  }
}

export class MyComponentController {
  item: MyComponent = null;

  setItem(item: MyComponent) {
    this.item = item;
  }

  updateMessage(message: string) {
    this.item.message = message;
  }
}