package usecase

import (
	"context"
	"log/slog"
)

func (j *Job) SendSlackMessagePurchaseStreamEvent(ctx context.Context) error {

	slog.InfoContext(ctx, "start slack message usecase process.")

	return nil
}
