package slack

import (
	"context"
	"fmt"

	"github.com/slack-go/slack"
)

type Attachment slack.Attachment

type ISlackClient interface {
	SendMessage(ctx context.Context, title, userName string, attachment Attachment) error
}

var _ ISlackClient = (*slackClient)(nil)

type slackClient struct {
	webhookURL string
}

func NewSlackClient(webhookURL string) *slackClient {
	return &slackClient{
		webhookURL: webhookURL,
	}
}

func (sc *slackClient) SendMessage(ctx context.Context, title, userName string, attachment Attachment) error {
	if err := slack.PostWebhookContext(ctx, sc.webhookURL, &slack.WebhookMessage{
		Username:    userName,
		Text:        title,
		Attachments: []slack.Attachment{slack.Attachment(attachment)},
	}); err != nil {
		return fmt.Errorf("failed to send slack message: %w", err)
	}
	return nil
}
