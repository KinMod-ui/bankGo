package api

import (
	db "simplebank/db/sqlc"

	"github.com/gin-gonic/gin"
)

// Serves http request for banking service
type Server struct {
	store  db.Store
	router *gin.Engine
}

// Create new server instance and handle routing
func NewServer(store db.Store) *Server {
	server := &Server{
		store: store,
	}
	router := gin.Default()

	// add routes to the router
	router.POST("/accounts", server.createAccount)
	router.GET("/accounts/:id", server.getAccount)
	router.GET("/accounts", server.getAllAccounts)

	server.router = router
	return server
}

// Start runs the HTTP server on the given port
func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

func errorResponse(err error) gin.H {
	return gin.H{"error": err.Error()}
}
