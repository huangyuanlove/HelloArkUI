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
