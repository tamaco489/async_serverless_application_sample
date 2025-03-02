package usecase

import (
	"context"
	"log/slog"

	"github.com/tamaco489/async_serverless_application_sample/batch/push_notification/internal/configuration"
)

type Jobber interface {
	ProcessMessage(ctx context.Context, message interface{}) error
}

var _ Jobber = (*Job)(nil)

type Job struct{}

func NewJob(cfg configuration.Config) (*Job, error) {
	return &Job{}, nil
}

func (j *Job) ProcessMessage(ctx context.Context, message interface{}) error {
	slog.InfoContext(ctx, "processing message", slog.Any("message", message))
	return nil
}
