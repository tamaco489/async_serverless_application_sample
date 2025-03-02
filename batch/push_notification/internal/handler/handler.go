package handler

import (
	"context"
	"encoding/json"
	"log/slog"

	"github.com/aws/aws-lambda-go/events"
	"github.com/tamaco489/async_serverless_application_sample/batch/push_notification/internal/usecase"
)

func PushNotificationHandler(job usecase.Job) func(ctx context.Context, sqsEvent events.SQSEvent) error {

	return func(ctx context.Context, sqsEvent events.SQSEvent) error {

		for _, record := range sqsEvent.Records {
			var message purchaseQueueMessage
			if err := json.Unmarshal([]byte(record.Body), &message); err != nil {
				slog.ErrorContext(ctx, "failed to unmarshal message", slog.String("error", err.Error()))
				return err
			}

			switch message.Status {
			case PurchaseStatusCompleted:
				if err := job.ProcessMessage(ctx, message); err != nil {
					slog.ErrorContext(ctx, "failed to process message", slog.String("error", err.Error()))
					return err
				}

			case PurchaseStatusFailed:
				slog.InfoContext(ctx, "message processing failed", slog.Any("message", message))
				//

			default:
				slog.InfoContext(ctx, "skip message processing", slog.Any("message", message))
			}
		}
		return nil
	}
}
