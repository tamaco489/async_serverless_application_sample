package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/gen"
)

func (c *Controllers) UpdateGemPurchase(ctx *gin.Context, request gen.UpdateGemPurchaseRequestObject) (gen.UpdateGemPurchaseResponseObject, error) {

	res, err := c.gemUseCase.UpdateGemPurchase(ctx, request)
	if err != nil {
		return gen.UpdateGemPurchase500Response{}, err
	}

	return res, nil
}
