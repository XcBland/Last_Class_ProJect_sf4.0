/**
 * @Auhtor DLY
 *
 */
import { HmCard, HmCardItem, HMNavBar } from '../../components'
import { APP_TOP_HEIGHT } from '../../constants'
import { router } from '@kit.ArkUI'
import { CommonRouterParams, DelayParams, DelayParamsModel } from '../../models'

@Entry
@Component
struct Delay {
  @State text: string = ''
  @State oldTime: string = ""
  @State delayForm: DelayParamsModel = new DelayParamsModel({} as DelayParams)
  controller: TextAreaController = new TextAreaController()

  aboutToAppear(): void {
    const params = router.getParams() as CommonRouterParams
    if (params && params.id && params.oldTime) {
      this.oldTime = params.oldTime
      this.delayForm.id = params.id
    }
  }

  build() {
    Column() {
      Row().width('100%').height(AppStorage.get<number>(APP_TOP_HEIGHT)).backgroundColor($r('app.color.white'))
      HMNavBar({ title: '延迟提货' })
      HmCard() {
        HmCardItem({ leftTitle: '原定时间', rightContent: "", showRightIcon: false })
        HmCardItem({
          leftTitle: '延迟时间',
          rightContent: "不可超过两个小时",
          onRightClick: () => {

          }
        })
        TextArea({ placeholder: '请输入延迟原因', text: this.text, controller: this.controller })
          .maxLength(50)
          .backgroundColor($r('app.color.background_page'))
          .height(130)
          .fontSize(18)
          .margin({ top: 30, bottom: 10 })
          .onChange((value: string) => {
            this.text = value
          })
          .showCounter(true) //显示字数统计


        Row() {
          Button('提交')
            .onClick(() => {
            })
            .margin({ top: 10, bottom: 10 })
            .width('70%')
            .borderRadius(20)
            .backgroundColor($r('app.color.primary'))
            .type(ButtonType.Normal)
        }
        .justifyContent(FlexAlign.Center)
        .padding({ top: 10, bottom: 10 })
        .width('100%')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_page'))

  }
}