package main

import (
	"go-gin-standard/internal/controller/template_dbquery_get"
	"go-gin-standard/internal/controller/template_get"
	"go-gin-standard/internal/controller/template_post"
	"go-gin-standard/internal/database/pgopencode"
	"go-gin-standard/internal/database/pgopencode2"
	"go-gin-standard/internal/database/tspgopencode2"
	"go-gin-standard/internal/middleware/logger"
	"log/slog"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {

	// Load environment variables from ./.env
	if err := godotenv.Load("./.env"); err != nil {
		slog.Error("Error loading .env file", "error", err)
		return
	}

	// Connect database
	if db1 := pgopencode.Connect(); db1 == nil {
		slog.Error("Failed to connect to pgopencode database")
	} else {
		slog.Info("Connected to pgopencode database successfully")
	}
	if db2 := pgopencode2.Connect(); db2 == nil {
		slog.Error("Failed to connect to pgopencode2 database")
	} else {
		slog.Info("Connected to pgopencode2 database successfully")
	}
	if db3 := tspgopencode2.Connect(); db3 == nil {
		slog.Error("Failed to connect to tspgopencode2 database")
	} else {
		slog.Info("Connected to tspgopencode2 database successfully")
	}

	router := gin.Default()
	router.GET("/api/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})

	// Template
	router.GET("/api/template-get", template_get.Handler)
	router.GET("/api/template-post", template_post.Handler)
	router.GET("/api/template-post/middleware", logger.Logger(), template_post.Handler)

	// AI
	router.GET("/api/test/ai/template-dbquery", template_dbquery_get.Handler)

	// listens on 0.0.0.0:8080 by default
	// router.Run()

	// https
	router.RunTLS(":13002", "/home/papop/certificate/opencode53.papopporking.com/opencode53.papopporking.com.crt", "/home/papop/certificate/opencode53.papopporking.com/opencode53.papopporking.com.key")
}
