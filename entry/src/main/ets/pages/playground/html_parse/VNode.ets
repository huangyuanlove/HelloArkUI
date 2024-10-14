
export class VNode{
  backgroundColor:string|Resource|Color=Color.Transparent
  //如果有backGround属性需要返回 ContainerSpan
  fontSize:number = 12
  fontColor:string|Resource|Color = Color.Black
  hrefFontColor:string|Resource|Color = Color.Blue
  href:string | undefined
  text:string=''
  child?:VNode[]=[]
}
