/**
 * @Auhtor DLY
 *
 */
import { HmCard, HmCardItem, HMNavBar } from '../../components'
import { APP_TOP_HEIGHT } from '../../constants'
import { promptAction, router } from '@kit.ArkUI'
import { CommonRouterParams, DelayParams, DelayParamsModel } from '../../models'
import dayjs from '@hview/dayjs'
import { delayPickUp } from '../../api'

@Entry
@Component
struct Delay {
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

  getBtnEnabled(): boolean {
    return !!(this.delayForm.id && this.delayForm.delayTime && this.delayForm.delayReason)
  }

  async delayPickUp() {
    try {
      await delayPickUp(this.delayForm)
      promptAction.showToast({ message: "提货成功！" })
      router.back()
    } catch (e) {
      promptAction.showToast({ message: "提货失败：" + e.message })
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
          rightContent: this.delayForm.delayTime || '不可超过两小时',
          onRightClick: () => {
            DatePickerDialog.show({
              showTime: true,
              useMilitaryTime: true,
              alignment: DialogAlignment.Bottom,
              onDateAccept: (date: Date) => {
                this.delayForm.delayTime = dayjs(date).format('YYYY-MM-DD HH:mm:ss')
                // this.delayForm.delayTime = date.toISOString().replace('T', '').substring(0, 19)
              },
              dateTimeOptions: {
                minute: new Date().getMinutes().toString().padStart(2),
                hour: new Date().getHours().toString().padStart(2),
                second: new Date().getSeconds().toString().padStart(2),
                year: new Date().getFullYear().toString(),
                month: (new Date().getMonth() + 1).toString().padStart(2),
                day: new Date().getDate().toString().padStart(2)
              }
            })
          }
        })
        TextArea({ placeholder: '请输入延迟原因', text: this.delayForm.delayReason, controller: this.controller })
          .maxLength(50)
          .backgroundColor($r('app.color.background_page'))
          .height(130)
          .fontSize(18)
          .margin({ top: 30, bottom: 10 })
          .onChange((value: string) => {
            this.delayForm.delayReason = value
          })
          .showCounter(true) //显示字数统计


        Row() {
          Button('提交')
            .enabled(this.getBtnEnabled())
            .onClick(() => {
              if (this.getBtnEnabled()) {
                this.delayPickUp()
              }
            })
            .margin({ top: 10, bottom: 10 })
            .width('70%')
            .borderRadius(20)
            .backgroundColor(this.getBtnEnabled() ? $r('app.color.primary') : $r('app.color.primary_disabled'))
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