package config

const(
	DATABASE="d37acbe81ea08006c5bb2d6ed907017e4cfdaa1545064faeab2f01a072fa96eb4d2536f5a11138cc31ecc2cf2ea7e8d6a78b74100291cf6f6b90fe528aaf3a77"
	PUT="put"
	DELETE="delete"
	QUERY="query"
)

func GetDatabase() string {
	return DATABASE
}
func GetPut() string{
	return PUT
}

func GetDelete()string{
	return DELETE
}

func GetQuery()string{
	return QUERY
}