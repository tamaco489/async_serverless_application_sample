package configuration

import (
	"context"
	"fmt"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/kelseyhightower/envconfig"
)

var globalConfig Config

type Config struct {
	Env         string `envconfig:"ENV" default:"dev"`
	ServiceName string `envconfig:"SERVICE_NAME" default:"slack-message"`
	Slack       struct {
		WebHookURL string `json:"webhook_url"`
	}
	AWSConfig aws.Config
}

func Get() Config { return globalConfig }

func Load(ctx context.Context) (Config, error) {
	envconfig.MustProcess("", &globalConfig)
	ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	if err := loadAWSConf(ctx); err != nil {
		return globalConfig, err
	}

	env := globalConfig.Env
	secrets := map[string]any{
		fmt.Sprintf("async-serverless-app/%s/slack-message-api", env): &globalConfig.Slack,
	}
	if err := batchGetSecrets(ctx, globalConfig.AWSConfig, secrets); err != nil {
		return globalConfig, err
	}

	return globalConfig, nil
}
