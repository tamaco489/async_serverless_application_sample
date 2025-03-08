package models

// SQSメッセージの構造体
type PurchaseQueueMessage struct {
	UserID  uint64         `json:"user_id"`
	OrderID string         `json:"order_id"`
	Status  PurchaseStatus `json:"status"`
}

type PurchaseStatus string

const (
	PurchaseStatusPending    PurchaseStatus = "PENDING"    // 購入処理待ち
	PurchaseStatusProcessing PurchaseStatus = "PROCESSING" // 購入処理中
	PurchaseStatusCompleted  PurchaseStatus = "COMPLETED"  // 購入完了
	PurchaseStatusFailed     PurchaseStatus = "FAILED"     // 購入失敗
	PurchaseStatusCancelled  PurchaseStatus = "CANCELLED"  // 購入キャンセル
)

func (p PurchaseStatus) String() string {
	return string(p)
}
