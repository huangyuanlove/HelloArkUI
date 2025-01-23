import { hilog } from '@kit.PerformanceAnalysisKit';
import { promptAction } from '@kit.ArkUI';

@Entry
@ComponentV2
struct MonitorPage {
  @Local message: string = "Hello World";
  @Local name: string = "Tom";
  @Local age: number = 24;

  @Monitor("message", "name")
  onStrChange(monitor: IMonitor) {
    monitor.dirty.forEach((paramsName: string) => {
      hilog.error(0x01, 'MonitorPage',
        `属性名：${paramsName}  由 ${monitor.value(paramsName)?.before} 修改为 ${monitor.value(paramsName)?.now}`)
    })
  }

  monitorTest: MonitorTest = new MonitorTest()

  @Monitor("monitorTest.name")
  onChangeName(monitor: IMonitor) {
    hilog.error(0x01, 'MonitorPage', '在自定义控件中监听对象属性变化：' +
      `${monitor.value()?.path} 由 ${monitor.value()?.before} 修改为 ${monitor.value()?.now}`)
  }

  build() {
    Column() {
      Button("change string")
        .onClick(() => {
          this.message += "!";
          this.name = "Jack";
        })
      Text(`name:${this.name}  message:${this.message}`)
      Divider().color("#e7e7e7").height(1)

      Column() {
        Button("change name")
          .onClick(() => {
            this.monitorTest.name = "Jack"; // 能够触发onNameChange方法
          })
        Button("change age")
          .onClick(() => {
            promptAction.showToast({ message: "age未被@Trace装饰，不能监听变化,不能够触发onAgeChange方法", duration: 5 })
            this.monitorTest.age = 26; // 不能够触发onAgeChange方法
          })
        Button("change region")
          .onClick(() => {
            this.monitorTest.region = "South"; // 能够触发onChange方法
          })
        Button("change job")
          .onClick(() => {
            this.monitorTest.job = "Driver"; // 能够触发onChange方法
          })
        Text(`name: ${this.monitorTest.name} ,age:${this.monitorTest.age} ,region: ${this.monitorTest.region}, job:${this.monitorTest.job}`)
          .padding(4)
          .borderWidth(1)
          .borderColor("#887612")
      }

    }.width('100%').height('100%')
  }
}

@ObservedV2
class MonitorTest {
  @Trace name: string = "Tom";
  @Trace region: string = "North";
  @Trace job: string = "Teacher";
  age: number = 25;

  // name被@Trace装饰，能够监听变化
  @Monitor("name")
  onNameChange(monitor: IMonitor) {

    hilog.error(0x01, 'MonitorTest', `name change from ${monitor.value()?.before} to ${monitor.value()?.now}`);
  }

  // age未被@Trace装饰，不能监听变化
  @Monitor("age")
  onAgeChange(monitor: IMonitor) {
    hilog.error(0x01, 'MonitorTest', `age change from ${monitor.value()?.before} to ${monitor.value()?.now}`);
  }

  // region与job均被@Trace装饰，能够监听变化
  @Monitor("region", "job")
  onChange(monitor: IMonitor) {
    monitor.dirty.forEach((path: string) => {
      hilog.error(0x01, 'MonitorTest',
        `${path} change from ${monitor.value(path)?.before} to ${monitor.value(path)?.now}`);
    })
  }
}
