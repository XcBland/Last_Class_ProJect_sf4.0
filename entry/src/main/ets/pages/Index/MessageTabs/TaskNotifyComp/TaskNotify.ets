import { TaskNofityDetail } from './TaskNofityDetail'

@Component
export struct TaskNotify {
  build() {
    Column() {
      TaskNofityDetail()  // 通知的细节
    }
    .width("100%")
    .height("100%")
    .backgroundColor($r('app.color.background_page'))
  }
}