package usecase

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/events"
	"github.com/tamaco489/async_serverless_application_sample/batch/slack_message/internal/configuration"
)

type Jobber interface {
	SendSlackMessagePurchaseStreamEvent(ctx context.Context, event SendSlackMessagePurchaseStreamEvent) error
}

var _ Jobber = (*Job)(nil)

type Job struct{}

func NewJob(cfg configuration.Config) (*Job, error) {
	return &Job{}, nil
}

type SendSlackMessagePurchaseStreamEvent struct {
	Keys     map[string]events.DynamoDBAttributeValue `json:"Keys"`
	NewImage map[string]events.DynamoDBAttributeValue `json:"NewImage"`
}

func NewSendSlackMessagePurchaseStreamEvent(keys map[string]events.DynamoDBAttributeValue, newImage map[string]events.DynamoDBAttributeValue) (SendSlackMessagePurchaseStreamEvent, error) {
	if keys == nil {
		return SendSlackMessagePurchaseStreamEvent{}, fmt.Errorf("keys cannot be nil")
	}
	if newImage == nil {
		return SendSlackMessagePurchaseStreamEvent{}, fmt.Errorf("newImage cannot be nil")
	}
	return SendSlackMessagePurchaseStreamEvent{
		Keys:     keys,
		NewImage: newImage,
	}, nil
}
