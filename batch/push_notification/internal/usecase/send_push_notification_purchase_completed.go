package usecase

import (
	"context"
	"log/slog"
)

func (j *Job) SendPushNotificationPurchaseCompleted(ctx context.Context) error {
	slog.InfoContext(ctx, "send push notification purchase completed...")
	return nil
}
