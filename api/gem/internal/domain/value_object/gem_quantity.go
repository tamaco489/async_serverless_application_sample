package value_object

import "errors"

// Quantity はジェムの数量を表す値オブジェクト
type Quantity struct {
	value uint32
}

// 最小・最大の制約
const (
	MinQuantity = 1
	MaxQuantity = 500
)

// ValidateQuantity は数量をバリデーションして作成する
func ValidateQuantity(value uint32) (Quantity, error) {
	if value < MinQuantity || value > MaxQuantity {
		return Quantity{}, errors.New("quantity must be between 1 and 500")
	}
	return Quantity{value: value}, nil
}

// Uint32 は uint32 として取得するメソッド
func (q Quantity) Uint32() uint32 {
	return q.value
}

// Uint64 は uint64 として取得するメソッド
func (q Quantity) Uint64() uint64 {
	return uint64(q.value)
}
