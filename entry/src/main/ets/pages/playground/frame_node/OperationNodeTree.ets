import { BuilderNode, FrameNode, NodeController, UIContext } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { ActionBar } from '../../../comm/ActionBar';

const TEST_TAG: string = "FrameNode"

class Params {
  text: string = "this is a text"
}

@Builder
function buttonBuilder(params: Params) {
  Column({ space: 10 }) {
    Button(params.text)
      .fontSize(12)
      .borderRadius(8)
      .borderWidth(2)
      .backgroundColor(Color.Orange)

    Button(params.text)
      .fontSize(12)
      .borderRadius(8)
      .borderWidth(2)
      .backgroundColor(Color.Pink)
  }
}

class MyNodeController extends NodeController {
  public buttonNode: BuilderNode<[Params]> | null = null;
  public frameNode: FrameNode | null = null;
  public childList: Array<FrameNode> = new Array<FrameNode>();
  public rootNode: FrameNode | null = null;
  private uiContext: UIContext | null = null;
  private wrapBuilder: WrappedBuilder<[Params]> = wrapBuilder(buttonBuilder);

  makeNode(uiContext: UIContext): FrameNode | null {
    this.uiContext = uiContext;
    if (this.rootNode == null) {
      this.rootNode = new FrameNode(uiContext);
      this.rootNode.commonAttribute
        .width("50%")
        .height(100)
        .borderWidth(1)
        .backgroundColor(Color.Gray)
    }

    if (this.frameNode == null) {
      this.frameNode = new FrameNode(uiContext);
      this.frameNode.commonAttribute
        .width("100%")
        .height(50)
        .borderWidth(1)
        .position({ x: 200, y: 0 })
        .backgroundColor(Color.Pink);
      this.rootNode.appendChild(this.frameNode);
    }
    if (this.buttonNode == null) {
      this.buttonNode = new BuilderNode<[Params]>(uiContext);
      this.buttonNode.build(this.wrapBuilder, { text: "This is a Button" })
      this.rootNode.appendChild(this.buttonNode.getFrameNode())
    }
    return this.rootNode;
  }

  operationFrameNodeWithFrameNode(frameNode: FrameNode | undefined | null) {
    if (frameNode) {
      console.log(TEST_TAG + " get ArkTSNode success.")
      console.log(TEST_TAG + " check rootNode whether is modifiable " + frameNode.isModifiable());
    }
    if (this.uiContext) {
      let frameNode1 = new FrameNode(this.uiContext);
      let frameNode2 = new FrameNode(this.uiContext);
      frameNode1.commonAttribute.size({ width: 50, height: 50 })
        .backgroundColor(Color.Black)
        .position({ x: 50, y: 60 })
      frameNode2.commonAttribute.size({ width: 50, height: 50 })
        .backgroundColor(Color.Orange)
        .position({ x: 120, y: 60 })
      try {
        frameNode?.appendChild(frameNode1);
        console.log(TEST_TAG + " appendChild success ");
      } catch (err) {
        console.log(TEST_TAG + " appendChild fail :" + (err as BusinessError).code + " : " + (err as BusinessError).message);
      }
      try {
        frameNode?.insertChildAfter(frameNode2, null);
        console.log(TEST_TAG + " insertChildAfter success ");
      } catch (err) {
        console.log(TEST_TAG + " insertChildAfter fail : " + (err as BusinessError).code + " : " + (err as BusinessError).message);
      }
      setTimeout(() => {
        try {
          frameNode?.removeChild(frameNode?.getChild(0))
          console.log(TEST_TAG + " removeChild success ");
        } catch (err) {
          console.log(TEST_TAG + " removeChild fail : " + (err as BusinessError).code + " : " + (err as BusinessError).message);
        }
      }, 2000)
      setTimeout(() => {
        try {
          frameNode?.clearChildren();
          console.log(TEST_TAG + " clearChildren success ");
        } catch (err) {
          console.log(TEST_TAG + " clearChildren fail : " + (err as BusinessError).code + " : " + (err as BusinessError).message);
        }
      }, 4000)
    }
  }

  testInterfaceAboutSearch(frameNode: FrameNode | undefined | null): string {
    let result: string = "";
    if (frameNode) {
      result = result + `current node is ${frameNode.getNodeType()} \n`;
      result = result + `parent node is ${frameNode.getParent()?.getNodeType()} \n`;
      result = result + `child count is ${frameNode.getChildrenCount()} \n`;
      result = result + `first child node is ${frameNode.getFirstChild()?.getNodeType()} \n`;
      result = result + `second child node is ${frameNode.getChild(1)?.getNodeType()} \n`;
      result = result + `previousSibling node is ${frameNode.getPreviousSibling()?.getNodeType()} \n`;
      result = result + `nextSibling node is ${frameNode.getNextSibling()?.getNodeType()} \n`;
    }
    return result;
  }

  checkAppendChild(parent: FrameNode | undefined | null, child: FrameNode | undefined | null) {
    try {
      if (parent && child) {
        parent.appendChild(child);
        console.log(TEST_TAG + " appendChild success ");
      }
    } catch (err) {
      console.log(TEST_TAG + " appendChild fail : " + (err as BusinessError).code + " : " + (err as BusinessError).message);
    }
  }
}

@Entry
@Component
struct OperationNodeTree {
  @State index: number = 0;
  @State result: string = ""
  private myNodeController: MyNodeController = new MyNodeController();

  build() {
    Column(){
      ActionBar({title:"验证"})
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
        List({ space: 20, initialIndex: 0 }) {
          ListItem() {
            Column({ space: 5 }) {
              Text("验证FrameNode子节点的增、删、改功能")
              Button("对自定义FrameNode进行操作")
                .fontSize(16)
                .width(400)
                .onClick(() => {
                  // 对FrameNode节点进行增、删、改操作，正常实现。
                  this.myNodeController.operationFrameNodeWithFrameNode(this.myNodeController?.frameNode);
                })
              Button("对BuilderNode中的代理节点进行操作")
                .fontSize(16)
                .width(400)
                .onClick(() => {
                  // 对BuilderNode代理节点进行增、删、改操作，捕获异常信息。
                  this.myNodeController.operationFrameNodeWithFrameNode(this.myNodeController?.buttonNode?.getFrameNode());
                })
              Button("对原生组件中的代理节点进行操作")
                .fontSize(16)
                .width(400)
                .onClick(() => {
                  // 对代理节点进行增、删、改操作，捕获异常信息。
                  this.myNodeController.operationFrameNodeWithFrameNode(this.myNodeController?.rootNode?.getParent());
                })
            }
          }

          ListItem() {
            Column({ space: 5 }) {
              Text("验证FrameNode添加子节点的特殊场景")
              Button("新增BuilderNode的代理节点")
                .fontSize(16)
                .width(400)
                .onClick(() => {
                  let buttonNode = new BuilderNode<[Params]>(this.getUIContext());
                  buttonNode.build(wrapBuilder<[Params]>(buttonBuilder), { text: "BUTTON" })
                  this.myNodeController.checkAppendChild(this.myNodeController?.frameNode, buttonNode?.getFrameNode());
                })
              Button("新增原生组件代理节点")
                .fontSize(16)
                .width(400)
                .onClick(() => {
                  this.myNodeController.checkAppendChild(this.myNodeController?.frameNode, this.myNodeController?.rootNode?.getParent());
                })
              Button("新增已有父节点的自定义节点")
                .fontSize(16)
                .width(400)
                .onClick(() => {
                  this.myNodeController.checkAppendChild(this.myNodeController?.frameNode, this.myNodeController?.rootNode);
                })
            }
          }

          ListItem() {
            Column({ space: 5 }) {
              Text("验证FrameNode节点的查询功能")
              Button("对自定义FrameNode进行操作")
                .fontSize(16)
                .width(400)
                .onClick(() => {
                  // 对FrameNode节点进行进行查询。当前节点为NodeContainer的子节点。
                  this.result = this.myNodeController.testInterfaceAboutSearch(this.myNodeController?.rootNode);
                  setTimeout(() => {
                    // 对FrameNode节点进行进行查询。rootNode下的第一个子节点。
                    this.result = this.myNodeController.testInterfaceAboutSearch(this.myNodeController?.frameNode);
                  }, 2000)
                })
              Button("对BuilderNode中的代理节点进行操作")
                .fontSize(16)
                .width(400)
                .onClick(() => {
                  // 对BuilderNode代理节点进行进行查询。当前节点为BuilderNode中的Column节点。
                  this.result = this.myNodeController.testInterfaceAboutSearch(this.myNodeController?.buttonNode?.getFrameNode());
                })
              Button("对原生组件中的代理节点进行操作")
                .fontSize(16)
                .width(400)
                .onClick(() => {
                  // 对代理节点进行查询。当前节点为NodeContainer。
                  this.result = this.myNodeController.testInterfaceAboutSearch(this.myNodeController?.rootNode?.getParent());
                })
            }
          }
        }.height("50%")

        Text(`Result：\n${this.result}`)
          .fontSize(16)
          .width(400)
          .height(200)
          .padding(30)
          .borderWidth(1)
        Column() {
          Text("This is a NodeContainer.")
            .textAlign(TextAlign.Center)
            .borderRadius(10)
            .backgroundColor(0xFFFFFF)
            .width('100%')
            .fontSize(16)
          NodeContainer(this.myNodeController)
            .borderWidth(1)
            .width(400)
            .height(150)
        }
      }
    }


    .padding({ left: 35, right: 35, top: 35, bottom: 35 })
    .width("100%")
    .height("100%")
  }
}