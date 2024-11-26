import { router } from '@kit.ArkUI';
import { TOKEN_KEY } from '../../constants/token_key';
import { UserSettingClass } from '../../utils';
PersistentStorage.persistProp(TOKEN_KEY,'')
@Entry
@Component
struct Login {
  @State message: string = '这是用户登录页';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('LoginHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
      Button("登录")
        .onClick(() => {
          // 生成一个随机的token并存储在首选项和PersistStorage中
          const token = Math.random().toString(36).substring(2,15);
          new UserSettingClass(getContext(this)).setUserToken(token)
          AppStorage.set<string>(TOKEN_KEY, token)
          // router.replaceUrl({url:""})
          console.log('登录成功:'+token);
        })
    }
    .height('100%')
    .width('100%')
  }
}