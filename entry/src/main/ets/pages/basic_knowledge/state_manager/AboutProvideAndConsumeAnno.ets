import { ActionBar } from  '../../../comm/ActionBar';
@Entry
@Component
struct AboutProvideAndConsumeAnno {
  @Provide reviewVotes: number = 0;
  @Provide('alias_name') a: number = 0;

  build() {
    Column() {
      ActionBar({ title: '@Provide 和 @Consume' })
      Text('@Provide装饰器和@Consume装饰器：与后代组件双向同步')
        .margin(10)
        .padding(10)
        .backgroundColor(Color.Gray)
        .fontColor(Color.White)
        .borderRadius(8)
      Column() {
        Button(`reviewVotes(${this.reviewVotes}), give +1`)
          .onClick(() => this.reviewVotes += 1)

        Divider()

        Button(`a(${this.a}), give -1`)
          .onClick(() => this.a -= 1)
        CompB()
      }

    }
  }
}

@Component
struct CompD {
  @Consume reviewVotes: number;
  @Consume('alias_name') aliasName: number;

  build() {
    Column() {
      Text(`reviewVotes(${this.reviewVotes})`)

      Button(`reviewVotes(${this.reviewVotes}), give +1 `)
        .onClick(() => {
          this.reviewVotes += 1
        })

      Divider()

      Text(`aliasName (${this.aliasName})`)

      Button(`aliasName (${this.aliasName}), give -1 `)
        .onClick(() => {
          this.aliasName -= 1
        })


    }.width('40%').padding(10).backgroundColor(Color.Grey).margin(10)
  }
}

@Component
struct CompC {
  build() {
    Row({ space: 5 }) {
      CompD()
      CompD()
    }
  }
}

@Component
struct CompB {
  build() {
    CompC()
  }
}
