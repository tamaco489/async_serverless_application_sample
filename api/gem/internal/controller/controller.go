package controller

import (
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/configuration"
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/usecase"
)

type Controllers struct {
	config     configuration.Config
	gemUseCase usecase.IGemUseCase
}

func NewControllers(cnf configuration.Config) (*Controllers, error) {
	gemUseCase := usecase.NewGemUseCase()
	return &Controllers{
		cnf,
		gemUseCase,
	}, nil
}
