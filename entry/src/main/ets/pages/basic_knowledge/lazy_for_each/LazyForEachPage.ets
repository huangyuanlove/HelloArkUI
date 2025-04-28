import { Coupon, CouponListDataSource } from './MyDataSource';
import { systemDateTime } from '@kit.BasicServicesKit';
import ActionBar from '../../../comm/ActionBar';

@Entry
@ComponentV2
struct LazyForEachPage {
  private dataSource: CouponListDataSource = new CouponListDataSource();
  aboutToAppear(): void {
    this.initData()
  }

  initData() {
    let dataList :Coupon[] =[]
    for (let i = 0; i < 30; i++) {
      let coupon = new Coupon()
      coupon.id = (i + 1).toString()
      coupon.content = `这是第${(i + 1)}项`
      if(i ==1){
        coupon.defaultSelect = true
      }else{
        coupon.defaultSelect = false
      }
      dataList.push(coupon)
    }
    this.dataSource.setData(dataList)

  }

  build() {
    Column() {
      ActionBar({ title: "懒加载 LazyForEach" })
      Row(){
        Button("随机位置追加一项").onClick((_)=>{
          let chatItem:Coupon = new Coupon()
          chatItem.id = Math.ceil ((Math.random() *100) + this.dataSource.totalCount()).toString()
          chatItem.content = Math.random() +"随机内容"

          let insertIndex = Math.floor (Math.random() * this.dataSource.totalCount())
          this.dataSource.insertData(chatItem,insertIndex)

        })
        Button("随机位置删除一项").onClick((_)=>{
          let deleteIndex = Math.floor (Math.random() * this.dataSource.totalCount())
          this.dataSource.deleteDataByIndex(deleteIndex)
        })
      }
      List({space:10}) {
        LazyForEach(this.dataSource, (item: Coupon,index:number) => {
          ListItem() {
            CouponView({item:item})
          }.onClick((_)=>{
              if(item.defaultSelect){
                item.defaultSelect = false
              }else{
                item.defaultSelect = true
              }
              this.dataSource.notifyDataChange(index)
          })
        }, (item: Coupon) =>{
          let key = item.id + '_' +item.content +'_' + item.defaultSelect
          console.error(`LazyForEachPage key ${key}`)
          return key
        } )
      }.cachedCount(5).layoutWeight(1)
    }
    .height('100%')
    .width('100%')
  }
}
@ComponentV2
struct  CouponView{
  @Require @Param item:Coupon
  aboutToAppear(): void {
    console.error(`${this.item.id} aboutToAppear`)
  }

  build() {
    Row() {
      Column(){
        Text(this.item.id).fontSize(12).fontColor("#666666")
        Text(this.item.content).fontSize(14).margin({ top: 10 }).fontColor("#323232")
      }.layoutWeight(1)
      Circle()
        .width(20)
        .height(20)
        .fill(this.item.defaultSelect ? Color.Red : Color.Gray)
        .stroke(this.item.defaultSelect ? Color.Red : Color.Grey)

    }.margin({ left: 10, right: 10 }).backgroundColor("#f7f7f7").borderRadius(4).padding(10)
  }
}