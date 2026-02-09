// GridDataSource.ets
export class GridDataSource<T> implements IDataSource {
  private list: T[] = [];
  private listeners: DataChangeListener[] = [];

  constructor(list: T[]) {
    this.list = list;
  }

  totalCount(): number {
    return this.list.length;
  }

  getData(index: number): T {
    return this.list[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  // 通知控制器数据位置变化
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    });
  }

  public change(from:number,to:number){
    if(from!=to){
      console.error(`change之前 ${JSON.stringify(this.list,['text'])}`)


      let tmp:T = this.list[from]
      this.list.splice(from,1)
      this.list.splice(to,0,tmp)
      console.error(`change之后 ${JSON.stringify(this.list)}`)
      this.listeners.forEach((listener)=>{
        // listener.onDatasetChange([
        //   {type:DataOperationType.DELETE,index:from,count:1},
        //   {type:DataOperationType.ADD,index:to,count:1}
        // ])
        listener.onDataDelete(from)
        listener.onDataAdd(to)
      })
    }

  }
}