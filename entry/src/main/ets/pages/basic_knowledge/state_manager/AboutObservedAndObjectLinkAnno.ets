import { ActionBar } from  '../../../comm/ActionBar';
import { LengthMetrics, LengthMetricsUnit } from '@kit.ArkUI';

@Entry
@Component
struct AboutObservedAndObjectLinkAnno {
  @State user: User | undefined = undefined

  @State firstLevel:FirstLevel | undefined = undefined

  aboutToAppear(): void {

    let address: Address = new Address(10000, "北京")
    let education: Education = new Education('university', 'Master')
    this.user = new User(1, 'new User', address, education)


    let thirdLevel:ThirdLevel = new ThirdLevel('third level')
    let secondLevel:SecondLevel = new SecondLevel('second level',thirdLevel)
    this.firstLevel = new FirstLevel('first level',secondLevel)

  }

  build() {
    Column() {
      ActionBar({ title: '@Observed 和 @ObjectLink' })
      if (this.user) {
        Text(`id:${this.user.id} , name:${this.user.name}`)
        UserAddress({ address: this.user.address })
        UserEducation({ education: this.user.education })
        Flex({ wrap: FlexWrap.Wrap, space: { cross: LengthMetrics.vp(5), main: LengthMetrics.vp(5) } }) {
          Button('修改 name').onClick((_) => {
            if (this.user) {
              this.user.name += 'a'
            }
          })
          Button('修改address.location').onClick((_) => {
            if (this.user) {
              this.user.address.location += 'b'
            }
          })
          Button('修改education.degree').onClick((_) => {
            if (this.user) {
              this.user.education.degree += 'c'
            }
          })
        }
      }


      if(this.firstLevel){
        Column(){
          Text(`first level:${this.firstLevel.name}`)
          SecondLevelView({secondLevel:this.firstLevel.secondLevel}).backgroundColor('#aa42f5').margin(10)

          Flex({ wrap: FlexWrap.Wrap, space: { cross: LengthMetrics.vp(5), main: LengthMetrics.vp(5) } }) {
            Button('修改 firstLevel.name').onClick((_)=>{
              if(this.firstLevel){
                this.firstLevel.name  += 'a'
              }
            })
            Button('修改 secondLevel.name').onClick((_)=>{
              if(this.firstLevel){
                this.firstLevel.secondLevel.name  += 'a'
              }
            })
            Button('修改 thirdLevel.name').onClick((_)=>{
              if(this.firstLevel){
                this.firstLevel.secondLevel.thirdLevel.name  += 'a'
              }
            })
          }.margin(10)
        }.margin(10).padding(10).backgroundColor("#657e57")
      }
    }
  }
}


@Component
struct UserAddress {
  @ObjectLink address: Address

  build() {
    Column() {
      Text(`location:${this.address.location}`)
      Text(`zipCode:${this.address.zipCode}`)
    }.margin(10).padding(5)
  }
}

@Component
struct UserEducation {
  @Prop education: Education

  build() {
    Column() {
      Text(`school:${this.education.school}`)
      Text(`degree:${this.education.degree}`)
    }.margin(10).padding(5)
  }
}

@Observed
class User {
  id: number
  name: string
  address: Address
  education: Education

  constructor(id: number, name: string, address: Address, education: Education) {
    this.id = id;
    this.name = name;
    this.address = address;
    this.education = education;
  }
}

@Observed
class Address {
  zipCode: number
  location: string

  constructor(zipCode: number, location: string) {
    this.zipCode = zipCode;
    this.location = location;
  }
}

class Education {
  school: string
  degree: string

  constructor(school: string, degree: string) {
    this.school = school;
    this.degree = degree;
  }
}


@Observed
class FirstLevel {
  name: string
  secondLevel: SecondLevel

  constructor(name: string, secondLevel: SecondLevel) {
    this.name = name;
    this.secondLevel = secondLevel;
  }
}

@Observed
class SecondLevel {
  name: string
  thirdLevel: ThirdLevel

  constructor(name: string, thirdLevel: ThirdLevel) {
    this.name = name;
    this.thirdLevel = thirdLevel;
  }
}

@Component
struct SecondLevelView{
  @ObjectLink secondLevel:SecondLevel
  build() {
    Column(){
      Text(`second level:${this.secondLevel.name}`)
      Text(`third level name:${this.secondLevel.thirdLevel.name}`)
      ThirdLevelView({thirdLevel:this.secondLevel.thirdLevel}).backgroundColor('#846f9b').margin(10)
    }.margin(10)
  }
}

@Observed
class ThirdLevel {
  name: string

  constructor(name: string) {
    this.name = name;
  }
}

@Component
struct ThirdLevelView{
  @ObjectLink thirdLevel:ThirdLevel
  build() {
    Text(`third level: ${this.thirdLevel.name}`)
  }
}