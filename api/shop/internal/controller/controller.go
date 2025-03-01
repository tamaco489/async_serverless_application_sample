package controller

import "github.com/tamaco489/async_serverless_application_sample/api/shop/internal/usecase"

type Controllers struct {
	env           string
	chargeUseCase usecase.IChargeUseCase
}

func NewControllers(env string) *Controllers {
	chargeUseCase := usecase.NewChargeUseCase()
	return &Controllers{
		env,
		chargeUseCase,
	}
}
