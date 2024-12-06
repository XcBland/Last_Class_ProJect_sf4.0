import { ExceptionListModel } from "."

// 定义路由传参数据类型
export class CommonRouterParams {
  id?: string = ""
  oldTime?: string = ""
  address?: string = ""
  addException?: boolean = false
  exceptionDetail?:ExceptionListModel | null = null
  startAddress?: string = ""
  endAddress?: string = ""
}