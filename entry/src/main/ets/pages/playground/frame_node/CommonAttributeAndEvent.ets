import { BuilderNode, FrameNode, NodeController, UIContext } from '@kit.ArkUI'

class Params {
  text: string = "this is a text"
}

@Builder
function buttonBuilder(params: Params) {
  Button(params.text)
    .fontSize(12)
    .borderRadius(8)
    .borderWidth(2)
    .backgroundColor(Color.Orange)
    .onClick((event: ClickEvent) => {
      console.log(`Button ${JSON.stringify(event)}`);
    })
}

class MyNodeController extends NodeController {
  public buttonNode: BuilderNode<[Params]> | null = null;
  public frameNode: FrameNode | null = null;
  public rootNode: FrameNode | null = null;
  private wrapBuilder: WrappedBuilder<[Params]> = wrapBuilder(buttonBuilder);

  makeNode(uiContext: UIContext): FrameNode | null {
    if (this.rootNode == null) {
      this.rootNode = new FrameNode(uiContext);
      // 对rootNode进行属性修改，该节点为自定义的FrameNode节点，修改生效
      this.rootNode.commonAttribute
        .width("100%")
        .height(100)
        .borderWidth(1)
        .backgroundColor(Color.Gray)
    }

    if (this.frameNode == null) {
      this.frameNode = new FrameNode(uiContext);
      // 对frameNode进行属性修改，该节点为自定义的FrameNode节点，修改生效
      this.frameNode.commonAttribute
        .width("50%")
        .height(50)
        .borderWidth(1)
        .backgroundColor(Color.Pink);
      this.rootNode.appendChild(this.frameNode);
    }
    if (this.buttonNode == null) {
      this.buttonNode = new BuilderNode<[Params]>(uiContext);
      this.buttonNode.build(this.wrapBuilder, { text: "This is a Button" })
      // 对BuilderNode中获取的FrameNode进行属性修改，该节点非自定义的FrameNode节点，修改不生效
      this.buttonNode?.getFrameNode()?.commonAttribute.position({ x: 100, y: 100 })
      this.rootNode.appendChild(this.buttonNode.getFrameNode())
    }
    return this.rootNode;
  }

  modifyNode(frameNode: FrameNode | null | undefined, sizeValue: SizeOptions, positionValue: Position) {
    if (frameNode) {
      frameNode.commonAttribute.size(sizeValue).position(positionValue);
    }
  }

  addClickEvent(frameNode: FrameNode | null | undefined) {
    if (frameNode) {
      frameNode.commonEvent.setOnClick((event: ClickEvent) => {
        console.log(`FrameNode ${JSON.stringify(event)}`);
      })
    }
  }
}

@Entry
@Component
struct CommonAttributeAndEvent {
  private myNodeController: MyNodeController = new MyNodeController();

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      Column({ space: 10 }) {
        Text("修改节点通用属性-宽高")
        Button("modify ArkTS-FrameNode")
          .onClick(() => {
            // 获取到的是当前页面中的开发者创建的FrameNode对象，该节点可修改。即节点大小与位置。
            console.log("Check the weather the node can be modified " + this.myNodeController?.rootNode?.getParent()
            ?.isModifiable());
            this.myNodeController.modifyNode(this.myNodeController?.frameNode, { width: 150, height: 100 }, {
              x: 100,
              y: 0
            })
          })
        Button("modify FrameNode get by BuilderNode")
          .onClick(() => {
            // 获取到的是当前页面中的BuilderNode的根节点，该节点不可修改。即节点大小与位置未发生改变。
            console.log("Check the weather the node can be modified " + this.myNodeController?.buttonNode?.getFrameNode()
            ?.isModifiable());
            this.myNodeController.modifyNode(this.myNodeController?.buttonNode?.getFrameNode(), {
              width: 100,
              height: 100
            }, { x: 50, y: 50 })
          })
        Button("modify proxyFrameNode get by search")
          .onClick(() => {
            // rootNode调用getParent()获取到的是当前页面中的NodeContainer节点，该节点不可修改。即节点大小与位置未发生改变。
            console.log("Check the weather the node can be modified " + this.myNodeController?.rootNode?.getParent()
            ?.isModifiable());
            this.myNodeController.modifyNode(this.myNodeController?.rootNode?.getParent(), {
              width: 500,
              height: 500
            }, {
              x: 0,
              y: 0
            })
          })
      }.padding({ left: 35, right: 35, top: 35, bottom: 35 })

      Column({ space: 10 }) {
        Text("修改节点点击事件")
        Button("add click event to ArkTS-FrameNode")
          .onClick(() => {
            // 获取到的是当前页面中的开发者创建的FrameNode对象，该节点可增加点击事件。
            // 增加的点击事件参与事件竞争，即点击事件会在该节点被消费且不不再向父组件冒泡。
            console.log("Check the weather the node can be modified " + this.myNodeController?.rootNode?.getParent()
            ?.isModifiable());
            this.myNodeController.addClickEvent(this.myNodeController?.frameNode)
          })
        Button("add click event to FrameNode get by BuilderNode")
          .onClick(() => {
            // 获取到的是当前页面中的BuilderNode的根节点，该类节点可增加点击事件。
            // 点击的时候优先回调通过原生组件接口设置的click事件回调，然后回调通过commonEvent增加的click监听。
            console.log("Check the weather the node can be modified " + this.myNodeController?.buttonNode?.getFrameNode()
            ?.isModifiable());
            this.myNodeController.addClickEvent(this.myNodeController?.buttonNode?.getFrameNode())
          })
        Button("add click event to proxyFrameNode get by search")
          .onClick(() => {
            // rootNode调用getParent()获取到的是当前页面中的NodeContainer节点，该类节点可增加点击事件。
            console.log("Check the weather the node can be modified " + this.myNodeController?.rootNode?.getParent()
            ?.isModifiable());
            this.myNodeController.addClickEvent(this.myNodeController?.rootNode?.getParent());
          })
      }.padding({ left: 35, right: 35, top: 35, bottom: 35 })

      NodeContainer(this.myNodeController)
        .borderWidth(1)
        .width("100%")
        .height(100)
        .onClick((event: ClickEvent) => {
          console.log(`NodeContainer ${JSON.stringify(event)}`);
        })
    }
    .padding({ left: 35, right: 35, top: 35, bottom: 35 })
    .width("100%")
    .height("100%")
  }
}