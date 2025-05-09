import { ActionBar } from  '../../../comm/ActionBar';
import { ContentDialog } from '../../../component/ContentDialog';

PersistentStorage.PersistProp('aProp', 47);

@Entry
@Component
struct AboutPersistentStorage {
  @State message: string = 'Hello World'
  @StorageLink('aProp') aProp: number = 48

  private generality:string ='PersistentStorage将选定的AppStorage属性保留在设备磁盘上。\n'+
  '应用程序通过API，以决定哪些AppStorage属性应借助PersistentStorage持久化。\n'+
  'UI和业务逻辑不直接访问PersistentStorage中的属性，所有属性访问都是对AppStorage的访问，AppStorage中的更改会自动同步到PersistentStorage。\n\n'+
  'PersistentStorage和AppStorage中的属性建立双向同步。\n'+
  '应用开发通常通过AppStorage访问PersistentStorage，另外还有一些接口可以用于管理持久化属性，但是业务逻辑始终是通过AppStorage获取和设置属性的。'

  private firstInstallFlow: string = '调用PersistProp初始化PersistentStorage，首先查询在PersistentStorage本地文件中是否存在“aProp”，查询结果为不存在，因为应用是第一次安装。；\n\n' +
  '接着查询属性“aProp”在AppStorage中是否存在，依旧不存在；\n\n' +
  '在AppStorge中创建名为“aProp”的number类型属性，属性初始值是定义的默认值47；\n\n' +
  'PersistentStorage将属性“aProp”和值47写入磁盘，AppStorage中“aProp”对应的值和其后续的更改将被持久化；\n\n' +
  '在Index组件中创建状态变量@StorageLink(\'aProp\') aProp，和AppStorage中“aProp”双向绑定，在创建的过程中会在AppStorage中查找，成功找到“aProp”，所以使用其在AppStorage找到的值47。\n\n'
  private afterClick: string = '状态变量@StorageLink(\'aProp\') aProp改变，触发Text组件重新刷新；\n\n' +
  '@StorageLink装饰的变量是和AppStorage中建立双向同步的，所以@StorageLink(\'aProp\') aProp的变化会被同步回AppStorage中；\n\n' +
  'AppStorage中“aProp”属性的改变会同步到所有绑定该“aProp”的单向或者双向变量，在本示例中没有其他的绑定“aProp”的变量；\n\n' +
  '因为“aProp”对应的属性已经被持久化，所以在AppStorage中“aProp”的改变会触发PersistentStorage将新的改变写会本地磁盘。\n\n'
  private afterLaunch: string = '执行PersistentStorage.PersistProp(\'aProp\', 47)，在首先查询在PersistentStorage本地文件查询“aProp”属性，成功查询到；' +
  '将在PersistentStorage查询到的值写入AppStorage中；' +
  '在Index组件里，@StorageLink绑定的“aProp”为PersistentStorage写入AppStorage中的值，即为上一次退出引用存入的值。'


  generalityController: CustomDialogController|null = new CustomDialogController({
    builder: ContentDialog({
      content: this.generality
    }),

    autoCancel: true,
    alignment: DialogAlignment.Default,
    offset: { dx: 0, dy: 0 },
  })

  firstInstallFlowController: CustomDialogController|null = new CustomDialogController({
    builder: ContentDialog({
      content: this.firstInstallFlow
    }),

    autoCancel: true,
    alignment: DialogAlignment.Default,
    offset: { dx: 0, dy: 0 },
  })
  afterClickFlowController: CustomDialogController|null = new CustomDialogController({
    builder: ContentDialog({
      content: this.afterClick
    }),

    autoCancel: true,
    alignment: DialogAlignment.Default,
    offset: { dx: 0, dy: 0 },
  })
  afterLaunchFlowController: CustomDialogController|null = new CustomDialogController({
    builder: ContentDialog({
      content: this.afterLaunch
    }),

    autoCancel: true,
    alignment: DialogAlignment.Default,
    offset: { dx: 0, dy: 0 },
  })


  // 在自定义组件即将析构销毁时将dialogControlle删除和置空
  aboutToDisappear() {


    this.firstInstallFlowController = null

    this.afterClickFlowController = null

    this.afterLaunchFlowController = null

    this.afterLaunch = ""

  }

  build() {
    Column() {
      ActionBar({ title: 'PersistentStorage' })
      Button('概述').showDialogButtonStyle()

        .onClick(() => {
          if (this.generalityController != undefined) {
            this.generalityController.open()
          }
        })

      Text(this.message)
      // 应用退出时会保存当前结果。重新启动后，会显示上一次的保存结果
      Button(`${this.aProp}`).showDialogButtonStyle()
        .onClick(() => {
          this.aProp += 1;
        })

      Divider().height(5).backgroundColor(Color.Gray)


      Button('新应用安装后首次启动运行 流程').onClick(() => {
        if (this.firstInstallFlowController != undefined) {
          this.firstInstallFlowController.open()
        }
      }).showDialogButtonStyle()

      Divider().height(5).backgroundColor(Color.Gray)

      Button('触发点击事件后').onClick(() => {
        if (this.afterClickFlowController != undefined) {
          this.afterClickFlowController.open()
        }
      }).showDialogButtonStyle()

      Divider().height(5).backgroundColor(Color.Gray)

      Button('后续启动').onClick(() => {
        if (this.afterLaunchFlowController != undefined) {
          this.afterLaunchFlowController.open()
        }
      }).showDialogButtonStyle()
    }
  }
}

@Extend(Button) function showDialogButtonStyle() {
  .margin(10)
  .padding(10)
  .fontSize(20)
  .backgroundColor(Color.Gray)
  .fontColor(Color.White)
  .borderRadius(8)
}