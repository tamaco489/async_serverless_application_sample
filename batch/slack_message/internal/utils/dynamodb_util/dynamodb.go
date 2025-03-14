package dynamodb_util

import (
	"fmt"

	"github.com/aws/aws-lambda-go/events"
)

func GetValue[T any](source map[string]events.DynamoDBAttributeValue, key string, convertFunc func(events.DynamoDBAttributeValue) (T, error)) (T, error) {
	if value, ok := source[key]; ok {
		return convertFunc(value)
	}
	var zero T
	return zero, fmt.Errorf("%s not found in source", key)
}

// convertToIntはDynamoDBの数値型(N)を整数に変換するユーティリティ関数
func ConvertToInt(attribute events.DynamoDBAttributeValue) (int, error) {
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
func ConvertToString(attribute events.DynamoDBAttributeValue) (string, error) {
	if attribute.String() != "" {
		return attribute.String(), nil
	}
	return "", fmt.Errorf("invalid string value")
}
