import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
import image from '@ohos.multimedia.image';
import fileIo from '@ohos.file.fs';
import buffer from '@ohos.buffer';

export function saveImage(pixelMap: PixelMap) {
  const photoSaveOptions = new picker.PhotoSaveOptions(); // 创建文件管理器保存选项实例
  const currentTime = new Date().getTime();
  photoSaveOptions.newFileNames = [`image_${currentTime}.jpg`]; // 保存文件名（可选）
  let uri = null;
  const photoViewPicker = new picker.PhotoViewPicker();

  photoViewPicker.save(photoSaveOptions).then((photoSaveResult) => {
    uri = photoSaveResult[0];
    console.error('photoViewPicker.save to file succeed and URI is:' + uri);

    let file = fs.openSync(uri, fs.OpenMode.READ_WRITE);
    console.error('file fd: ' + file.fd);


    let buffers = new ArrayBuffer(pixelMap.getPixelBytesNumber())
    pixelMap.readPixelsToBuffer(buffers).then(() => {
      let writeLen = fs.writeSync(file.fd, buffers);
      //todo fix 相册无法显示问题
      fs.closeSync(file);
      console.error('write data to file succeed and size is:' + writeLen);
    })


  }).catch((err) => {
    console.error(`Invoke photoViewPicker.save failed, code is ${err.code}, message is ${err.message}`);
  })
}


export function saveImageDataUrl(data:string){
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
