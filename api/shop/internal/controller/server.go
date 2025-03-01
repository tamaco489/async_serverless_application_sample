package controller

import (
	"fmt"
	"net/http"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/configuration"
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/gen"
	"github.com/tamaco489/async_serverless_application_sample/api/shop/internal/library/logger"
)

func NewHShopAPIServer() (*http.Server, error) {

	corsCnf := NewCorsConfig()

	r := gin.New()
	r.Use(gin.LoggerWithFormatter(logger.LogFormatter))
	r.Use(cors.New(corsCnf))
	r.Use(gin.Recovery())

	apiController := NewControllers(configuration.Get().API.Env)
	strictServer := gen.NewStrictHandler(apiController, nil)

	gen.RegisterHandlersWithOptions(
		r,
		strictServer,
		gen.GinServerOptions{
			BaseURL:     "/shop/",
			Middlewares: []gen.MiddlewareFunc{},
			ErrorHandler: func(ctx *gin.Context, err error, i int) {
				_ = ctx.Error(err)
				ctx.JSON(i, gin.H{"msg": err.Error()})
			},
		},
	)

	// NOTE: portは一旦固定値で渡す
	port := "8080"
	server := &http.Server{
		Handler: r,
		Addr:    fmt.Sprintf(":%s", port),
	}

	return server, nil
}

func NewCorsConfig() cors.Config {
	return cors.Config{
		// 許可するオリジンを指定（一旦全許可）
		AllowOrigins: []string{"*"},

		// 必要なメソッドのみ許可
		AllowMethods: []string{
			"GET",
			"POST",
			"PUT",
			"DELETE",
			"HEAD",
			"OPTIONS",
		},

		// 許可するヘッダーを限定
		AllowHeaders: []string{
			"Origin",
			"Content-Length",
			"Content-Type",
			"Authorization",
			"Access-Control-Allow-Origin",
		},

		// クライアントがアクセスできるレスポンスヘッダー
		ExposeHeaders: []string{"Content-Length"},

		// 認証情報を送信可能にする
		AllowCredentials: false,

		// プリフライトリクエストのキャッシュ時間（秒）
		MaxAge: 86400,
	}
}
