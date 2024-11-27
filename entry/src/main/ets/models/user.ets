//登录页需要的数据模型
export interface LoginForm {
  account: string
  password: string
}

export class LoginFormModel implements LoginForm {
  account: string = ""
  password: string = ""

  constructor(model: LoginForm) {
    this.account = model.account
    this.password = model.password
  }
}

export interface UserInfo {
  avatar:string
  name:string
  number:string
  phone:string
}

export class UserInfoModel implements UserInfo {
  avatar:string = ""
  name:string = ""
  number:string = ""
  phone:string = ""

  constructor(model: UserInfo) {
    this.avatar = model.avatar
    this.name = model.name
    this.number = model.number
    this.phone = model.phone
  }
}