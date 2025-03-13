package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/gen"

	validation "github.com/go-ozzo/ozzo-validation/v4"
)

func (c *Controllers) UpdateGemPurchase(ctx *gin.Context, request gen.UpdateGemPurchaseRequestObject) (gen.UpdateGemPurchaseResponseObject, error) {

	err := validation.ValidateStruct(request.Body,
		validation.Field(
			&request.Body.GemId,
			validation.Required,
		),
		validation.Field(
			&request.Body.Quantity,
			validation.Required,
			validation.Min(uint32(1)),
			validation.Max(uint32(500)),
		),
	)
	if err != nil {
		_ = ctx.Error(err)
		return gen.UpdateGemPurchase400Response{}, nil
	}

	res, err := c.gemUseCase.UpdateGemPurchase(ctx, request)
	if err != nil {
		return gen.UpdateGemPurchase500Response{}, err
	}

	return res, nil
}
