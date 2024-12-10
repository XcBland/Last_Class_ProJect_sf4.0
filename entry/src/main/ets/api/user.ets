/*
 * 实习用户接口的调用
 * */
import {LoginFormModel, UserCarDataTypeModel, UserInfoModel, UserTaskInfoModel, UserTaskInfoParams} from '../models'
import { Request,RequestAxios } from 'swift_common'

//1.用户登录接口的调用
export const login = (data: LoginFormModel)=>{
  return RequestAxios.post<string>('/login/account', data)
}

//2.获取用户信息
export const getUserInfo = ()=>{
  return RequestAxios.get<UserInfoModel>('/users')
}

//3.获取本月任务数据
export const getUserTaskInfo = (data: UserTaskInfoParams)=>{
  return RequestAxios.get<UserTaskInfoModel>('/users/taskReport', data)
}

//4.车辆信息
export const getUserCarInfo = () => {
  return Request.get<UserCarDataTypeModel>("/users/truck")
}