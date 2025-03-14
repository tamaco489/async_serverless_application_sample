package usecase

import (
	"context"

	"github.com/tamaco489/async_serverless_application_sample/batch/slack_message/internal/configuration"
)

type Jobber interface {
	SendSlackMessagePurchaseStreamEvent(ctx context.Context) error
}

var _ Jobber = (*Job)(nil)

type Job struct{}

func NewJob(cfg configuration.Config) (*Job, error) {
	return &Job{}, nil
}
