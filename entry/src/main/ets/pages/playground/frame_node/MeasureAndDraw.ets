import { DrawContext, FrameNode, NodeController, Position, Size, UIContext, LayoutConstraint } from '@kit.ArkUI';
import { drawing } from '@kit.ArkGraphics2D';
import { ActionBar } from '../../../comm/ActionBar';

function GetChildLayoutConstraint(constraint: LayoutConstraint, child: FrameNode): LayoutConstraint {
  const size = child.getUserConfigSize();
  const width = Math.max(
    Math.min(constraint.maxSize.width, size.width.value),
    constraint.minSize.width
  );
  const height = Math.max(
    Math.min(constraint.maxSize.height, size.height.value),
    constraint.minSize.height
  );
  const finalSize: Size = { width, height };
  const res: LayoutConstraint = {
    maxSize: finalSize,
    minSize: finalSize,
    percentReference: finalSize
  };

  return res;
}

class MyFrameNode extends FrameNode {
  public width: number = 100;
  public offsetY: number = 0;
  private space: number = 1;

  onMeasure(constraint: LayoutConstraint): void {
    let sizeRes: Size = { width: vp2px(100), height: vp2px(100) };
    for (let i = 0;i < this.getChildrenCount(); i++) {
      let child = this.getChild(i);
      if (child) {
        let childConstraint = GetChildLayoutConstraint(constraint, child);
        child.measure(childConstraint);
        let size = child.getMeasuredSize();
        sizeRes.height += size.height + this.space;
        sizeRes.width = Math.max(sizeRes.width, size.width);
      }
    }
    this.setMeasuredSize(sizeRes);
  }

  onLayout(position: Position): void {
    let y = 0;
    for (let i = 0;i < this.getChildrenCount(); i++) {
      let child = this.getChild(i);
      if (child) {
        child.layout({
          x: vp2px(100),
          y: vp2px(this.offsetY)
        });
        y += child.getMeasuredSize().height + this.space;
      }
    }
    this.setLayoutPosition(position);
  }

  onDraw(context: DrawContext) {
    const canvas = context.canvas;
    const pen = new drawing.Pen();
    pen.setStrokeWidth(15);
    pen.setColor({ alpha: 255, red: 255, green: 0, blue: 0 });
    canvas.attachPen(pen);
    canvas.drawRect({
      left: 50,
      right: this.width + 50,
      top: 50,
      bottom: this.width + 50,
    });
    canvas.detachPen();
  }

  addWidth() {
    this.width = (this.width + 10) % 50 + 100;
  }
}

class MyNodeController extends NodeController {
  public rootNode: MyFrameNode | null = null;

  makeNode(context: UIContext): FrameNode | null {
    this.rootNode = new MyFrameNode(context);
    this.rootNode?.commonAttribute?.size({ width: 100, height: 100 }).backgroundColor(Color.Green);
    let frameNode: FrameNode = new FrameNode(context);
    this.rootNode.appendChild(frameNode);
    frameNode.commonAttribute.width(10).height(10).backgroundColor(Color.Pink);
    return this.rootNode;
  }
}

@Entry
@Component
struct MeasureAndDraw {
  private nodeController: MyNodeController = new MyNodeController();

  build() {
    Column(){
      ActionBar({title:"测量"})
      Row() {
        Column() {
          NodeContainer(this.nodeController)
            .width('100%')
            .height(200)
            .backgroundColor('#FFF0F0F0')
          Button('Invalidate')
            .margin(10)
            .onClick(() => {
              this.nodeController?.rootNode?.addWidth();
              this.nodeController?.rootNode?.invalidate();
            })
          Button('UpdateLayout')
            .onClick(() => {
              let node = this.nodeController.rootNode;
              node!.offsetY = (node!.offsetY + 10) % 110;
              this.nodeController?.rootNode?.setNeedsLayout();
            })
        }
        .width('100%')
        .height('100%')
      }
    }


    .height('100%')
  }
}