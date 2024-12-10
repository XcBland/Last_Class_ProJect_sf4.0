/**
 * @Auhtor DLY
 *
 */
import { APP_TOP_HEIGHT } from 'swift_common'
import { router } from '@kit.ArkUI'
import dayjs from '@hview/dayjs'

@Entry
@Component
struct MessageDetail {
  title: string = '详情'
  @State created: string = ''
  @State content: string = ''

  aboutToAppear(): void {
    const params = router.getParams() as messageParams
    this.created = params.created
    this.content = params.content
  }

  build() {
    Column() {
      Row().width('100%').height(AppStorage.get<number>(APP_TOP_HEIGHT))
      Row() {
        Row() {
          Text('<')
            .fontSize(26)
            .onClick(() => {
              router.back()
            })
        }
        .width('50%')

        Text(this.title).fontSize(20).fontWeight(FontWeight.Bold)
          .align(Alignment.Center)
      }
      .width('100%')

      Row() {
        Text('系统公告')
          .fontSize(18)
      }
      .margin({ top: 20 })
      .justifyContent(FlexAlign.Start)
      .width('100%')

      Row() {
        Text(dayjs(this.created).format('YYYY-MM-DD HH:mm:ss'))
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
      }
      .margin({ top: 10 })
      .width('100%')
      .justifyContent(FlexAlign.Start)

      Flex({ wrap: FlexWrap.Wrap }) {
        Text(this.content)
          .fontSize(16).lineHeight(30)
      }
      .margin({ top: 20 })
      .width('100%')
      .align(Alignment.Center)

    }
    .padding(20)
    .width('100%')
    .height('100%')

  }
}

interface messageParams {
  created: string
  content: string
}