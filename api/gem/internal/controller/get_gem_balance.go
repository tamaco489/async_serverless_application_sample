package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/gen"
)

func (c *Controllers) GetGemBalance(ctx *gin.Context, request gen.GetGemBalanceRequestObject) (gen.GetGemBalanceResponseObject, error) {

	res, err := c.gemUseCase.GetGemBalance(ctx, request)
	if err != nil {
		return gen.GetGemBalance500Response{}, err
	}

	return res, nil
}
