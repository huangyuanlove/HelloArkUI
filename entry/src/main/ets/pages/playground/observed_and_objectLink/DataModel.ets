

@Observed
export class Root{
  firstLevel:FirstLevel[] = []
}

@Observed
export class FirstLevel{

  contents:SecondLevel[]=[]

}

@Observed
export class SecondLevel{

  value:number = 0
  max:number = 0
}