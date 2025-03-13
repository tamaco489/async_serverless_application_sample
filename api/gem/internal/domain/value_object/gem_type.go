package value_object

import "errors"

// GemType はジェムの種類を表す独自の型
type GemType string

// 許可されるジェムの種類
const (
	PaidGem GemType = "paid"
	FreeGem GemType = "free"
)

// ValidateGemType はバリデーション済みの GemType を作成
func ValidateGemType(value string) (GemType, error) {
	switch GemType(value) {
	case PaidGem, FreeGem:
		return GemType(value), nil
	default:
		return "", errors.New("invalid gem type")
	}
}

// String は GemType を文字列として取得
func (gt GemType) String() string {
	return string(gt)
}
