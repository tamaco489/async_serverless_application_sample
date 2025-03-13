package controller

import (
	"fmt"

	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/configuration"
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/library/sqs_client"
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/usecase"
)

type Controllers struct {
	config             configuration.Config
	chargeUseCase      usecase.IChargeUseCase
	reservationUseCase usecase.IReservationUseCase
}

func NewControllers(cnf configuration.Config) (*Controllers, error) {

	sqsClient, err := sqs_client.NewSQSClient(cnf.AWSConfig, cnf.API.Env)
	if err != nil {
		return nil, fmt.Errorf("failed to init sqs client: %w", err)
	}

	chargeUseCase := usecase.NewChargeUseCase(sqsClient)
	reservationUseCase := usecase.NewReservationUseCase()

	return &Controllers{
		cnf,
		chargeUseCase,
		reservationUseCase,
	}, nil
}
