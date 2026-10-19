package template_get

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"go-gin-standard/internal/service/service1"
)

func Handler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status": "OK",
		"message": "OK",
		"data":   service1.Hello(),
	})
}
