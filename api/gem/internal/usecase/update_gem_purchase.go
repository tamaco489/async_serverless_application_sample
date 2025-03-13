package usecase

import (
	"fmt"
	"log/slog"
	"strconv"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/domain/entity"
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/domain/value_object"
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/gen"
)

func (u *gemUseCase) UpdateGemPurchase(ctx *gin.Context, request gen.UpdateGemPurchaseRequestObject) (gen.UpdateGemPurchaseResponseObject, error) {

	time.Sleep(750 * time.Millisecond)

	// ***** 1. リクエスト内容の検証 *****
	// 指定したジェムIDが存在するかどうか
	gem, err := entity.GetGemPackByID(request.Body.GemId)
	if err != nil {
		slog.ErrorContext(ctx, "the specified gem_id does not exist", slog.Uint64("gem_id", uint64(request.Body.GemId)))
		return gen.UpdateGemPurchase400Response{}, nil
	}

	// 有償ジェムかどうか
	gemType, err := value_object.ValidateGemType(gem.Type.String())
	if gemType.String() != value_object.PaidGem.String() {
		slog.ErrorContext(ctx, "gems of the specified gem_type cannot be purchased", slog.String("gem_type", value_object.PaidGem.String()))
		return gen.UpdateGemPurchase400Response{}, nil
	}

	// ***** 2. player_profiles のデータ参照/更新 *****
	// 本来はcontextなどからuidを取得する
	playerID := "27110642"

	// player_idをキーにしてデータを取得、存在する場合は更新、存在しない場合は新規作成の処理を行う。
	dc := u.dynamoDBClient.Client()
	getResult, err := dc.GetItem(ctx, &dynamodb.GetItemInput{
		TableName: aws.String("player_profiles"),
		Key: map[string]types.AttributeValue{
			"player_id": &types.AttributeValueMemberN{Value: playerID},
		},
	})
	if err != nil {
		return gen.UpdateGemPurchase500Response{}, fmt.Errorf("failed to get item from player_profiles table: %w", err)
	}

	now := time.Now().Format(time.RFC3339)
	balance := gem.PackQuantity * request.Body.Quantity
	freeGemBalance, level := "0", "1"

	// 作成日時の初期値は現在時刻とし、データが存在していた場合はその値を設定して更新
	createdAt := attributeValueToString(&types.AttributeValueMemberS{Value: now})

	// NOTE: 既にデータが存在する場合は、元々保有していた個数に加算した状態で更新
	if len(getResult.Item) != 0 {
		item := getResult.Item
		existingBalance, ok := item["paid_gem_balance"].(*types.AttributeValueMemberN)
		if ok {
			balanceInt, _ := strconv.ParseUint(existingBalance.Value, 10, 64)
			balance += uint32(balanceInt)
		}

		freeGemBalance = attributeValueToString(item["free_gem_balance"])
		level = attributeValueToString(item["level"])
		createdAt = attributeValueToString(item["created_at"])
	}

	profile := map[string]types.AttributeValue{
		"player_id":        &types.AttributeValueMemberN{Value: playerID},
		"paid_gem_balance": &types.AttributeValueMemberN{Value: strconv.FormatUint(uint64(balance), 10)},
		"free_gem_balance": &types.AttributeValueMemberN{Value: freeGemBalance},
		"level":            &types.AttributeValueMemberN{Value: level},
		"created_at":       &types.AttributeValueMemberS{Value: createdAt},
		"updated_at":       &types.AttributeValueMemberS{Value: now},
	}

	_, err = dc.PutItem(ctx, &dynamodb.PutItemInput{
		TableName: aws.String("player_profiles"),
		Item:      profile,
	})
	if err != nil {
		return gen.UpdateGemPurchase500Response{}, fmt.Errorf("failed to put item from player_profiles table: %w", err)
	}

	// ***** 3. transaction_histories のデータ追加 *****
	transactionID := uuid.New().String()

	transaction := map[string]types.AttributeValue{
		"transaction_id":    &types.AttributeValueMemberS{Value: transactionID},
		"timestamp":         &types.AttributeValueMemberS{Value: now},
		"player_id":         &types.AttributeValueMemberN{Value: playerID},
		"transaction_type":  &types.AttributeValueMemberS{Value: value_object.PaidGem.String()},
		"gem_id":            &types.AttributeValueMemberN{Value: strconv.FormatUint(uint64(request.Body.GemId), 10)},
		"paid_gem_quantity": &types.AttributeValueMemberN{Value: strconv.FormatUint(uint64(gem.PackQuantity*request.Body.Quantity), 10)},
		"free_gem_quantity": &types.AttributeValueMemberN{Value: freeGemBalance},
		"description":       &types.AttributeValueMemberS{Value: fmt.Sprintf("有償ジェムを%d個購入しました。(%d個セット×%d)", gem.PackQuantity*request.Body.Quantity, gem.PackQuantity, request.Body.Quantity)},
	}

	_, err = dc.PutItem(ctx, &dynamodb.PutItemInput{
		TableName: aws.String("transaction_histories"),
		Item:      transaction,
	})
	if err != nil {
		return gen.UpdateGemPurchase500Response{}, fmt.Errorf("failed to put item from transaction_histories table: %w", err)
	}

	return gen.UpdateGemPurchase201JSONResponse{
		Balance:       balance,
		TransactionId: transactionID,
	}, nil
}

// attributeValueToString: 型`types.AttributeValue`を受け取りString型に変換する
//
// 文字列型、数値型、バイト配列型のみを受け付ける。左記以外の型の場合は空文字を返す
func attributeValueToString(av types.AttributeValue) string {
	switch v := av.(type) {
	case *types.AttributeValueMemberS:
		return v.Value
	case *types.AttributeValueMemberN:
		return v.Value
	case *types.AttributeValueMemberB:
		return string(v.Value)
	default:
		return ""
	}
}
