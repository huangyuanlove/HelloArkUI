
export class BaseRouterParams{

  public getInfo(){
    return "BaseRouterParams"
  }


}

export class MainRouterParams{
  name:string =''
  public getInfo(){
    return "MainRouterParams"
  }
}

export function getMainRouterInfo(params?:MainRouterParams):string{
  if(params){
    return params.name
  }
  return ""
}