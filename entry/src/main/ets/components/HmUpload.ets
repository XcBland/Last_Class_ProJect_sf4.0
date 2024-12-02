// import uploadFile from "../utils/uploadAnddownload"
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { ImageList } from '../models'

@Component
export struct HmUpload {
  title: string = ""
  maxSelected: number = 6
  @State imgList: ImageList[] = []

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
    }


  }

  build() {
    Column() {
      Text(this.title)
        .fontSize(14)
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 10, bottom: 10 })

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
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}