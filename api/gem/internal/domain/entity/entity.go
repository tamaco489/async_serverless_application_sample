package entity

type tableName string

const (
	PlayerProfilesTable       tableName = "player_profiles"
	TransactionHistoriesTable tableName = "transaction_histories"
)

func (tn tableName) String() string {
	return string(tn)
}
