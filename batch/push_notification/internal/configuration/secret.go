package configuration

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/secretsmanager"
)

func batchGetSecrets(ctx context.Context, cfg aws.Config, secrets map[string]any) error {
	svc := secretsmanager.NewFromConfig(cfg)

	// SecretIdListの準備
	var keys []string
	for k := range secrets {
		keys = append(keys, k)
	}

	// SecretsManagerのAPI呼び出し
	page := secretsmanager.NewBatchGetSecretValuePaginator(
		svc,
		&secretsmanager.BatchGetSecretValueInput{
			SecretIdList: keys,
		},
	)

	for page.HasMorePages() {
		output, err := page.NextPage(ctx)
		if err != nil {
			return fmt.Errorf("batch get secrets: %w", err)
		}
		if len(output.Errors) != 0 {
			return fmt.Errorf("batch get secrets but error on %v", output.Errors)
		}
		for _, v := range output.SecretValues {
			if v.SecretString == nil {
				return fmt.Errorf("secret %q has no SecretString", *v.Name)
			}

			// Secretの取得
			secret, ok := secrets[*v.Name]
			if !ok {
				continue
			}

			if err := json.Unmarshal([]byte(*v.SecretString), secret); err != nil {
				return fmt.Errorf("unmarshal secret %q: %w", *v.Name, err)
			}
		}
	}

	return nil
}
