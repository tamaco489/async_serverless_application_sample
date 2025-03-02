package usecase

import (
	"crypto/rand"
	"fmt"
	"math/big"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/configuration"
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/gen"
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/library/sqs_client"
)

func (u *chargeUseCase) CreateCharge(ctx *gin.Context, request gen.CreateChargeRequestObject) (gen.CreateChargeResponseObject, error) {

	time.Sleep(1000 * time.Millisecond)

	// order_idを生成
	orderID := uuid.New().String()

	// user_idを生成（10010001 ~ 3000000までのランダムな数値を設定する）
	diff := new(big.Int).Sub(new(big.Int).SetUint64(30000000), new(big.Int).SetUint64(10010001))
	uid, err := rand.Int(rand.Reader, diff)
	if err != nil {
		return gen.CreateCharge500Response{}, fmt.Errorf("error generating rand: %v", err)
	}

	// 注文ステータスをランダムに設定
	purchaseStatus := sqs_client.GetRandomPurchaseStatus()

	queueMsgBody := sqs_client.PurchaseQueueMessage{
		UserID:  uid.Uint64(),
		OrderID: orderID,
		Status:  purchaseStatus,
	}

	sqsClient, err := sqs_client.NewSQSClient(configuration.Get().AWSConfig, configuration.Get().API.Env)
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
