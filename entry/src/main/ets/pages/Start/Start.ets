import { AdvertClass } from '../../models'
import { UserSettingClass } from '../../utils'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct Start {
  userSetting:UserSettingClass = new UserSettingClass(getContext(this))
  @State adObject:AdvertClass | null = null
  timer:number = -1
  async aboutToAppear() {
  //   从首选项中读取广告数据
    this.adObject = await this.userSetting.getUserAd()

  //   实现倒计时
    setInterval(() => {
      if(this.adObject?.adTime===0) {
        this.adObject.adTime = 0
        // router.replaceUrl({url:this.adObject?.adUrl})
        clearInterval(this.timer)

      } else {
        this.adObject!.adTime -= 1
      }

    }, 1000)
  }



  build() {
    Stack({alignContent: Alignment.TopEnd}) {
      Image(this.adObject?.adImg)
        .objectFit(ImageFit.Cover)
      Text(`${this.adObject?.adTime}秒后跳过`)
        .fontSize(14)
        .backgroundColor($r("app.color.background_page"))
        .padding({top: 5, bottom: 5, left: 10, right: 10})
        .height(30)
        .margin({right: 10, top: 10})
        .textAlign(TextAlign.Center)
        .borderRadius(15)
        .onClick(()=>{
          router.replaceUrl({url:this.adObject?.adUrl})
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
    .displayPriority(1000)
  }
  aboutToDisappear(){
    clearInterval(this.timer)
  }
}