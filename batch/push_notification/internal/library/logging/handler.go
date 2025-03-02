package logging

import (
	"context"
	"log/slog"

	"github.com/aws/aws-lambda-go/lambdacontext"
)

type LambdaSlogHandler struct {
	slog.Handler
}

func NewLambdaSlogHandler(h slog.Handler) *LambdaSlogHandler {
	return &LambdaSlogHandler{Handler: h}
}

func (h *LambdaSlogHandler) Handle(ctx context.Context, record slog.Record) error {
	lc, ok := lambdacontext.FromContext(ctx)
	if ok {
		record.Add(slog.Group("function",
			slog.String("requestId", lc.AwsRequestID),
		))
	}
	return h.Handler.Handle(ctx, record)
}
