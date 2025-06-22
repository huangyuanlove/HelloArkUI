

export class ObjectUtils{

  static deepCopy<T>(source:T,target:T):T{

    if (source === undefined || source === null) {
      return source; //为undefined和null
    }




    for (let key of Object.keys(source)) {
      if (typeof source[key] === 'object') {
        target[key] = ObjectUtils.deepCopy(source[key],target[key]);
      } else {
        target[key] = source[key];
      }
    }
    return target;

  }

}
