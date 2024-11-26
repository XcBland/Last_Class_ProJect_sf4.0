import { AdvertClass } from '../../models'
import { UserSettingClass } from '../../utils'
import { router } from '@kit.ArkUI'
import { TOKEN_KEY } from '../../constants'

PersistentStorage.persistProp(TOKEN_KEY, "")

@Entry
@Component
struct Start {
  userSetting: UserSettingClass = new UserSettingClass(getContext(this))
  @State adObject: AdvertClass | null = null
  timer: number = -1

  async aboutToAppear() {
    //   从首选项中读取广告数据
    this.adObject = await this.userSetting.getUserAd()

    //   实现倒计时
    setInterval(() => {
      if (this.adObject?.adTime === 0) {
        this.adObject.adTime = 0
        // 判断用户是否已经登陆过了,如果没有登录则需要先去登录页进行用户身份的审核
        // 今后登录成功后,我们还会将token信息存储在PersistentStorage中,以便下次直接读取
        // 在页面中可以直接从PersistentStorage中读取token信息,然后进行用户身份的审核

        // router.replaceUrl({url:this.adObject?.adUrl})
        // clearInterval(this.timer)
        this.toNext()
        return
      }
      this.adObject!.adTime -= 1
    }, 1000)
  }

  // 判断需要跳转的页面
  toNext() {
    //   1.从PersistentStoraget中读取token信息
    const token = AppStorage.get<string>(TOKEN_KEY)
    //   2.判断用户是否已经登陆过了,如果没有登录则需要先去登录页进行用户身份的审核
    if (token) {
      router.replaceUrl({ url: 'pages/Index' })
      clearInterval(this.timer)
    } else {
      router.replaceUrl({ url: 'pages/Login/Login' })
      clearInterval(this.timer)
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image(this.adObject?.adImg)
        .objectFit(ImageFit.Cover)
      Text(`${this.adObject?.adTime}秒后跳过`)
        .fontSize(14)
        .backgroundColor($r("app.color.background_page"))
        .padding({
          top: 5,
          bottom: 5,
          left: 10,
          right: 10
        })
        .height(30)
        .margin({ right: 10, top: 10 })
        .textAlign(TextAlign.Center)
        .borderRadius(15)
        .onClick(() => {
          this.toNext()
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
    .displayPriority(1000)
  }

}