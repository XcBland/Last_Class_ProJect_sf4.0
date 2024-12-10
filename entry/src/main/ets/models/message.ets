export interface MessageInfo {
  id: string
  title: string
  content: string
  bussinessType: number
  userId: string
  contentType: number
  isRead: number
  readTime: null
  relevantId: string
  createUser: string
  created: Date
  updateUser: string
  updated: Date
}

export class MessageInfoModel implements MessageInfo {
  id: string
  title: string
  content: string
  bussinessType: number
  userId: string
  contentType: number
  isRead: number
  readTime: null
  relevantId: string
  createUser: string
  created: Date
  updateUser: string
  updated: Date

  constructor(model: MessageInfo) {
    this.id = model.id
    this.title = model.title
    this.content = model.content
    this.bussinessType = model.bussinessType
    this.userId = model.userId
    this.contentType = model.contentType
    this.isRead = model.isRead
    this.readTime = model.readTime
    this.relevantId = model.relevantId
    this.createUser = model.createUser
    this.created = model.created
    this.updateUser = model.updateUser
    this.updated = model.updated
  }
}

export interface MessagePageDataInfo {
  counts: string
  pageSize: number
  pages: string
  page: number
  items: MessageInfo[]
}

export class MessagePageDataModel implements MessagePageDataInfo {
  counts: string
  pageSize: number
  pages: string
  page: number
  items: MessageInfoModel[]

  constructor(model: MessagePageDataInfo) {
    this.counts = model.counts
    this.pageSize = model.pageSize
    this.pages = model.pages
    this.page = model.page
    this.items = model.items.map(items => new MessageInfoModel(items))
  }
}

export interface MessagePageInfo {
  code: number
  msg: string
  data: MessagePageDataInfo
}

export class MessagePageInfoModel implements MessagePageInfo {
  code: number
  msg: string
  data: MessagePageDataModel

  constructor(model: MessagePageInfo) {
    this.code = model.code
    this.msg = model.msg
    this.data = new MessagePageDataModel(model.data)
  }
}

export interface MessageParams{
  contentType:'200' | '201'
  page:number
  pageSize:number
}
export class MessageParamsModel implements MessageParams{
  contentType: '200' | '201'
  page: number
  pageSize: number

  constructor(model: MessageParams) {
    this.contentType = model.contentType
    this.page = model.page
    this.pageSize = model.pageSize
  }
}
