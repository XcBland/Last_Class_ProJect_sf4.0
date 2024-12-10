import { RequestAxios } from "swift_common"
import {
  MessageInfo,
  MessageInfoModel,
  MessagePageDataModel,
  MessagePageInfoModel,
  MessageParams
} from "../models/message"

//查询公告和任务通知接口
export const getMessage = (params: MessageParams) => {
  return RequestAxios.get<MessagePageDataModel>('/messages/page', params)
}

//获取全部已读消息列表
export const getRead = (params:"200"|"201") => {
  return RequestAxios.put<null>(`/messages/readAll/${params}`)
}

//标记已读接口
export const getReadOnly = (id: string) => {
  return RequestAxios.put<null>(`/messages/${id}`)
}