package usecase

import (
	"context"

	"github.com/tamaco489/async_serverless_application_sample/batch/push_notification/internal/configuration"
	"github.com/tamaco489/async_serverless_application_sample/batch/push_notification/internal/models"
)

type Jobber interface {
	SendPushNotificationPurchaseCompleted(ctx context.Context, message models.PurchaseQueueMessage) error
}

var _ Jobber = (*Job)(nil)

type Job struct{}

func NewJob(cfg configuration.Config) (*Job, error) {
	return &Job{}, nil
}
