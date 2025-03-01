package usecase

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/gen"
)

type IChargeUseCase interface {
	CreateCharge(ctx *gin.Context, request gen.CreateChargeRequestObject) (gen.CreateChargeResponseObject, error)
}

type chargeUseCase struct{}

func NewChargeUseCase() IChargeUseCase {
	return &chargeUseCase{}
}
