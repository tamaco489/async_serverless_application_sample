package usecase

import (
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/gen"
)

func (u reservationUseCase) CreateReservation(ctx *gin.Context, request gen.CreateReservationRequestObject) (gen.CreateReservationResponseObject, error) {

	// NOTE: マスタ情報を参照し、且つ在庫チェックや排他制御を伴う処理を想定。負荷テストのシナリオ的にややレイテンシのあるAPIとする。
	time.Sleep(300 * time.Millisecond)

	// NOTE: 予約IDは一旦ランダムなUUIDのみを返す実装にする。
	reservationID := uuid.New().String()

	return gen.CreateReservation201JSONResponse{
		ReservationId: reservationID,
	}, nil
}
