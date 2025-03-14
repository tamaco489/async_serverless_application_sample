package usecase

import (
	"context"
	"fmt"
	"time"

	"github.com/tamaco489/async_serverless_application_sample/batch/slack_message/internal/library/slack"
	"github.com/tamaco489/async_serverless_application_sample/batch/slack_message/internal/utils/dynamodb_util"
)

func (j *Job) SendSlackMessagePurchaseStreamEvent(ctx context.Context, event SendSlackMessagePurchaseStreamEvent) error {

	playerID, err := dynamodb_util.GetValue(event.Keys, "player_id", dynamodb_util.ConvertToInt)
	if err != nil {
		return fmt.Errorf("failed to get player_id from Keys: %w", err)
	}

	timestamp, err := dynamodb_util.GetValue(event.Keys, "timestamp", dynamodb_util.ConvertToString)
	if err != nil {
		return fmt.Errorf("failed to get timestamp from Keys: %w", err)
	}

	transactionID, err := dynamodb_util.GetValue(event.NewImage, "transaction_id", dynamodb_util.ConvertToString)
	if err != nil {
		return fmt.Errorf("failed to get transaction_id from NewImage: %w", err)
	}

	description, err := dynamodb_util.GetValue(event.NewImage, "description", dynamodb_util.ConvertToString)
	if err != nil {
		return fmt.Errorf("failed to get description from NewImage: %w", err)
	}

	parsedTime, err := time.Parse(time.RFC3339, timestamp)
	if err != nil {
		return fmt.Errorf("failed to parse timestamp: %w", err)
	}
	formattedTime := parsedTime.Format("2006-01-02 15:04:05")

	sma := newSendSlackMessageAttachment(playerID, formattedTime, transactionID, description)
	if err := j.slackClient.SendMessage(ctx, sma.title, sma.username, sma.formatSlackMessage()); err != nil {
		return err
	}

	return nil
}

type sendSlackMessageAttachment struct {
	username      string
	title         string
	playerID      int
	formattedTime string
	transactionID string
	description   string
}

func newSendSlackMessageAttachment(playerID int, formattedTime, transactionID, description string) sendSlackMessageAttachment {
	username, title := "購入が完了しました。", "tamaco489"
	return sendSlackMessageAttachment{
		username:      username,
		title:         title,
		playerID:      playerID,
		formattedTime: formattedTime,
		transactionID: transactionID,
		description:   description,
	}
}

func (sa sendSlackMessageAttachment) formatSlackMessage() slack.Attachment {
	return slack.Attachment{
		Pretext: fmt.Sprintf(`
・プレイヤーID: %d
・購入日時: %s
・トランザクションID: %s
・購入内容: %s
`, sa.playerID, sa.formattedTime, sa.transactionID, sa.description,
		),
	}
}
