import { ActionBar } from '../../../comm/ActionBar';
import { systemShare } from '@kit.ShareKit';
import { fileUri } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { uniformTypeDescriptor as utd } from '@kit.ArkData';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

@Entry
@Component
struct ShareKitPage {
  @State message: string = 'Hello World';
  sharedImageUri :string =''

  build() {
    Column() {
      ActionBar({title:"ShareKit"})
      Button("从相册选择一张图片").onClick((_)=>{
        try {
          let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
          PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
          PhotoSelectOptions.maxSelectNumber = 5;
          let photoPicker = new photoAccessHelper.PhotoViewPicker();
          photoPicker.select(PhotoSelectOptions, (err: BusinessError, result: photoAccessHelper.PhotoSelectResult) => {
            if (err) {
              console.error(`PhotoViewPicker.select failed with err: ${err.code}, ${err.message}`);
              return;
            }
            console.info('PhotoViewPicker.select successfully, PhotoSelectResult uri: ' + JSON.stringify(result));
            this.sharedImageUri = result.photoUris[0]
          });
        } catch (error) {
          let err: BusinessError = error as BusinessError;
          console.error(`PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
        }
      })
      Button("开始分享").onClick((_)=>{
        this.share()
      })
    }
    .height('100%')
    .width('100%')
  }

  private async share() {
    const uiContext: UIContext = this.getUIContext();
    let utdTypeId = utd.getUniformDataTypeByFilenameExtension('.jpg', utd.UniformDataType.RAW_IMAGE);
    let shareData: systemShare.SharedData = new systemShare.SharedData({
      utd: utdTypeId,
      uri: this.sharedImageUri,
      title: 'Picture Title',
      description: 'Picture Description',
    });

    let controller: systemShare.ShareController = new systemShare.ShareController(shareData);
    const context: common.UIAbilityContext = uiContext.getHostContext() as common.UIAbilityContext;
    controller.show(context, {
      selectionMode: systemShare.SelectionMode.SINGLE,
      previewMode: systemShare.SharePreviewMode.DETAIL,
    }).then(() => {
      promptAction.showToast({
        message: '分享成功',
        duration: 2000
      })
    }).catch((error: BusinessError) => {
      promptAction.showToast({
        message: '分享失败',
        duration: 2000
      })
    });
  }
}