package usecase

import (
	"strconv"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/async_serverless_application_sample/api/gem/internal/gen"
)

func (u *gemUseCase) UpdateGemPurchase(ctx *gin.Context, request gen.UpdateGemPurchaseRequestObject) (gen.UpdateGemPurchaseResponseObject, error) {

	time.Sleep(750 * time.Millisecond)

	// 本来はcontextなどからuidを取得する
	playerID := "27110642"

	// uidを使用して、`player_profiles` から対象のデータを取得

	// データが存在する場合は更新、存在しない場合は新たに作成

	// 本来はマスタを参照し、gem_idに対応するアイテムの個数を取得
	var quantityByID uint32 = 300
	paidGemBalance := request.Body.Quantity * quantityByID

	// 既にデータが存在する場合は、元々保有していた個数に加算した状態でテーブルを更新

	now := time.Now().Format(time.RFC3339)

	item := map[string]types.AttributeValue{
		"player_id":        &types.AttributeValueMemberS{Value: playerID},
		"paid_gem_balance": &types.AttributeValueMemberN{Value: strconv.FormatUint(uint64(paidGemBalance), 10)},
		"free_gem_balance": &types.AttributeValueMemberN{Value: "0"}, // 有償通貨なので0固定
		"level":            &types.AttributeValueMemberN{Value: "1"},
		"play_time":        &types.AttributeValueMemberN{Value: "12345"}, // 一旦ハードコード
		"last_login":       &types.AttributeValueMemberS{Value: now},
		"created_at":       &types.AttributeValueMemberS{Value: now},
		"updated_at":       &types.AttributeValueMemberS{Value: now},
	}

	dc := u.dynamoDBClient
	_, err := dc.Client().PutItem(ctx, &dynamodb.PutItemInput{
		TableName: aws.String("player_profiles"),
		Item:      item,
	})
	if err != nil {
		return gen.UpdateGemPurchase500Response{}, err
	}

	// NOTE: `transaction_histories` テーブルにログを作成

	return gen.UpdateGemPurchase201JSONResponse{
		Balance:       100000,
		TransactionId: "tx_purchase_001",
	}, nil
}
