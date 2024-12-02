// import uploadFile from "../utils/uploadAnddownload"
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { ImageList } from '../models'
import { HmPreview } from './HmPreview'
import { fileIo as fs } from '@kit.CoreFileKit'
import { util } from '@kit.ArkTS'
import { request } from '@kit.BasicServicesKit'
import { upLoadImage } from '../api/upload'

@Component
export struct HmUpload {
  title: string = ""
  maxSelected: number = 6
  @State selectIndex: number = 0
  // 图片数组以及利用一个函数onListChange来触发父组件的list更新，父组件通过props接收
  @Prop imgList: ImageList[] = []
  onListChange: (list: ImageList[]) => void = () => {
  }
  preview: CustomDialogController = new CustomDialogController({
    builder: HmPreview({
      urls: this.imgList.map(item => item.url), // 图片数组
      selectIndex: this.selectIndex // 默认选中第一张图片
    }),
    customStyle: true,
    alignment: DialogAlignment.Center,
    autoCancel: true
  })

  // 弹出相册选择器
  async selectImage() {
    const photoSelectOptions = new photoAccessHelper.PhotoViewPicker()
    const result = await photoSelectOptions.select({
      MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE, // 选择图片类型
      maxSelectNumber: this.maxSelected - this.imgList.length  // 最多选择6张图片
    })
    if (result.photoUris.length) {
      this.imgList = this.imgList.concat(result.photoUris.map(url => {
        return { url } as ImageList
      }))
      this.onListChange(this.imgList) // 触发父组件的list更新
    }
  }

  // 实现提货功能


  build() {
    Column() {
      Text(this.title)
        .fontSize(14)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 10, bottom: 10 })

      Grid() {
        ForEach(this.imgList, (item: ImageList, index: number) => {
          GridItem() {
            Image(item.url)
              .width(95)
              .height(95)
              .aspectRatio(1)
              .borderRadius(4)
              .onClick(() => {
                // 打开弹窗,预览图片
                this.selectIndex = index
                this.preview.open()
              })

          }
        })
        if (this.imgList.length < this.maxSelected) {
          GridItem() {
            Row() {
              Image($r('app.media.ic_add_img'))
                .width(24)
                .height(24)
                .border({ style: BorderStyle.Dotted, width: 1, color: $r('app.color.text_secondary') })
                .onClick(() => {
                  this.selectImage()
                })
            }
            .width(95)
            .height(95)
            // .padding({})
            .backgroundColor($r('app.color.background_page'))
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
          }
          .width(95)
          .height(95)

        }
      }
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)

    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}

// 实现图片上传功能
export const upLoadFile = async (list: ImageList[]) => {
  // 1.将图片拷贝到cache沙箱中
  const saveDir = getContext().cacheDir // 获取cache目录
  const fileParams: request.File[] = []
  list.forEach(img => {
    //   a.读取相册图片
    const files = fs.openSync(img.url, fs.OpenMode.READ_ONLY)
    //   b.将相册图片写入沙箱
    const uniqueName = util.generateRandomUUID() + '.jpg' // 给图片文件命名
    fs.copyFileSync(files.fd, saveDir + "/" + uniqueName)
    //  c.构建图片的file类型
    fileParams.push({
      filename: uniqueName,
      type: 'jpg',
      uri: "internal://cache/" + uniqueName,
      name: "file"  // 和后端的上传接口中的参数是对印的
    })
    fs.closeSync(files)
  })
  // 2.调用后端接口实现图片上传
  return await upLoadImage(getContext(), fileParams)

}