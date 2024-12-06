import { HmCard, HmCardItem, HMNavBar } from '../../components'
import { APP_TOP_HEIGHT } from '../../constants'
import { CommonRouterParams, ExceptionList, ExceptionListModel, ImageList } from '../../models'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct ExceptionDetail {
  @State exceptionForm: ExceptionListModel = new ExceptionListModel({} as ExceptionList)

  aboutToAppear() {
    const params = router.getParams() as CommonRouterParams
    if (params && params.exceptionDetail) {
      this.exceptionForm = params.exceptionDetail
    }
  }

  build() {
    Column() {
      Row()
        .width('100%')
        .height(AppStorage.get<number>(APP_TOP_HEIGHT))
        .backgroundColor($r("app.color.white"))
      HMNavBar({ title: "异常详情" })
      HmCard() {
        HmCardItem({ leftTitle: "异常时间", rightContent: this.exceptionForm.exceptionTime, showRightIcon: false })
        HmCardItem({ leftTitle: "上报位置", rightContent: this.exceptionForm.exceptionPlace, showRightIcon: false })
        HmCardItem({ leftTitle: "异常类型", rightContent: this.exceptionForm.exceptionType, showRightIcon: false })
        HmCardItem({
          leftTitle: "异常描述",
          rightContent: "",
          showRightIcon: false,
          showBorder: false
        })
        Row() {
          Text(this.exceptionForm?.exceptionDescribe).fontSize(14).fontColor($r("app.color.text_primary"))
        }
        .width('100%')
        .padding(15)
        .justifyContent(FlexAlign.Start)
      }

      HmCard() {
        Text("异常图片")
          .width('100%')
          .padding(10)
        if (this.exceptionForm?.exceptionImagesList?.length > 0) {
          Flex({ wrap: FlexWrap.Wrap, direction: FlexDirection.Row }) {
            ForEach(this.exceptionForm.exceptionImagesList, (item: ImageList) => {
              Image(item.url)
                .width(100)
                .aspectRatio(1)
                .borderRadius(8)
                .margin({ right: 15 })
            })
          }
          .width('100%')
          .margin({ top: 15, bottom: 15 })
        }
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r("app.color.background_page"))
  }
}