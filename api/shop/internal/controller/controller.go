package controller

import (
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/configuration"
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/usecase"
)

type Controllers struct {
	config             configuration.Config
	chargeUseCase      usecase.IChargeUseCase
	reservationUseCase usecase.IReservationUseCase
}

func NewControllers(cnf configuration.Config) *Controllers {
	chargeUseCase := usecase.NewChargeUseCase()
	reservationUseCase := usecase.NewReservationUseCase()
	return &Controllers{
		cnf,
		chargeUseCase,
		reservationUseCase,
	}
}
