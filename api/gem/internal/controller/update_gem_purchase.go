package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/gen"
)

func (c *Controllers) UpdateGemPurchase(ctx *gin.Context, request gen.UpdateGemPurchaseRequestObject) (gen.UpdateGemPurchaseResponseObject, error) {

	return gen.UpdateGemPurchase201JSONResponse{
		Balance:       100000,
		TransactionId: "tx_purchase_001",
	}, nil
}
