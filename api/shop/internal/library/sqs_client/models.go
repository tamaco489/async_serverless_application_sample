package sqs_client

type PurchaseStatus string

const (
	PurchaseStatusPending    PurchaseStatus = "PENDING"    // 購入処理待ち
	PurchaseStatusProcessing PurchaseStatus = "PROCESSING" // 購入処理中
	PurchaseStatusCompleted  PurchaseStatus = "COMPLETED"  // 購入完了
	PurchaseStatusFailed     PurchaseStatus = "FAILED"     // 購入失敗
	PurchaseStatusCancelled  PurchaseStatus = "CANCELLED"  // 購入キャンセル
)

// SQSに送信するキューの構造体
type PurchaseQueueMessage struct {
	UserID  int            `json:"user_id"`
	OrderID string         `json:"order_id"`
	Status  PurchaseStatus `json:"status"`
}
