package handler

import (
	"context"
	"log/slog"

	"github.com/aws/aws-lambda-go/events"
	"github.com/tamaco489/async_serverless_application_sample/batch/slack_message/internal/usecase"
)

type DynamoDBEventJob func(ctx context.Context, dynamoDBEvent events.DynamoDBEvent) error

func SlackMessageHandler(job usecase.Job) DynamoDBEventJob {
	return func(ctx context.Context, dynamoDBEvent events.DynamoDBEvent) error {

		for _, record := range dynamoDBEvent.Records {
			slog.InfoContext(ctx, "start slack message handler process.", slog.Any("event", record))
		}

		return nil
	}
}
