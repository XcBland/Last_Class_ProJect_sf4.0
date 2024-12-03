import {
  CarRecordParams,
  CarRecordParamsModel,
  PickUpParams,
  PickUpParamsModel,
  TaskDetailInfoModel,
  TaskListData,
  TaskListParams
} from "../models";
import { DeliverParamsModel } from "../models/deliver";
import { Request, RequestAxios } from "../utils";

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
