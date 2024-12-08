import { ImageList } from '.'

// 回车记录参数
export interface CarRecordParams {
  id: string // 记录ID
  startTime: string // 开始时间
  endTime: string // 结束时间
  accidentDescription: string | null // 事故描述
  accidentImagesList: ImageList[] | null // 事故图片列表
  accidentType: string | null // 事故类型
  breakRulesDescription: string | null  // 违章规则描述
  breakRulesType: string | null // 违章规则类型
  deductPoints: number | null // 扣分点数
  faultDescription: string | null // 故障描述
  faultImagesList: ImageList[] | null // 故障图片列表
  faultType: string | null  // 故障类型
  isAccident: boolean | null  // 是否事故
  isAvailable: boolean | null  // 是否可用
  isFault: boolean | null  // 是否故障
  penaltyAmount: string | null  // 处罚金额

}

export class CarRecordParamsModel implements CarRecordParams {
  id: string = ''
  startTime: string = ''
  endTime: string = ''
  accidentDescription: string | null = null
  accidentImagesList: ImageList[] | null = null
  accidentType: string | null = null
  breakRulesDescription: string | null = null
  breakRulesType: string | null = null
  deductPoints: number | null = null
  faultDescription: string | null = null
  faultImagesList: ImageList[] | null = null
  faultType: string | null = null
  isAccident: boolean | null = null
  isAvailable: boolean | null = null
  isFault: boolean | null = null
  penaltyAmount: string | null = null

  constructor(model: CarRecordParams) {
    this.id = model.id
    this.startTime = model.startTime
    this.endTime = model.endTime
    this.accidentDescription = model.accidentDescription
    this.accidentImagesList = model.accidentImagesList
    this.accidentType = model.accidentType
    this.breakRulesDescription = model.breakRulesDescription
    this.breakRulesType = model.breakRulesType
    this.deductPoints = model.deductPoints
    this.faultDescription = model.faultDescription
    this.faultImagesList = model.faultImagesList
    this.faultType = model.faultType
    this.isAccident = model.isAccident
    this.isAvailable = model.isAvailable
    this.isFault = model.isFault
    this.penaltyAmount = model.penaltyAmount
  }
}