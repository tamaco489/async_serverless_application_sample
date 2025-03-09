package controller

import "github.com/tamaco489/async_serverless_application_sample/api/gem/internal/configuration"

type Controllers struct {
	config configuration.Config
}

func NewControllers(cnf configuration.Config) (*Controllers, error) {

	return &Controllers{
		cnf,
	}, nil
}
