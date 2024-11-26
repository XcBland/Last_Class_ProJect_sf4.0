import { LoadingDialog, router } from '@kit.ArkUI';
import { TOKEN_KEY } from '../../constants/token_key';
import { LoginFormModel } from '../../models/user';
import { UserSettingClass } from '../../utils';
import { http } from '@kit.NetworkKit';

PersistentStorage.persistProp(TOKEN_KEY,'')
@Entry
@Component
struct Login {
  @State message: string = '顺风速达';
  @State loading: boolean = false;
  @State accountForm:LoginFormModel = new LoginFormModel({account:'',password:''})
  getFormValidate(){
    if(this.accountForm.account && this.accountForm.password){
      return true
    }
    return false
  }
  build() {
    Column() {
      Text(this.message)
        .fontSize(16)
        .textAlign(TextAlign.Center)
        .margin({top: 50})
      Row(){
        Text('账号登录')
          .fontColor($r('app.color.black'))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)


        Row(){
          Text('账号登录')
            .fontColor($r('app.color.primary'))
            .fontWeight(FontWeight.Bold)
          Image($r('app.media.ic_angle'))
            .colorFilter($r('app.color.primary'))
            .width(10)
            .height(10)
            .margin({left:3})

        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({top:50,bottom:50})
      TextInput({placeholder: "请输入用户名",})
        .inputStyle()
        .onChange((value:string)=>{
          this.accountForm.account = value
        })
      TextInput({placeholder: "请输入密码",})
        .inputStyle()
        .type(InputType.Password)
        .onChange((value:string)=>{
          this.accountForm.password = value
        })
      Button("登录")
        .width('80%')
        .margin({top: 20})
        .onClick(() => {
          // 生成一个随机的token并存储在首选项和PersistStorage中
          const token = Math.random().toString(36).substring(2,15);
          // 存储token到UserSettingClass中
          new UserSettingClass(getContext(this)).setUserToken(token)
          // 存储token到AppStorage中
          AppStorage.set<string>(TOKEN_KEY, token)
          // router.replaceUrl({url:""})
          console.log('登录成功:'+token);
        })
      Button(){
        Row(){
          if(this.loading){
            LoadingProgress()
              .width(20)
              .height(20)
              .color($r('app.color.white'))
              .margin({right:12})
          }
          Text('登录').fontColor($r('app.color.white'))
        }
      }
      .onClick(async () => {
        this.loading = true;
      //调用服务器端的后台接口,完成用户身份的验证
      //   http(复习)
        const loginUrl = "http://122.51.240.24:31007/driver/login/account"
      //   1.创建请求对象:每次请求都需要创建一个新的请求对象,不可复用
        const httpRequest = http.createHttp()
      //   2.设置请求头
        const config:http.HttpRequestOptions={
          header:{
            'Content-Type': 'application/json',   //请求头设置请求数据类型为json
            'Authorization':  ''            //请求头设置token
          },
          method: http.RequestMethod.POST,
          extraData: this.accountForm
        }
      //   3.发送请求
        const res = await httpRequest.request(loginUrl, config)
      //   4.解析请求的结果
        AlertDialog.show({message:JSON.stringify(res.result)})

      })
      .width('80%')
      .margin({top: 20})
      .height(50)
      .backgroundColor(this.getFormValidate()? $r('app.color.primary_disabled'): $r('app.color.primary'))
      .enabled(this.getFormValidate())
    }
    .margin({top: 40})
    .padding({left:32,right:32})
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_page'))
  }

  @Styles
  inputStyle(){
    .backgroundColor($r('app.color.background_page'))
    .border({width:{bottom:1},color:$r('app.color.background_divider')})
    .width('100%')
    .margin({top: 20})
    .padding({left:10,right:10})
  }
}