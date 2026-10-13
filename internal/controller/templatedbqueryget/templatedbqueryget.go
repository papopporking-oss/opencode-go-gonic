package templatedbqueryget

import (
	"context"
	"go-gin-standard/internal/database/pgopencode"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// Request
type Request struct {
	Username string `form:"username" binding:"required"`
}

// Response
type Response struct {
	Status  string      `json:"status"`
	Message string      `json:"message"`
	Data    interface{} `json:"data"`
	Version interface{} `json:"version"`
}

// Validate
func validate() error {
	/*
		github.com/go-playground/validator/v10

		Add custom validation here if needed.
	*/
	return nil
}

type AuthUser struct {
	ID              int64      `json:"id" gorm:"column:id"`
	CreatedAt       time.Time  `json:"created_at" gorm:"column:created_at"`
	UpdatedAt       time.Time  `json:"updated_at" gorm:"column:updated_at"`
	Email           string     `json:"email" gorm:"column:email"`
	Username        *string    `json:"username" gorm:"column:username"`
	Status          string     `json:"status" gorm:"column:status"`
	EmailVerifiedAt *time.Time `json:"email_verified_at" gorm:"column:email_verified_at"`
}

func getAuthUserByUsername(ctx context.Context, db *gorm.DB, name string) (*AuthUser, error) {
	// Step 1: Query
	var user AuthUser
	query := `
		SELECT
			id,
			created_at,
			updated_at,
			email,
			username,
			status,
			email_verified_at
		FROM auth_user
		WHERE username = ?
		LIMIT 1
	`
	err := db.WithContext(ctx).Raw(query, name).Scan(&user).Error
	if err != nil {
		return nil, err
	}
	// Step 2: Check if user is found
	if user.ID == 0 {
		return nil, gorm.ErrRecordNotFound
	}
	// Step 3: Return the data
	return &user, nil
}

type Version struct {
	Version string `json:"version" gorm:"column:version"`
}

func getVersion(ctx context.Context, db *gorm.DB) (*Version, error) {
	// Step 1: Query
	var version Version
	query := `
		SELECT VERSION()
	`
	err := db.WithContext(ctx).Raw(query).Scan(&version).Error
	if err != nil {
		return nil, err
	}
	// Step 2: Check if user is found
	if version.Version == "" {
		return nil, gorm.ErrRecordNotFound
	}
	// Step 3: Return the data
	return &version, nil
}

// Main handler function
func Handler(c *gin.Context) {
	var req Request

	// Step 1: Validate query parameter request
	if err := c.ShouldBindQuery(&req); err != nil {
		c.JSON(http.StatusBadRequest, Response{
			Status:  "error",
			Message: "Invalid request data",
			Data:    nil,
			Version: nil,
		})
		return
	}

	// Step 2: Validate request
	if err := validate(); err != nil {
		c.JSON(http.StatusBadRequest, Response{
			Status:  "error",
			Message: err.Error(),
			Data:    nil,
			Version: nil,
		})
		return
	}

	// Step 3: Connect to database
	db := pgopencode.Connect()
	if db == nil {
		c.JSON(http.StatusInternalServerError, Response{
			Status:  "error",
			Message: "Database connection failed",
			Data:    nil,
			Version: nil,
		})
		return
	}

	// Step 4: Main logic
	user, err := getAuthUserByUsername(c.Request.Context(), db, req.Username)
	if err != nil {
		c.JSON(http.StatusNotFound, Response{
			Status:  "error",
			Message: "Not found",
			Data:    nil,
			Version: nil,
		})
		return
	}

	version, err := getVersion(c.Request.Context(), db)
	if err != nil {
		c.JSON(http.StatusNotFound, Response{
			Status:  "error",
			Message: "Not found",
			Data:    nil,
			Version: nil,
		})
		return
	}

	// Step 5: Return response
	c.JSON(http.StatusOK, Response{
		Status:  "ok",
		Message: "User retrieved successfully",
		Data:    user,
		Version: version,
	})
}
