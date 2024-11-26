import { TOKEN_KEY } from '../../constants';
import { LoginFormModel } from '../../models';
import { http } from '@kit.NetworkKit';
import axios, { AxiosRequestConfig } from '@ohos/axios';

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
        this.showLoading = true
        //调用服务器端的后台接口完成用户身份的验证
        const loginUrl = "http://122.51.240.24:31007/driver/login/account"
        /*//1.创建请求对象,注意：每次请求时都需要创建一个新的，不可复用
        const httpRequest = http.createHttp()
        //2.设置请求头
        const config: http.HttpRequestOptions = {
          header: {
            "Content-Type": "application/json", //请求数据的类型
            "Authorization": "" //令牌
          },
          method: http.RequestMethod.POST,
          extraData: this.accountForm
        }
        //3.发送请求
        const res = await httpRequest.request(loginUrl, config)
        //4.解析请求的结果
        AlertDialog.show({ message: JSON.stringify(res) })*/

        const axiosCreate = axios.create()
        const axiosResponse:AxiosRequestConfig = await axiosCreate.request({
          url: loginUrl,
          method: "POST",
          data: this.accountForm,
          headers: {
            "Content-Type": "application/json",
            "Authorization": ""
          }
        })

        AlertDialog.show({ message: JSON.stringify(axiosResponse.data) })



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