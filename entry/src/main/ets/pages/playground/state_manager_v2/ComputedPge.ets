import hilog from '@ohos.hilog';

@Entry
@ComponentV2
struct ComputedPge {
  @Local firstName: string = 'Li';
  @Local lastName: string = 'Hua';
  age: number = 20; // 无法触发Computed

  @Local fullNameByAttr:string =  this.firstName + ' ' + this.lastName + this.age;

  /**
   * 如果是上面这种简单计算，可以不使用计算属性。如果在视图中只使用一次，也可以不使用计算属性，建议直接求解。
   * @returns
   */
  @Computed
  get fullName() {
    hilog.error(0x01,'ComputedPge',"---------Computed----------");
    return this.firstName + ' ' + this.lastName + this.age;
  }



  name1: Name = new Name();

  build() {
    Column() {
      Text(this.lastName + ' ' + this.firstName)
      Text(this.lastName + ' ' + this.firstName)
      Divider()
      Text(`by local ${this.fullNameByAttr}`).margin(10)

      Divider()
      Text(this.fullName)
      Text(this.fullName)
      Button('changed lastName').onClick(() => {
        this.lastName += 'a';
      })

      Button('changed age').onClick(() => {
        this.age++;  // 无法触发Computed
      })
      Divider().margin(10)
      Text(this.name1.fullName)
      Text(this.name1.fullName)
      Button('changed lastName').onClick(() => {
        this.name1.lastName += 'a';
      })
    }
  }
}

//在@ObservedV2装饰的类中使用计算属性
@ObservedV2
class Name {
  @Trace firstName: string = 'Li';
  @Trace lastName: string = 'Hua';

  @Computed
  get fullName() {
    console.info('---------Computed----------');
    return this.firstName + ' ' + this.lastName;
  }
}