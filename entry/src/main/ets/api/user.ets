/*
 * 实习用户接口的调用
 * */
import {LoginFormModel, UserInfoModel, UserTaskInfoModel, UserTaskInfoParams} from '../models'
import { Request } from '../utils'

//1.用户登录接口的调用
export const login = (data: LoginFormModel)=>{
  return Request.post<string>('/login/account', data)
}

//2.获取用户信息
export const getUserInfo = ()=>{
  return Request.get<UserInfoModel>('/users')
}

//3.获取本月任务数据
export const getUserTaskInfo = (data: UserTaskInfoParams)=>{
  return Request.get<UserTaskInfoModel>('/users/taskReport', data)
}