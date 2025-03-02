package usecase

import (
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/gen"
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/library/sqs_client"
)

type IChargeUseCase interface {
	CreateCharge(ctx *gin.Context, request gen.CreateChargeRequestObject) (gen.CreateChargeResponseObject, error)
}

type IReservationUseCase interface {
	CreateReservation(ctx *gin.Context, request gen.CreateReservationRequestObject) (gen.CreateReservationResponseObject, error)
}
type chargeUseCase struct{ sqsClient *sqs_client.SQSClient }

type reservationUseCase struct{}

func NewChargeUseCase(sqsClient *sqs_client.SQSClient) IChargeUseCase {
	return &chargeUseCase{sqsClient: sqsClient}
}

func NewReservationUseCase() IReservationUseCase {
	return &reservationUseCase{}
}
