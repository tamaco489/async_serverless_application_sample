package usecase

import (
	"fmt"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/configuration"
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/gen"
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/library/sqs_client"
)

func (u *chargeUseCase) CreateCharge(ctx *gin.Context, request gen.CreateChargeRequestObject) (gen.CreateChargeResponseObject, error) {

	time.Sleep(1000 * time.Millisecond)

	// 注文IDを生成
	orderID := uuid.New().String()

	queueMsgBody := sqs_client.PurchaseQueueMessage{
		UserID:  10010024,
		OrderID: orderID,
		Status:  sqs_client.PurchaseStatusCompleted,
	}

	sqsClient, err := sqs_client.NewSQSClient(ctx.Request.Context(), configuration.Get().AWSConfig, configuration.Get().API.Env)
	if err != nil {
		return nil, fmt.Errorf("failed to create sqs client: %v", err)
	}

	if configuration.Get().API.Env != "dev" {
		if err := sqsClient.SendPurchaseMessage(
			ctx.Request.Context(),
			configuration.Get().SQS.PushNotificationURL,
			queueMsgBody,
		); err != nil {
			return gen.CreateCharge500Response{}, fmt.Errorf("failed to send message to sqs: %v", err)
		}
	}

	return gen.CreateCharge204Response{}, nil
}
