package usecase

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/gen"
)

type IGemUseCase interface {
	GetGemBalance(ctx *gin.Context, request gen.GetGemBalanceRequestObject) (gen.GetGemBalanceResponseObject, error)
	UpdateGemPurchase(ctx *gin.Context, request gen.UpdateGemPurchaseRequestObject) (gen.UpdateGemPurchaseResponseObject, error)
}

type gemUseCase struct{}

func NewGemUseCase() IGemUseCase {
	return &gemUseCase{}
}
