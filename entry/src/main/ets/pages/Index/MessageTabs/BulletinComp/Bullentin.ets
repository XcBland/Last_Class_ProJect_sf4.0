import { HmCard, HmCardItem, HmLoading, HmSkeleton } from 'swift_common'
import { MessageClass, MessageInfo, MessagePageDataInfo, MessageParams, MessageParamsModel } from '../../../../models'
import { vibrator } from '@kit.SensorServiceKit'
import { Annoucements } from './Annoucements'
import { getMessage, getRead, getReadOnly } from '../../../../api/message'


@Component
export struct Bullentin {
  @State messageList: MessageInfo[] = [] //返回的数据类型
  @State queryParams: MessageParams = new MessageParamsModel({
    contentType: '200',
    page: 1,
    pageSize: 5
  } as MessageParams) //查询的参数
  allPage: number = 1 //总页数
  @State loading: boolean = false //是否正在加载数据
  @State refreshing: boolean = false //是否正在刷新数据
  @State str: string = '下拉刷新' //刷新提示语
  @State refreshStatus: RefreshStatus = RefreshStatus.Inactive //刷新状态
  @State reset: boolean = false //是否重置查询条件
  layer: CustomDialogController = new CustomDialogController({
    builder: HmLoading({ loadingText: '正在搜索中，请稍后...' }),
    customStyle: true,
    autoCancel: true,
    alignment: DialogAlignment.Center
  }) //弹窗控制器

  //获取任务列表数据
  async getMessageList(append: boolean) {
    const result = await getMessage(this.queryParams)
    this.allPage = result.pageSize //总页数
    if (append) {
      this.messageList = this.messageList.concat(result.items || []) //合并数据
    } else {
      this.messageList = result.items || [] //更新数据
    }
    this.queryParams.page++
    append = true
  }

  /*获取底部显示*/
  @Builder
  getBottomDisplay() {
    Row() {
      if (this.loading) {
        Text(this.allPage < this.queryParams.page ? '没有更多数据了' : '正在加载...')
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
        if (this.allPage >= this.queryParams.page) {
          HmLoading({ hWidth: 20 })
        }
      }
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  /*刷新数据*/
  onRefresh() {
    // this.getRefreshDisplay()
    this.refreshing = true
    this.messageList = []
    this.queryParams.page = 1
    this.allPage = 1
    this.getMessageList(false)
    setTimeout(() => {
      this.refreshing = false
      this.loading = false
    }, 1000)

  }

  /*获取刷新状态*/
  getStatusText() {
    switch (this.refreshStatus) {
      case RefreshStatus.Drag:
        return '下拉刷新'
      case RefreshStatus.OverDrag:
        return '超过刷新距离，松开立即刷新'
      case RefreshStatus.Refresh:
        return '正在刷新...'
      case RefreshStatus.Done:
        return '刷新完成'
      default:
        return ''
    }
  }

  /*获取刷新提示语*/
  @Builder
  getRefreshDisplay() {
    Row({ space: 10 }) {
      LoadingProgress()
        .width(40)
        .aspectRatio(1)
        .color($r('app.color.text_secondary'))
      Text(this.getStatusText())
        .fontSize(16)
        .fontColor($r('app.color.text_secondary'))
    }
    .width('100%')
    .height(50)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  /*清空已读*/
  async onFlush() {
    try {
      await getRead('200')
      this.messageList = this.messageList.map(item => {
        item.isRead = 1
        return item
      })
    } catch (e) {
      console.log(e)
    }
  }

  async onReadOnly(item: MessageInfo) {
    try {
      await getReadOnly(item.id)
      item.isRead = 1
      this.messageList = [...this.messageList]
    } catch (e) {
      console.log(e)
    }
  }

  build() {
    Column() {
      Row({ space: 5 }) {
        Image($r('app.media.ic_yidu'))
          .width(24).height(24)
        Text('全部已读')
          .fontColor($r('app.color.text_primary'))
          .fontSize(14)
      }
      .onClick(() => {
        this.onFlush()
      })
      .height(40).width('100%')

      // 刷新内容
      Refresh({ refreshing: $$this.refreshing, builder: this.getRefreshDisplay() }) {
        List() {
          if (this.messageList.length === 0) {
            HmSkeleton()
          } else {
            ForEach(this.messageList, (item: MessageInfo, index: number) => {
              ListItem() {
                //公告卡片
                Annoucements({
                  messageInfoModel: item,
                  onRecord: () => {
                    this.onFlush()
                  },
                  onReadOnly: () => {
                    this.onReadOnly(item)
                  }
                })
              }
            })

            ListItem() {
              //   列表底部显示加载状态
              this.getBottomDisplay()
            }

          }

        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
        .onReachEnd(async () => {
          if (this.allPage >= this.queryParams.page) {
            if (!this.loading) {
              this.loading = true //开始加载数据
              await this.getMessageList(true)
              this.loading = this.allPage < this.queryParams.page ? true : false //如果没有更多数据了，则停止加载
            }
          }
        })
      }
      .onStateChange((status: RefreshStatus) => {
        this.refreshStatus = status //刷新状态
        if (status === RefreshStatus.Drag) {
          this.str = '下拉刷新'
        } else if (status === RefreshStatus.OverDrag) {
          this.str = '超过刷新距离，松开立即刷新'
        } else if (status === RefreshStatus.Refresh) {
          this.str = '正在刷新...'
          setTimeout(() => {
            this.onRefresh()
            vibrator.startVibration({ duration: 300, type: 'time' }, { id: 0, usage: "touch" })
          }, 3000)
        } else if (status === RefreshStatus.Done) {
          this.str = '刷新完成'
        }
      })
    }
    .width('100%')
    .height('100%')
  }
}
