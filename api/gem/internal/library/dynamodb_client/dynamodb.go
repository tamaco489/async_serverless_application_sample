package dynamodb_client

import (
	"fmt"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
)

type DynamoDBClient struct {
	client *dynamodb.Client
}

func NewDynamoDBClient(cfg aws.Config, env string) (*DynamoDBClient, error) {

	var client *dynamodb.Client

	switch env {
	case "dev":
		cfg.Credentials = aws.NewCredentialsCache(credentials.NewStaticCredentialsProvider("dummy", "dummy", ""))
		client = dynamodb.NewFromConfig(cfg, func(o *dynamodb.Options) {
			o.BaseEndpoint = aws.String("http://dynamodb-local:8000")
		})

	case "stg", "prd":
		client = dynamodb.NewFromConfig(cfg)

	default:
		return nil, fmt.Errorf("unsupported environment: %v", env)
	}

	return &DynamoDBClient{client: client}, nil
}

func (d *DynamoDBClient) Client() *dynamodb.Client {
	return d.client
}
