@Component
export struct MyComponent {
  @State message: string = "hello"
  public controller?: MyComponentController = undefined;

  aboutToAppear() {
    if (this.controller) {
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
  item?: MyComponent = undefined;

  setItem(item: MyComponent) {
    this.item = item;
  }

  updateMessage(message: string) {
    if (this.item) {
      this.item.message = message;
    }
  }
}