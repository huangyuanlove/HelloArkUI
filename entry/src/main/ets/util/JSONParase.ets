import { hilog } from "@kit.PerformanceAnalysisKit";


export class JSONUtils {
  static fromJSON<T>(str: string): T {

    let result: Record<string, Object> = {};
    let json: Record<string, Object> = JSON.parse(str);

    for (let key of Object.entries(json)) {


      hilog.error(0x01, 'JSONUtils', `${JSON.stringify(key)}`)
    }
    return result as T


  }
}
