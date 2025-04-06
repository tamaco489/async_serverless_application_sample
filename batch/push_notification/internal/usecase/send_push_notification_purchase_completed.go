package usecase

import (
	"context"
	"fmt"
	"log/slog"

	"github.com/line/line-bot-sdk-go/v7/linebot"
	"github.com/tamaco489/async_serverless_application_sample/batch/push_notification/internal/configuration"
	"github.com/tamaco489/async_serverless_application_sample/batch/push_notification/internal/models"
)

func (j *Job) SendPushNotificationPurchaseCompleted(ctx context.Context, message models.PurchaseQueueMessage) error {
	slog.InfoContext(ctx, "send push notification purchase completed usecase processing")

	// push通知送信したいけどアプリないのでLINE Message APIを利用する。

	channelSecret := configuration.Get().LineMessageAPI.ChannelSecret
	channelAccessToken := configuration.Get().LineMessageAPI.ChannelAccessToken
	luid := configuration.Get().LineMessageAPI.UserID

	bot, err := linebot.New(channelSecret, channelAccessToken)
	if err != nil {
		return fmt.Errorf("failed to new linebot client: %w", err)
	}
	if _, err = bot.PushMessage(luid, linebot.NewTextMessage(j.buildPushMessage(message))).Do(); err != nil {
		return fmt.Errorf("failed to send message: %w", err)
	}

	return nil
}

func (j *Job) buildPushMessage(message models.PurchaseQueueMessage) string {
	return fmt.Sprintf(
		"注文処理が完了しました。\n注文ID: %s\nユーザID: %d\n注文ステータス: %s",
		message.OrderID,
		message.UserID,
		message.Status.String(),
	)
}
