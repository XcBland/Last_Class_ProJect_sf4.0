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

// 个人信息页需要的数据模型
export interface UserInfo {
  avatar: string
  name: string
  number: string
  phone: string
}

export class UserInfoModel implements UserInfo {
  avatar: string = ""
  name: string = ""
  number: string = ""
  phone: string = ""

  constructor(model: UserInfo) {
    this.avatar = model.avatar
    this.name = model.name
    this.number = model.number
    this.phone = model.phone
  }
}

// 封装本月任务接口的相关数据：请求数据、响应数据
// 请求数据
export interface UserTaskInfoParams {
  year: string
  month: string
}

export class UserTaskInfoParamsModel implements UserTaskInfoParams {
  year: string = ""
  month: string = ""

  constructor(model: UserTaskInfoParams) {
    this.month = model.month
    this.year = model.year
  }
}

// 响应数据
// 日常里程
export interface DailyMileage {
  dateTime: string | null // 日期
  mileage: number|null // 里程
}
export class DailyMileageModel implements DailyMileage {
  dateTime: string | null = null
  mileage: number|null = null

  constructor(model: DailyMileage) {
    this.dateTime = model.dateTime
    this.mileage = model.mileage
  }
}

// 任务信息
export interface UserTaskInfo {
  completedAmounts: number // 已完成任务总金额
  dailyMileage: DailyMileage[] // 日常里程
  taskAmounts: number // 任务总金额
  transportMileage: number // 运输里程
}
export class UserTaskInfoModel implements UserTaskInfo {
  completedAmounts: number  = 0
  dailyMileage: DailyMileage[]  = []
  taskAmounts: number  = 0
  transportMileage: number  = 0

  constructor(model: UserTaskInfo) {
    this.completedAmounts = model.completedAmounts
    this.dailyMileage = model.dailyMileage?.map(item => new DailyMileageModel(item))
    this.taskAmounts = model.taskAmounts
    this.transportMileage = model.transportMileage
  }

}
