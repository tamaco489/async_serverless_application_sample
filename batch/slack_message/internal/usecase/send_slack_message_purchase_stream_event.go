package usecase

import (
	"context"
	"fmt"
	"log"
	"log/slog"

	"github.com/tamaco489/async_serverless_application_sample/batch/slack_message/internal/utils/dynamodb_util"
)

func (j *Job) SendSlackMessagePurchaseStreamEvent(ctx context.Context, event SendSlackMessagePurchaseStreamEvent) error {

	slog.InfoContext(ctx, "start slack message usecase process.", slog.Any("event_detail", event))

	// Keysからplayer_idとtimestampを取得
	playerID, err := dynamodb_util.GetValue(event.Keys, "player_id", dynamodb_util.ConvertToInt)
	if err != nil {
		return fmt.Errorf("failed to get player_id from Keys: %w", err)
	}

	timestamp, err := dynamodb_util.GetValue(event.Keys, "timestamp", dynamodb_util.ConvertToString)
	if err != nil {
		return fmt.Errorf("failed to get timestamp from Keys: %w", err)
	}

	// NewImageから必要なフィールドを取得
	transactionID, err := dynamodb_util.GetValue(event.NewImage, "transaction_id", dynamodb_util.ConvertToString)
	if err != nil {
		return fmt.Errorf("failed to get transaction_id from NewImage: %w", err)
	}

	description, err := dynamodb_util.GetValue(event.NewImage, "description", dynamodb_util.ConvertToString)
	if err != nil {
		return fmt.Errorf("failed to get description from NewImage: %w", err)
	}

	// todo: slackメッセージ用に成形する
	log.Println("[info:1] player_id:", playerID)
	log.Println("[info:2] timestamp:", timestamp)
	log.Println("[info:3] transaction_id:", transactionID)
	log.Println("[info:4] description:", description)

	return nil
}
