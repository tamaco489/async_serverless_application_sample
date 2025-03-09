package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/gen"
)

func (c *Controllers) Healthcheck(ctx *gin.Context, request gen.HealthcheckRequestObject) (gen.HealthcheckResponseObject, error) {

	return gen.Healthcheck200JSONResponse{
		Message: "OK",
	}, nil
}
