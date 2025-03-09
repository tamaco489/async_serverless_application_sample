package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/gen"
)

func (c *Controllers) GetGemBalance(ctx *gin.Context, request gen.GetGemBalanceRequestObject) (gen.GetGemBalanceResponseObject, error) {

	return gen.GetGemBalance200JSONResponse{
		All:  1500,
		Paid: 1000,
		Free: 500,
	}, nil
}
