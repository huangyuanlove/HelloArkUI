export class BasicDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private data: T[] = [];

  totalCount(): number {
    return this.data.length
  }

  getData(index: number): T {
    return this.data[index]
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.error("BasicDataSource#registerDataChangeListener 添加监听")
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const position = this.listeners.indexOf(listener);
    if (position >= 0) {
      this.listeners.splice(position, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    });
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
      // 写法2：listener.onDatasetChange([{type: DataOperationType.ADD, index: index}]);
    });
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
      // 写法2：listener.onDatasetChange([{type: DataOperationType.CHANGE, index: index}]);
    });
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
      // 写法2：listener.onDatasetChange([{type: DataOperationType.DELETE, index: index}]);
    });
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
      // 写法2：listener.onDatasetChange(
      //         [{type: DataOperationType.EXCHANGE, index: {start: from, end: to}}]);
    });
  }

  notifyDatasetChange(operations: DataOperation[]): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange(operations);
    });
  }

  pushData(data: T) {
    this.data.push(data)
    this.notifyDataAdd(this.data.length - 1)
  }

  insertData(data:T,index:number){
    this.data.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  deleteData(data: T) {
    const position = this.data.indexOf(data)
    this.deleteDataByIndex(position)
  }

  deleteDataByIndex(index: number) {
    if (index >= 0) {
      this.data.splice(index, 1);
      this.notifyDataDelete(index)
    }
  }

  setData(data: T[]) {
    this.data = data
    this.notifyDataReload()

  }
}


export class CouponListDataSource extends BasicDataSource<Coupon> {
}

@ObservedV2
export class Coupon {
 @Trace id: string = ""
 @Trace content:string = ""
 @Trace defaultSelect:boolean = false
}

