import { router } from '@kit.ArkUI'
import { APP_TOP_HEIGHT, TOKEN_KEY, UserSettingClass, AdvertClass } from 'swift_common'

PersistentStorage.persistProp(TOKEN_KEY, "")

@Entry
@Component
struct Start {
  userSetting: UserSettingClass = new UserSettingClass(getContext(this))
  @State
  adObj: AdvertClass | null = null
  timer: number = -1

  async aboutToAppear() {
    //从首选项中获取广告数据
    this.adObj = await this.userSetting.getUserAd()
    //实现广告的倒计时
    this.timer = setInterval(() => {
      if (this.adObj?.adTime === 0) {
        //replaceUrl / pushUrl

        //判断用户是否已经登录过了，如果没有登录则需要先去登录页进行用户身份的审核
        //今后登录成功后，我们还会将token信息存储在PersistentStorage中，在页面中是可以直接从PersistentStorage中获取数据的
        /* router.replaceUrl({
           url: "pages/Index"
         })*/
        this.toNext()
        return
      }
      this.adObj!.adTime--
    }, 1000)
  }

  //判断需要跳转的页面
  toNext() {
    //1.从PersistentStorage中读取Token
    const token = AppStorage.get<string>(TOKEN_KEY)

    //2.判断
    if (token) {
      router.replaceUrl({ url: "pages/Index/Index" })
    } else {
      router.replaceUrl({ url: "pages/Login/Login" })
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image(this.adObj?.adImg).objectFit(ImageFit.Cover)
        .onClick(() => {
          //router.pushUrl({ url: this.adObj?.adUrl })
        })
      Text(`${this.adObj?.adTime}秒后跳过`)
        .backgroundColor($r("app.color.background_page"))
        .padding({ left: 10, right: 10 })
        .margin({ right: 20, top: AppStorage.get<number>(APP_TOP_HEIGHT) })
        .height(30)
        .fontSize(14)
        .borderRadius(15)
        .textAlign(TextAlign.Center)
        .onClick(() => {
          //router.replaceUrl({ url: "pages/Index" })
          this.toNext()
        })
    }
    .width('100%')
    .height('100%')
  }

  aboutToDisappear(): void {
    clearInterval(this.timer)
  }
}