export * from "./common"
export * from "./advert"


//服务器端所有接口返回的数据类型
export class ResponseData<T> {
  code: number = 0
  message: string = ''
  data: T | null = null
}