package entity

import (
	"errors"

	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/domain/value_object"
)

// GemPack: ジェムのオブジェクト
type GemPack struct {
	// ジェムの種別（有償or無償）
	Type value_object.GemType

	// 1パックあたりのジェムの数量
	PackQuantity uint32
}

var GemMasterData = map[uint32]GemPack{
	// 有償ジェム
	10001001: {Type: value_object.PaidGem, PackQuantity: 1},
	10001002: {Type: value_object.PaidGem, PackQuantity: 5},
	10001003: {Type: value_object.PaidGem, PackQuantity: 10},
	10001004: {Type: value_object.PaidGem, PackQuantity: 30},
	10001005: {Type: value_object.PaidGem, PackQuantity: 50},
	10001006: {Type: value_object.PaidGem, PackQuantity: 100},
	10001007: {Type: value_object.PaidGem, PackQuantity: 300},
	10001008: {Type: value_object.PaidGem, PackQuantity: 500},
	10001009: {Type: value_object.PaidGem, PackQuantity: 1000},
	10001010: {Type: value_object.PaidGem, PackQuantity: 3000},
	10001011: {Type: value_object.PaidGem, PackQuantity: 5000},

	// 無償ジェム
	20001001: {Type: value_object.FreeGem, PackQuantity: 1},
	20001002: {Type: value_object.FreeGem, PackQuantity: 5},
	20001003: {Type: value_object.FreeGem, PackQuantity: 10},
}

func GetGemPackByID(id uint32) (GemPack, error) {
	gem, exists := GemMasterData[id]
	if !exists {
		return GemPack{}, errors.New("gem_id does not exist")
	}
	return gem, nil
}
