
@Entry
@Component
export default  struct PlayGround {
  @State people:People = new People('测试人员 1')
  showAddress():boolean{
    if(this.people){
      if(this.people.address){
        console.error('------ address not null ------')
        return true
      }else{
        console.error('------ address is null ------')
        return false
      }
    }
    console.error('------ people is null ------')
    return false;
  }
  build() {
    Column(){
      if(this.people){
        Text(`姓名：${this.people.name}`)
        if(this.showAddress()){
          Text(`地址：${this.people.address.name}`)
        }
      }
      Button('设置地址').onClick(()=>{
        if(this.people){
          let tmpAddress = new Address()
          tmpAddress.name = '测试地址'
          tmpAddress.zipCode = -1
          this.people.address = tmpAddress
        }
      }).margin(10)
      Button('网络请求后返回没有地址的空对象').onClick(()=>{
         let tmpPeople:People = new People('测试人员 1')
        this.people = tmpPeople
      }).margin(10)
    }.margin({top:48})
  }
}

class Address{
  name:string
  zipCode:number
}
class People{
  constructor(name:string) {
    this.name = name
  }

   name:string
   address:Address
}
