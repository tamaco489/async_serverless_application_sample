package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/gen"
)

func (c *Controllers) GetCurrencyBalance(ctx *gin.Context, request gen.GetCurrencyBalanceRequestObject) (gen.GetCurrencyBalanceResponseObject, error) {

	return gen.GetCurrencyBalance200JSONResponse{
		All:  1500,
		Paid: 1000,
		Free: 500,
	}, nil
}
