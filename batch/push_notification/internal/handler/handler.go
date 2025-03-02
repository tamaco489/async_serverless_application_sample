package handler

import (
	"context"
	"encoding/json"
	"log/slog"

	"github.com/aws/aws-lambda-go/events"
	"github.com/tamaco489/async_serverless_application_sample/batch/push_notification/internal/usecase"
)

type SQSEventJob func(ctx context.Context, sqsEvent events.SQSEvent) error

func PushNotificationHandler(job usecase.Job) SQSEventJob {
	return func(ctx context.Context, sqsEvent events.SQSEvent) error {

		// return fmt.Errorf("意図的にエラーにしています。")

		/*
			- 意図的にエラーを起こすことで、SQS側でリトライ処理が走る。
			- 可視性タイムアウトの時間 × リトライ回数を過ぎた後にDLQにキューイングされる。
			- なお、DLQに引き渡された後も処理ができなかった場合は、最大7日間保持され、その後は削除される。
			- DLQにキューイングされたものは可視性タイムアウト終了後、内容を確認しAWS CLI等で手動で再送する/破棄する等の対応が必要となる。
		*/

		for _, record := range sqsEvent.Records {
			var message purchaseQueueMessage
			if err := json.Unmarshal([]byte(record.Body), &message); err != nil {
				slog.ErrorContext(ctx, "failed to unmarshal message", slog.String("error", err.Error()))
				return err
			}

			switch message.Status {
			case PurchaseStatusCompleted:
				if err := job.SendPushNotificationPurchaseCompleted(ctx); err != nil {
					slog.ErrorContext(ctx, "failed to process message", slog.String("error", err.Error()))
					return err
				}

			case PurchaseStatusFailed:
				slog.InfoContext(ctx, "message processing failed", slog.Any("message", message))

			default:
				slog.InfoContext(ctx, "skip message processing", slog.Any("message", message))
			}
		}
		return nil
	}
}
