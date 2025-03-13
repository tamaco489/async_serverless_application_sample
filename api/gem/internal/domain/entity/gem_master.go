package entity

import (
	"errors"

	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/domain/value_object"
)

// GemMaster はジェムのマスターデータ
type Gem struct {
	Type     value_object.GemType
	Quantity uint32
}

var GemMasterData = map[uint32]Gem{
	// 有償ジェム
	10001001: {Type: value_object.PaidGem, Quantity: 1},
	10001002: {Type: value_object.PaidGem, Quantity: 5},
	10001003: {Type: value_object.PaidGem, Quantity: 10},
	10001004: {Type: value_object.PaidGem, Quantity: 30},
	10001005: {Type: value_object.PaidGem, Quantity: 50},
	10001006: {Type: value_object.PaidGem, Quantity: 100},
	10001007: {Type: value_object.PaidGem, Quantity: 300},
	10001008: {Type: value_object.PaidGem, Quantity: 500},
	10001009: {Type: value_object.PaidGem, Quantity: 1000},
	10001010: {Type: value_object.PaidGem, Quantity: 3000},
	10001011: {Type: value_object.PaidGem, Quantity: 5000},

	// 無償ジェム
	20001001: {Type: value_object.FreeGem, Quantity: 1},
	20001002: {Type: value_object.FreeGem, Quantity: 5},
	20001003: {Type: value_object.FreeGem, Quantity: 10},
}

func GetGemMasterByID(id uint32) (Gem, error) {
	gem, exists := GemMasterData[id]
	if !exists {
		return Gem{}, errors.New("gem_id does not exist")
	}
	return gem, nil
}
