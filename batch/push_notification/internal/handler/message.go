package handler

// SQSメッセージの構造体
type sqsMessage struct {
	OrderID string `json:"order_id"`
	Status  string `json:"status"`
	UserID  uint64 `json:"user_id"`
}
