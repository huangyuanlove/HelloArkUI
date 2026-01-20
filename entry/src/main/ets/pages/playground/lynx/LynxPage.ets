import {
  LynxTemplateResourceFetcher,
  LynxMediaResourceFetcher,
  LynxGenericResourceFetcher,
  LynxView,
} from '@lynx/lynx';
import { ExampleGenericResourceFetcher } from '../../../util/lynx/ExampleGenericResourceFetcher';
import { ExampleMediaResourceFetcher } from '../../../util/lynx/ExampleMediaResourceFetcher';
import { ExampleTemplateResourceFetcher } from '../../../util/lynx/ExampleTemplateResourceFetcher';

@Entry
@Component
struct Index {
  templateResourceFetcher: LynxTemplateResourceFetcher = new ExampleTemplateResourceFetcher();
  mediaResourceFetcher: LynxMediaResourceFetcher = new ExampleMediaResourceFetcher();
  genericResourceFetcher: LynxGenericResourceFetcher = new ExampleGenericResourceFetcher();
  private url: string = 'main.lynx.bundle';//上面放在 rawFile 文件夹下的文件名字

  build() {
    Column() {
      LynxView({
        templateResourceFetcher: this.templateResourceFetcher,
        mediaResourceFetcher: this.mediaResourceFetcher,
        genericResourceFetcher: this.genericResourceFetcher,
        url: this.url,
      }).width('100%').height('100%');
    }
    .size({ width: '100%', height: '100%' })
  }
}