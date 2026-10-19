package template_post

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"go-gin-standard/internal/service/service2"
)

func Handler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status": "OK",
		"message": "OK",
		"data":   service2.Hello(),
	})
}
