import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
import fileIo from '@ohos.file.fs';
import buffer from '@ohos.buffer';
import mediaLibrary from '@ohos.multimedia.mediaLibrary';


async function saveImageBuffer(buffer: ArrayBuffer) {
  let fileAsset = await this.mediaUtil.createAndGetUri(mediaLibrary.MediaType.IMAGE)

  let photoUri = this.fileAsset.uri


  this.fd = await this.mediaUtil.getFdPath(this.fileAsset)


  await fileIo.write(this.fd, buffer)

  await this.fileAsset.close(this.fd)
}


export function saveImageDataUrl(data: string) {
  let uri = '';
  try {
    let photoSaveOptions = new picker.PhotoSaveOptions();
    //保存图片默认名称
    const currentTime = new Date().getTime();
    photoSaveOptions.newFileNames = [`image_${currentTime}.png`]; // 保存文件名（可选）
    let photoPicker = new picker.PhotoViewPicker();
    //调起系统的图片保存功能
    photoPicker.save(photoSaveOptions).then((PhotoSaveResult) => {
      uri = PhotoSaveResult[0];
      //打开文件
      let file = fs.openSync(uri, fs.OpenMode.READ_WRITE);
      //base64字符串转成buffer
      const decodeBuffer = buffer.from(data, 'base64').buffer;
      //写入文件
      fs.writeSync(file.fd, decodeBuffer);
      //关闭文件
      fs.closeSync(file);
    }).catch((err: Error) => {
      console.error(err + '');
    })
  } catch (e) {
    console.error(e);
  }
}
