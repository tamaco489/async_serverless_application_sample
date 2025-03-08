package handler

import (
	"context"
	"encoding/json"
	"log/slog"

	"github.com/aws/aws-lambda-go/events"
	"github.com/tamaco489/async_serverless_application_sample/batch/push_notification/internal/models"
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
			var message models.PurchaseQueueMessage
			if err := json.Unmarshal([]byte(record.Body), &message); err != nil {
				slog.ErrorContext(ctx, "failed to unmarshal message", slog.String("error", err.Error()))
				return err
			}

			// SQSから送信されたキューの構造体をUnmarshalし、Statusに応じた処理を行う。
			switch message.Status {
			case models.PurchaseStatusCompleted:
				if err := job.SendPushNotificationPurchaseCompleted(ctx, message); err != nil {
					slog.ErrorContext(ctx, "failed to process message", slog.String("error", err.Error()))
					return err
				}

			default:
				// 期待する条件に合致しない場合、本来は以下のようにデフォルトの処理を定義する。
				// slog.InfoContext(ctx, "skip message processing", slog.Any("message", message))

				// 今回は検証目的のため、基本全てのステータスにおいて、以下のインターフェイスを呼び出すかたちにしている。
				if err := job.SendPushNotificationPurchaseCompleted(ctx, message); err != nil {
					slog.ErrorContext(ctx, "failed to process message", slog.String("error", err.Error()))
					return err
				}
			}
		}
		return nil
	}
}
