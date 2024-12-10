import dayjs from "@hview/dayjs"
import { MessageInfo, MessageInfoModel } from "../../../../models/message"
import { router } from "@kit.ArkUI"
import { getReadOnly } from "../../../../api/message"

@Component
export struct Annoucements {
  @State messageInfoModel: MessageInfoModel = new MessageInfoModel({} as MessageInfo)
  onRecord: () => void = () => {
  } // 点击记录全部已读按钮的回调函数
  onReadOnly: () => void = () => {
  } // 点击单个已读按钮的回调函数

  build() {

    Column() {
      Row({ space: 3 }) {
        if (!this.messageInfoModel.isRead) {
          Circle()
            .width(10)
            .height(10)
            .stroke(Color.Red)
            .fill(Color.Red)
        }
        Text(this.messageInfoModel.content)// 内容
          .fontSize(14)
          .fontColor($r('app.color.text_primary'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .width('60%')
        Text(dayjs(this.messageInfoModel.created).format("YYYY-MM-DD HH:mm:ss"))// 时间
          .fontSize(12)
          .fontColor($r('app.color.text_secondary'))


      }
      .height(50)
      .padding(10)
      .backgroundColor($r('app.color.white'))
      .width('100%')
      .onClick(() => {
        // 跳转到具体详情页：通过传入对应的参数
        router.pushUrl({
          url: 'pages/Index/MessageTabs/BulletinComp/messageDetail', params: {
            created: this.messageInfoModel.created,
            content: this.messageInfoModel.content
          }
        })
        this.onReadOnly()
      })

      Divider()
        .height(1)
        .backgroundColor($r('app.color.background_divider'))
    }
    .width('100%')

  }
}