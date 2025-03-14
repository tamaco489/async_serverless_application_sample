package handler

import (
	"context"
	"time"

	"github.com/aws/aws-lambda-go/events"
)

var timeout = 840 * time.Second

// TimeoutMiddlewareは[context.Context]にtimeoutを設定します。
// Lambda Runtimeのタイムアウトを15minに設定しているのでその値よりも短くすることで安全に処理を切り上げることが可能なようにしてあります。
func TimeoutMiddleware(fn DynamoDBEventJob) DynamoDBEventJob {
	return func(ctx context.Context, dynamoDBEvent events.DynamoDBEvent) error {
		newCtx, finish := context.WithTimeout(ctx, timeout)
		defer finish()
		return fn(newCtx, dynamoDBEvent)
	}
}
