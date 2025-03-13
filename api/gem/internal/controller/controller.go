package controller

import (
	"fmt"

	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/configuration"
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/library/dynamodb_client"
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/usecase"
)

type Controllers struct {
	config     configuration.Config
	gemUseCase usecase.IGemUseCase
}

func NewControllers(cnf configuration.Config) (*Controllers, error) {

	dynamoDBClient, err := dynamodb_client.NewDynamoDBClient(cnf.AWSConfig, cnf.API.Env)
	if err != nil {
		return nil, fmt.Errorf("failed to init dynamodb client: %w", err)
	}

	gemUseCase := usecase.NewGemUseCase(dynamoDBClient)

	return &Controllers{
		cnf,
		gemUseCase,
	}, nil
}
