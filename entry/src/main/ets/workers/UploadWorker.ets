import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, util, worker } from '@kit.ArkTS';
import { ImageList } from 'swift_common';
import { image } from '@kit.ImageKit';
import { fileIo } from '@kit.CoreFileKit';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

export class PostParams {
  files: ImageList[] = [];
  filePath: string = "";
}

/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessage = async (e: MessageEvents) => {
  const params = e.data as PostParams
  // 进行图片压缩
  let arr: ImageList[] = []
  if (params && params.files) {
    const imagePacker = image.createImagePacker() // 创建图片压缩器
    let packOps: image.PackingOption = { format: "image/jpeg", quality: 20 }
    while (params.files.length) {
      const obj = params.files.pop() // 取照片，取一张少一张
      const sourceFile = fileIo.openSync(obj?.url, fileIo.OpenMode.READ_ONLY) // 打开图片文件
      const newFileName = params.filePath + "/" + util.generateRandomUUID() + "_2.jpg" // 生成新的文件名
      const targetFile = fileIo.openSync(newFileName, fileIo.OpenMode.WRITE_ONLY) // 打开新的文件

      // 进行压缩
      await imagePacker.packToFile(image.createImageSource(sourceFile.fd), targetFile.fd, packOps)
      fileIo.closeSync(sourceFile.fd)
      fileIo.closeSync(targetFile.fd)
      arr.push({ url: newFileName }) // 将压缩后的图片路径添加到数组中
    }
  }

  // 进行复杂图片的压缩逻辑

  // 将压缩完成的图片回传给主线程
  workerPort.postMessage({ files: arr });
  workerPort.close()
}

/**
 * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
 * The event handler is executed in the worker thread.
 *
 * @param e message data
 */
workerPort.onmessageerror = (e: MessageEvents) => {
}

/**
 * Defines the event handler to be called when an exception occurs during worker execution.
 * The event handler is executed in the worker thread.
 *
 * @param e error message
 */
workerPort.onerror = (e: ErrorEvent) => {
}