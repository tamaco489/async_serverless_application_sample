package sqs_client

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/service/sqs"
)

type SQSClient struct {
	Client *sqs.Client
}

func NewSQSClient(cfg aws.Config, env string) (*SQSClient, error) {

	var client *sqs.Client

	switch env {
	case "dev":
		cfg.Credentials = aws.NewCredentialsCache(credentials.NewStaticCredentialsProvider("dummy", "dummy", ""))
		client = sqs.NewFromConfig(cfg, func(o *sqs.Options) {
			o.BaseEndpoint = aws.String("http://localhost:4566")
		})

	case "stg", "prd":
		client = sqs.NewFromConfig(cfg)

	default:
		return nil, fmt.Errorf("unsupported environment: %v", env)
	}

	if client == nil {
		return nil, fmt.Errorf("failed to initialize SQS client for environment: %s", env)
	}

	return &SQSClient{Client: client}, nil
}

func (c *SQSClient) SendPurchaseMessage(ctx context.Context, queueURL string, msg PurchaseQueueMessage) error {
	msgBody, err := json.Marshal(msg)
	if err != nil {
		return fmt.Errorf("failed to marshal message to JSON: %w", err)
	}

	_, err = c.Client.SendMessage(ctx, &sqs.SendMessageInput{
		QueueUrl:    aws.String(queueURL),
		MessageBody: aws.String(string(msgBody)),
	})
	if err != nil {
		return fmt.Errorf("failed to send message to SQS: %w", err)
	}

	return nil
}
