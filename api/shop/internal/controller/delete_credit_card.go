package controller

import (
	"time"

	"github.com/gin-gonic/gin"
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/gen"
)

func (c *Controllers) DeleteCreditCard(ctx *gin.Context, request gen.DeleteCreditCardRequestObject) (gen.DeleteCreditCardResponseObject, error) {

	// NOTE: 外部APIを実行する想定であるため、300ms遅延させる。※非同期的に即時で204返却しても良いが負荷テストのシナリオ的に用意
	time.Sleep(300 * time.Millisecond)

	return gen.DeleteCreditCard204Response{}, nil
}
