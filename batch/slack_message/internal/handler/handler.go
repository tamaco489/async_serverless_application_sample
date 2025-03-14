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
			event, err := usecase.NewSendSlackMessagePurchaseStreamEvent(record.Change.Keys, record.Change.NewImage)
			if err != nil {
				slog.ErrorContext(
					ctx, "failed to new send slack message purchase stream event",
					slog.String("event_name", record.EventName),
					slog.Any("change keys", record.Change.Keys),
					slog.Any("change new image", record.Change.NewImage),
					slog.String("error", err.Error()),
				)
				continue
			}

			switch record.EventName {
			case "INSERT":
				if err := job.SendSlackMessagePurchaseStreamEvent(ctx, event); err != nil {
					slog.ErrorContext(
						ctx, "failed to send slack message purchase stream event job",
						slog.String("error", err.Error()),
					)
				}
			default:
				slog.WarnContext(ctx, "invalid event_name", slog.String("event_name", record.EventName))
			}
		}

		return nil
	}
}
