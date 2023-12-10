import ActionBar from '../../../comm/ActionBar';
AppStorage.SetOrCreate('PropA', 47);
let storage = new LocalStorage({ 'PropA': 48 });

@Entry(storage)
@Component
struct AboutAppStorage{
  @StorageLink('PropA') storLink: number = 1;
  @LocalStorageLink('PropA') localStorLink: number = 1;
  build(){
    Column(){
      ActionBar({ title: 'AppStorage' })
      Text('AppStorage是单例，它的所有API都是静态的，使用方法类似于LocalStorage对应的非静态方法。')
        .margin(10)
        .padding(10)
        .fontSize(20)
        .backgroundColor(Color.Gray)
        .fontColor(Color.White)
        .borderRadius(8)
      Text('限制条件\n' +
      '在AppStorage中创建属性后，调用PersistentStorage.PersistProp()接口时，会使用在AppStorage中已经存在的值，并覆盖PersistentStorage中的同名属性，所以建议要使用相反的调用顺序，反例可见在PersistentStorage之前访问AppStorage中的属性；\n' +
      '如果在AppStorage中已经创建属性后，再调用Environment.EnvProp()创建同名的属性，会调用失败。因为AppStorage已经有同名属性，Environment环境变量不会再写入AppStorage中，所以建议AppStorage中属性不要使用Environment预置环境变量名。')
        .margin(10)
        .padding(10)
        .fontSize(20)
        .backgroundColor(Color.Gray)
        .fontColor(Color.White)
        .borderRadius(8)

      Text(`From AppStorage ${this.storLink}`)
        .onClick(() => this.storLink += 1)
        .margin(10)

      Text(`From LocalStorage ${this.localStorLink}`)
        .onClick(() => this.localStorLink += 1)
        .margin(10)
    }
  }
}