export type AnalysisTotalTypes = {
  totalAmt: number
  totalQty: number
  minQty: number
  maxQty: number
  noCheck: number
  noPass: number
  saleAmt: number
  saleQty: number
}

export type UserAccessSource = {
  value: number
  name: string
}

export type WeeklyUserActivity = {
  value: number
  name: string
}

export type MonthlySales = {
  name: string
  estimate: number
  actual: number
}
