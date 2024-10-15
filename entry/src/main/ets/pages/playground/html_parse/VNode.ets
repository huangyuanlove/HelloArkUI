
export class VNode{

  href:string | undefined
  text:string=''
  child?:VNode[]=[]
  style:Style= new Style()
}

export class Style{
  backgroundColor:string|Resource|Color=Color.Transparent
  //如果有backGround属性需要返回 ContainerSpan
  fontSize:number = 16
  fontColor:string|Resource|Color = Color.Black
  hrefFontColor:string|Resource|Color = Color.Blue
}