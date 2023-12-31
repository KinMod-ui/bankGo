postgres:
	 docker run --name postgres15 -p 5432:5432 -d -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret postgres:15-alpine

createdb: 
	docker exec -it postgres15 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres15 dropdb simple_bank

migrateup:
	migrate -path db/migration -database 'postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable' -verbose up
	
migratedown:
	migrate -path db/migration -database 'postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable' -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server: 
	go run main.go

mock:
	mockgen -package mockdmockgen -package mockdb -destination db/mock/store.go simplebank/db/sqlc Store b-destination db/mock/store.go simplebank/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server
