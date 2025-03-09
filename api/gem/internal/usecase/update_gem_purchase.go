package usecase

import (
	"time"

	"github.com/gin-gonic/gin"
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/gen"
)

func (u *gemUseCase) UpdateGemPurchase(ctx *gin.Context, request gen.UpdateGemPurchaseRequestObject) (gen.UpdateGemPurchaseResponseObject, error) {

	time.Sleep(750 * time.Millisecond)

	return gen.UpdateGemPurchase201JSONResponse{
		Balance:       100000,
		TransactionId: "tx_purchase_001",
	}, nil
}
