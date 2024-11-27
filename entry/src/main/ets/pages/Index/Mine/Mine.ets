@Preview
@Component
export struct Mine {
  build() {
    Column() {
      //1.基本信息
      Column({ space: 10 }) {
        Image($r('app.media.ic_avatar_driver'))
          .width(70)
          .height(70)
          .borderRadius(35)
          .backgroundColor($r('app.color.white'))
        Text('司机')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.white'))
          .lineHeight(25)
          .textAlign(TextAlign.Center)
        Text("司机编号:1111111")
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .lineHeight(20)
          .fontColor($r('app.color.white'))
          .textAlign(TextAlign.Center)
        Text("联系电话:13811111111")
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .lineHeight(20)
          .fontColor($r('app.color.white'))
          .textAlign(TextAlign.Center)

      }
      .backgroundImage($r('app.media.bg_page_my'))
      .width('100%')
      .height(255)
      .backgroundImageSize(ImageSize.Cover)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)

      //2.本月任务
      Column({ space: 10 }) {
        Text('-本月任务-')
          .fontSize(16)
          .fontColor($r('app.color.text_secondary'))
          .lineHeight(20)
          .textAlign(TextAlign.Center)
        Row() {
          Column({space:18}) {
            Text(1000 + '')
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(20)
              .textAlign(TextAlign.Center)

            Text("任务总量")
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .lineHeight(20)
              .textAlign(TextAlign.Center)
          }

          Column({space:20}) {
            Text(1000 + '')
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(20)
              .textAlign(TextAlign.Center)

            Text("完成任务量")
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .lineHeight(20)
              .textAlign(TextAlign.Center)
          }

          Column({space:20}) {
            Text(1000 + '')
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(20)
              .textAlign(TextAlign.Center)

            Text("运输里程(km)")
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .lineHeight(20)
              .textAlign(TextAlign.Center)
          }

        }
        .margin({ top: 10 })
        .justifyContent(FlexAlign.SpaceAround)
        .width('100%')
        .layoutWeight(1)
      }
      .backgroundColor($r('app.color.white'))
      .height(140)
      .width('96%')
      .borderRadius(10)
      .margin({
        top: -25,
        bottom: 10,
        left: 20,
        right: 20
      })
      .padding({ top: 15, bottom: 15 })

      //3.综合信息
      Column({space:20}){
        Row(){
          Text("车辆信息")
            .fontSize(16)
            .fontWeight(400)
            .fontColor($r('app.color.text_primary'))
          Image($r('app.media.ic_btn_more'))
            .width(20)
            .height(20)
        }
        .width('100%')
        .height(40)
        .justifyContent(FlexAlign.SpaceBetween)
        .border({width:{bottom:1 },color:$r('app.color.background_divider')})

        Row(){
          Text("任务数据")
            .fontSize(16)
            .fontWeight(400)
            .fontColor($r('app.color.text_primary'))
          Image($r('app.media.ic_btn_more'))
            .width(20)
            .height(20)
        }
        .width('100%')
        .height(40)
        .justifyContent(FlexAlign.SpaceBetween)
        .border({width:{bottom:1 },color:$r('app.color.background_divider')})

        Row(){
          Text("系统设置")
            .fontSize(16)
            .fontWeight(400)
            .fontColor($r('app.color.text_primary'))
          Image($r('app.media.ic_btn_more'))
            .width(20)
            .height(20)
        }
        .width('100%')
        .height(40)
        .justifyContent(FlexAlign.SpaceBetween)


      }
      .backgroundColor($r('app.color.white'))
      .width('96%')
      .padding({ top: 10, bottom: 10, left: 20, right: 20 })
      .borderRadius(10)
      .margin({top:10,left:20,right:20})


    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}