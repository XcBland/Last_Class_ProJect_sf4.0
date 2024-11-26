// 登录页需要的数据模型
export interface LoginForm {
  account: string;
  password: string;
}

export class LoginFormModel implements LoginForm {
  account: string;
  password: string;

  constructor(userInfo:LoginForm) {
    this.account = userInfo.account;
    this.password = userInfo.password;
  }
}