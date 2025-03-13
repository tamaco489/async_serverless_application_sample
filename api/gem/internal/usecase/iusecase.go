package usecase

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/gen"
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/library/dynamodb_client"
)

type IGemUseCase interface {
	GetGemBalance(ctx *gin.Context, request gen.GetGemBalanceRequestObject) (gen.GetGemBalanceResponseObject, error)
	UpdateGemPurchase(ctx *gin.Context, request gen.UpdateGemPurchaseRequestObject) (gen.UpdateGemPurchaseResponseObject, error)
}

type gemUseCase struct {
	dynamoDBClient *dynamodb_client.DynamoDBClient
}

func NewGemUseCase(dynamoDBClient *dynamodb_client.DynamoDBClient) IGemUseCase {
	return &gemUseCase{dynamoDBClient: dynamoDBClient}
}
