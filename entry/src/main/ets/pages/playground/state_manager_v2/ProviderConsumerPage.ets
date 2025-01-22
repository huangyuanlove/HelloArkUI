@Entry
@ComponentV2
struct ProviderConsumerPage {
  @Provider() str: string = 'hello';



  @Local childX: number = 0;
  @Local childY: number = 1;
  @Provider() onDrag: (x: number, y: number) => void = (x: number, y: number) => {
    console.log(`onDrag event at x=${x} y:${y}`);
    this.childX = x;
    this.childY = y;
  }



  @Provider() val: number = 10;


  build() {
    Column() {
      Button(this.str)
        .onClick(() => {
          this.str += '0';
        })
      Child()

      Divider().height(20)
      Column(){
        Text(`child position x: ${this.childX}, y: ${this.childY}`)
        ProviderFunction()
      }.margin(10).borderRadius(2).backgroundColor("#aa6357")

      Column(){
        Text('@Provider和@Consumer初始化@Param')
        Text('点击Text(`Parent @Consumer val: $\{this.val}`)，触发@Consumer() val的变化，变化同步给Index中@Provider() val，从而触发子组件Text(Parent @Param val2: $\{this.val2})的刷新。\n' +
          'Parent @Consumer() val的变化也会同步给Child，触发Text(Child @Param val $\{this.val})的刷新。').width('100%')
        Parent({ val2: this.val })
      }.borderRadius(6).margin(10)

    }
    .height('100%')
    .width('100%')
  }
}

@ComponentV2
struct Child {
  @Consumer() str: string = 'world';

  build() {
    Column() {
      Button(this.str)
        .onClick(() => {
          this.str += '0';
        })
    }
  }
}

@ComponentV2
struct ProviderFunction {
  @Consumer() onDrag: (x: number, y: number) => void = (x: number, y: number) => {};

  build() {
    Button("changed")
      .draggable(true)
      .onDragStart((event: DragEvent) => {
        // 当前预览器上不支持通用拖拽事件
        this.onDrag(event.getDisplayX(), event.getDisplayY());
      })
      .onDragMove((event:DragEvent)=>{
        this.onDrag(event.getDisplayX(), event.getDisplayY());
      })
  }
}


@ComponentV2
struct Parent {
  @Consumer() val: number = 0;
  @Param val2: number = 0;

  build() {
    Column() {
      Text(`Parent @Consumer val: ${this.val}`).fontSize(30).onClick(() => {
        this.val++;
      })
      Text(`Parent @Param val2: ${this.val2}`).fontSize(30)
      ParentChild({ val: this.val })
    }.border({ width: 2, color: Color.Green })
  }
}

@ComponentV2
struct ParentChild {
  @Param val: number = 0;

  build() {
    Column() {
      Text(`Child @Param val ${this.val}`).fontSize(30)
    }.border({ width: 2, color: Color.Pink })
  }
}