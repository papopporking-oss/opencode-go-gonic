package testget

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"go-gin-standard/internal/service/service1"
)

func Handler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"method": "GET",
		"data":   service1.Hello(),
	})
}
