import {
  CarRecordParams,
  CarRecordParamsModel,
  DelayParamsModel,
  PickUpParams,
  PickUpParamsModel,
  reportExceptionParamsModel,
  TaskDetailInfoModel,
  TaskListData,
  TaskListParams
} from "../models";
import { DeliverParamsModel } from "../models/deliver";
import { Request, RequestAxios } from "swift_common";

//获取任务列表
export const getTaskList = (params: TaskListParams) => {
  return RequestAxios.get<TaskListData>('/tasks/list', params)
}

// 获取任务详情
export const getTaskDetail = (id: string) => {
  return RequestAxios.get<TaskDetailInfoModel>(`/tasks/details/${id}`)
}

// 提货接口
export const pickUp = (params: PickUpParamsModel) => {
  return RequestAxios.post<null>('/tasks/takeDelivery', params)
}

// 交货接口
export const deliver = ((params: DeliverParamsModel) => {
  return RequestAxios.post<null>(`/tasks/deliver`, params)
})

// 回车登记
export const carRecord = ((params: CarRecordParamsModel) => {
  return RequestAxios.post<null>(`/tasks/truckRegistration`, params)
})

// 延迟提货
export const delayPickUp = ((params: DelayParamsModel) => {
  return RequestAxios.put<null>(`/tasks/delay`, params)
})

// 上报异常
export const reportException = ((params: reportExceptionParamsModel) => {
  return RequestAxios.post<null>(`/tasks/reportException`, params)
})

