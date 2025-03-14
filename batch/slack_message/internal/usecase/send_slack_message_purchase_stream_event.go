package usecase

import (
	"context"
	"fmt"
	"log"
	"log/slog"

	"github.com/aws/aws-lambda-go/events"
)

func (j *Job) SendSlackMessagePurchaseStreamEvent(ctx context.Context, event SendSlackMessagePurchaseStreamEvent) error {

	slog.InfoContext(ctx, "start slack message usecase process.", slog.Any("event_detail", event))

	// Keysからplayer_idとtimestampを取得
	playerID, err := getValue(event.Keys, "player_id", convertToInt)
	if err != nil {
		return fmt.Errorf("failed to get player_id from Keys: %w", err)
	}

	timestamp, err := getValue(event.Keys, "timestamp", convertToString)
	if err != nil {
		return fmt.Errorf("failed to get timestamp from Keys: %w", err)
	}

	// NewImageから必要なフィールドを取得
	transactionID, err := getValue(event.NewImage, "transaction_id", convertToString)
	if err != nil {
		return fmt.Errorf("failed to get transaction_id from NewImage: %w", err)
	}

	description, err := getValue(event.NewImage, "description", convertToString)
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

func getValue[T any](source map[string]events.DynamoDBAttributeValue, key string, convertFunc func(events.DynamoDBAttributeValue) (T, error)) (T, error) {
	if value, ok := source[key]; ok {
		return convertFunc(value)
	}
	var zero T
	return zero, fmt.Errorf("%s not found in source", key)
}

// convertToIntはDynamoDBの数値型(N)を整数に変換するユーティリティ関数
func convertToInt(attribute events.DynamoDBAttributeValue) (int, error) {
	if attribute.Number() != "" {
		var value int
		_, err := fmt.Sscanf(attribute.Number(), "%d", &value)
		if err != nil {
			return 0, fmt.Errorf("failed to convert string to int: %v", err)
		}
		return value, nil
	}
	return 0, fmt.Errorf("invalid number value")
}

// convertToStringはDynamoDBの文字列型(S)を文字列に変換するユーティリティ関数
func convertToString(attribute events.DynamoDBAttributeValue) (string, error) {
	if attribute.String() != "" {
		return attribute.String(), nil
	}
	return "", fmt.Errorf("invalid string value")
}
