package main

import (
	"context"
	"log/slog"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/tamaco489/async_serverless_application_sample/batch/slack_message/internal/configuration"
	"github.com/tamaco489/async_serverless_application_sample/batch/slack_message/internal/handler"
	"github.com/tamaco489/async_serverless_application_sample/batch/slack_message/internal/library/logging"
	"github.com/tamaco489/async_serverless_application_sample/batch/slack_message/internal/usecase"
)

func main() {

	h := logging.NewLambdaSlogHandler(slog.NewJSONHandler(
		os.Stdout,
		&slog.HandlerOptions{AddSource: true},
	))
	slog.SetDefault(slog.New(h))

	ctx := context.Background()
	cfg, err := configuration.Load(ctx)
	if err != nil {
		panic(err)
	}

	job, err := usecase.NewJob(cfg)
	if err != nil {
		panic(err)
	}

	lambda.Start(handler.SlackMessageHandler(*job))
	lambda.Start(handler.TimeoutMiddleware(handler.SlackMessageHandler(*job)))
}
