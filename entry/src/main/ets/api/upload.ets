import { request } from '@kit.BasicServicesKit'
import { BASE_URL, TOKEN_KEY } from '../constants'
import { promptAction } from '@kit.ArkUI'
import { ImageList, ResponseData } from '../models'

// 实现图片的上传
export const upLoadImage = (context: Context, files: request.File[]): Promise<ImageList[]> => {
  return new Promise(async (resolve, reject) => {
    try {
      let result: ImageList[] = [] // 用来存放上传后的图片地址
      let upLoadConfig: request.UploadConfig = {
        url: BASE_URL + "/files/imageUpload",
        header: {
          "Content-Type": "multipart/form-data",
          Authorization: AppStorage.get(TOKEN_KEY) || ""
        },
        method: "POST",
        files: files,
        data: []
      }
      const task = await request.uploadFile(context, upLoadConfig)
      task.on('complete', () => {
        // 上传成功
        resolve(result)
      })
      task.on("headerReceive", (header) => {
        // console.info("upload 24", JSON.stringify(header))
        if (header["body"]) {
          const res = JSON.parse(header["body"]) as ResponseData<string>
          if (res.code === 200) {
            result.push({ url: res.data as string }) // 返回图片的url
          }
        }
      })

      task.on("fail", () => {
        reject(new Error("上传失败"))
      })
    } catch (error) {
      promptAction.showDialog({ message: "上传失败" + error.message })
    }
  })
}