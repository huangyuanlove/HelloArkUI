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

  public moveDataWithoutNotify(from: number, to: number): void {
    let tmp = this.list.splice(from, 1);
    this.list.splice(to, 0, tmp[0]);
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

  getCurrentListID():string{
    let result = '['
    this.list.forEach( (value)=>{
      result += (value as ESObject)['text']
      result +=','
    } )
    return `${result}]`
  }
  public getItemIndex(item:T):number{
    return this.list.indexOf(item)
  }

  public change(from:number,to:number){
    if(from!=to){

      console.error(`change之前 ${this.getCurrentListID()}`)
      let tmp = this.list.splice(from, 1);
      this.list.splice(to, 0, tmp[0]);
      console.error(`change之后 ${this.getCurrentListID()}`)
      this.listeners.forEach((listener)=>{
        listener.onDataDelete(from)
        listener.onDataAdd(to)
      })
    }

  }
}