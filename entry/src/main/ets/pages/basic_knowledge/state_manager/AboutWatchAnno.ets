import ActionBar from '../../../comm/ActionBar';
@Entry
@Component
struct AboutWatchAnno {
  @State count: number = 0;
  @State shopBasket: PurchaseItem[] = [];
  build() {
    Column() {
      ActionBar({ title: '@Watch' })
      Column() {
        Button('add to basket')
          .onClick(() => {
            this.count++
          })
        TotalView({ count: this.count })
        Divider().backgroundColor(Color.White)
        Text('CountModifier自定义组件的Button.onClick点击事件自增count。\n\n' +
        '由于@State count变量更改，子组件TotalView中的@Prop被更新，其@Watch(\'onCountUpdated\')方法被调用，更新了子组件TotalView 中的total变量。\n\n' +
        '子组件TotalView中的Text重新渲染。').fontColor(Color.White).fontSize(18)

      }.borderRadius(10).backgroundColor(Color.Gray).margin(10).padding(10)


      Column() {
        Button('Add to basket')
          .onClick(() => {
            this.shopBasket.push(new PurchaseItem(Math.round(100 * Math.random())))
          })
        BasketViewer({ shopBasket: $shopBasket })

        Divider().backgroundColor(Color.White)
        Text('BasketModifier组件的Button.onClick向BasketModifier shopBasket中添加条目；\n\n' +
        '@Link装饰的BasketViewer shopBasket值发生变化；\n\n' +
        '状态管理框架调用@Watch函数BasketViewer onBasketUpdated 更新BasketViewer TotalPurchase的值；\n\n'+
        '@Link shopBasket的改变，新增了数组项，ForEach组件会执行item Builder，渲染构建新的Item项；@State totalPurchase改变，对应的Text组件也重新渲染；重新渲染是异步发生的。').fontColor(Color.White).fontSize(18)

      }.borderRadius(10).backgroundColor(Color.Gray).margin(10).padding(10)
    }
  }
}

@Component
struct TotalView {
  @Prop @Watch('onCountUpdated') count: number;
  @State total: number = 0;
  // @Watch cb
  onCountUpdated(propName: string): void {
    this.total += this.count;
  }

  build() {
    Text(`Total: ${this.total}`)
  }
}


class PurchaseItem {
  static NextId: number = 0;
  public id: number;
  public price: number;

  constructor(price: number) {
    this.id = PurchaseItem.NextId++;
    this.price = price;
  }
}

@Component
struct BasketViewer {
  @Link @Watch('onBasketUpdated') shopBasket: PurchaseItem[];
  @State totalPurchase: number = 0;

  updateTotal(): number {
    let total = this.shopBasket.reduce((sum, i) => sum + i.price, 0);
    // 超过100欧元可享受折扣
    if (total >= 100) {
      total = 0.9 * total;
    }
    return total;
  }
  // @Watch 回调
  onBasketUpdated(propName: string): void {
    this.totalPurchase = this.updateTotal();
  }

  build() {
    Column() {
      ForEach(this.shopBasket,
        (item) => {
          Text(`Price: ${item.price.toFixed(2)} €`)
        },
        item => item.id.toString()
      )
      Text(`Total: ${this.totalPurchase.toFixed(2)} €`)
    }
  }
}