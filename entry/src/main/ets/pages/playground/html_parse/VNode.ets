
export class VNode{
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
  href:string | undefined
}
export function copyStyle(style?:Style):Style{
  let tmp:Style = new Style()
  if(style){
    tmp.backgroundColor = style.backgroundColor
    tmp.fontSize = style.fontSize
    tmp.fontColor = style.fontColor
    tmp.hrefFontColor = style.hrefFontColor
    tmp.href = style.href
  }


  return tmp;
}