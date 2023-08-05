import router from '@ohos.router'

@Entry
@Component
struct Index {
  build() {
    Column() {
      Button() {
        Text('基础')
          .fontSize(30)
          .padding(10)
      }.type(ButtonType.Capsule)
      .width('40%')
      .backgroundColor('#39d167')
      .onClick(() => {
        router.pushUrl({ url: 'pages/Base' })
      })

      Button() {
        Text('生命周期')
          .fontSize(30)
          .padding(10)
      }
      .type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor('#39d167')
      .width('40%')
      .onClick(() => {
        router.pushUrl({ url: 'pages/LifeCirclePage' })
      })

      Button() {
        Text('参数传递')
          .fontSize(30)
          .padding(10)
      }
      .type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor('#39d167')
      .width('40%')
      .onClick(() => {
        router.pushUrl({ url: 'pages/AboutParams' })
      })

      Button() {
        Text('参数传递')
          .fontSize(30)
          .padding(10)
      }
      .type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor('#39d167')
      .width('40%')
      .onClick(() => {
        router.pushUrl({ url: 'pages/AboutParams' })
      })

      Button() {
        Text('@BuilderParam装饰器：引用@Builder函数')
          .fontSize(20)
          .padding(10)
      }
      .type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor('#39d167')
      .onClick(() => {
        router.pushUrl({ url: 'pages/AboutBuildParams' })
      })

      Button() {
        Text('@Styles装饰器：定义组件重用样式')
          .fontSize(20)
          .padding(10)
      }
      .type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor('#39d167')
      .onClick(() => {
        router.pushUrl({ url: 'pages/AboutStyleAnno' })
      })

      Button() {
        Text('@Extend装饰器：定义扩展组件样式')
          .fontSize(20)
          .padding(10)
      }
      .type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor('#39d167')
      .onClick(() => {
        router.pushUrl({ url: 'pages/AboutExtendAnno' })
      })


    }.height('100%')
  }
}