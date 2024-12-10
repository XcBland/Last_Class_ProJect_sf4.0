import { login } from '../../api';
import { TOKEN_KEY } from 'swift_common';
import { LoginForm, LoginFormModel } from '../../models';
import { Request, UserSettingClass } from 'swift_common';
import { promptAction, router } from '@kit.ArkUI';

PersistentStorage.persistProp(TOKEN_KEY, "")

@Entry
@Component
struct Login {
  @State showLoading: boolean = false
  @State
  accountForm: LoginFormModel = new LoginFormModel({ account: "", password: "" })

  //判断账号和密码是否为空
  getFormValidate() {
    if (this.accountForm.account && this.accountForm.password) {
      return true
    }
    return false
  }

  // 实现用户登录
  async login() {
    try{
      this.showLoading = true
      const token = await login(this.accountForm)
      AppStorage.set(TOKEN_KEY, token)
      new UserSettingClass(getContext()).setUserToken(token)
      this.showLoading = false
      promptAction.showToast({ message: "登录成功", duration: 2000 })
      router.replaceUrl({url:"pages/Index/Index"})
    }catch (error){
      promptAction.showToast({ message: error.message, duration: 2000 })
    } finally {
      this.showLoading = false
    }

  }


  build() {
    Column() {
      Text("顺风速达")
        .fontColor($r("app.color.text_primary"))
        .fontSize(18)
        .height(25)
      Row() {
        Text("账号登录")
          .fontColor($r("app.color.text_primary"))
          .fontSize(24)
          .fontWeight(FontWeight.Bold)

        Row() {
          Text("账号登录")
            .fontColor($r("app.color.primary"))
            .fontWeight(FontWeight.Bold)
          Image($r("app.media.ic_angle"))
            .width(10)
            .aspectRatio(1)
            .margin({ left: 5 })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 50, bottom: 50 })

      TextInput({ placeholder: "请输入账号" })
        .inputStyle()
        .onChange((value: string) => {
          this.accountForm.account = value
        })

      TextInput({ placeholder: "请输入密码" })
        .type(InputType.Password)
        .inputStyle()
        .onChange((value: string) => {
          this.accountForm.password = value
        })
        .onSubmit(async () => {
          // 点击登录按钮时，如果账号和密码都不为空，则调用登录接口
          if (this.getFormValidate()) {
            await this.login()
          }
        })

      Button() {
        Row() {
          //按钮也是一个容器组件，里面只能放一个子组件
          if (this.showLoading) {
            LoadingProgress()
              .width(20)
              .height(20)
              .color($r("app.color.white"))
              .margin({ right: 12 })
          }

          Text("登录").fontColor($r("app.color.white"))
        }
      }
      .backgroundColor(this.getFormValidate() ? $r("app.color.primary") : $r("app.color.primary_disabled"))
      .enabled(this.getFormValidate())
      .width('100%')
      .height(50)
      .margin({ top: 50 })
      .onClick(async () => {
        if (this.getFormValidate()) {
          await this.login()
        }

      })
    }
    .width('100%')
    .height('100%')
    .padding({ left: 32, right: 32 })
    .margin({ top: 40 })
  }

  @Styles
  inputStyle() {
    .backgroundColor(Color.White)
    .border({
      width: { bottom: 1 },
      color: $r("app.color.background_divider")
    })
    .width('100%')
    .height(58)
    .borderRadius(0)
  }
}

let myObj: object = new LoginFormModel({ account: "feiniao", password: "123456" } as LoginForm)
// 如何将一个对象转换成这种格式的字符串:account=feiniao&password=123456
let allProp = Object.keys(myObj) //获取对象的所有属性
let str = ""
allProp.map(prop => {
  if (myObj[prop]) {
    return str += prop + "=" + myObj[prop] + "&"
  }
  return ""
})
str = str.substring(0, str.length - 1) //去掉最后一个&
console.log(str)
// map是将数组中的每一项都执行一个函数，返回一个新的数组
// join是将数组中的每一项用指定字符连接起来，返回一个字符串
// let result = allProp.map(key => {
//   return `${key}=${myObj[key]}`
// }).join("&") //将数组元素用&连接起来，并替换逗号为&
// console.log(result)