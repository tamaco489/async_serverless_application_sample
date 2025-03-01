package controller

import (
	"time"

	"github.com/gin-gonic/gin"
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/gen"
)

func (c *Controllers) DeleteCreditCard(ctx *gin.Context, request gen.DeleteCreditCardRequestObject) (gen.DeleteCreditCardResponseObject, error) {

	time.Sleep(300 * time.Millisecond)

	return gen.DeleteCreditCard204Response{}, nil
}
