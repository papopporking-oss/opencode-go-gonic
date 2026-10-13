package logger

import (
	"log/slog"
	"time"

	"github.com/gin-gonic/gin"
)

func Logger() gin.HandlerFunc {
	return func(c *gin.Context) {
		start := time.Now()

		// Pre-handler phase
		c.Next()

		// Post-handler phase
		latency := time.Since(start)
		slog.Info("HTTP request", "latency", latency)
	}
}
