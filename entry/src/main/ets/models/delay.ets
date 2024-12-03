export interface DelayParams {
  id: string
  delayReason: string
  delayTime: string
}

export class DelayParamsModel implements DelayParams {
  id: string = ''
  delayReason: string = ''
  delayTime: string = ''

  constructor(model: DelayParams) {
    this.id = model.id
    this.delayReason = model.delayReason
    this.delayTime = model.delayTime
  }
}