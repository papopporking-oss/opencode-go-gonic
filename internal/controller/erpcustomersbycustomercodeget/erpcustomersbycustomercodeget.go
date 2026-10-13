package erpcustomersbycustomercodeget

import (
	"go-gin-standard/internal/database/pgopencode2"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// Request
type Request struct {
	CustomerCode string `form:"customer_code" binding:"required"`
}

// Response
type Response struct {
	Status  string      `json:"status"`
	Message string      `json:"message"`
	Data    interface{} `json:"data"`
}

// ERPCustomer represents the erp_customers table
type ERPCustomer struct {
	ID           int64      `json:"id" gorm:"column:id"`
	CreatedAt    time.Time  `json:"created_at" gorm:"column:created_at"`
	UpdatedAt    time.Time  `json:"updated_at" gorm:"column:updated_at"`
	CustomerCode string     `json:"customer_code" gorm:"column:customer_code"`
	CustomerName string     `json:"customer_name" gorm:"column:customer_name"`
	Email        *string    `json:"email" gorm:"column:email"`
	Phone        *string    `json:"phone" gorm:"column:phone"`
	Address      *string    `json:"address" gorm:"column:address"`
	Status       string     `json:"status" gorm:"column:status"`
}

func getERPCustomersByCustomerCode(ctx interface{}, db *gorm.DB, customerCode string) ([]ERPCustomer, error) {
	var customers []ERPCustomer

	query := `
		SELECT
			id,
			created_at,
			updated_at,
			customer_code,
			customer_name,
			email,
			phone,
			address,
			status
		FROM erp_customers
		WHERE customer_code = ?
		ORDER BY id ASC
	`

	err := db.WithContext(ctx.(gin.Context).Request.Context()).Raw(query, customerCode).Scan(&customers).Error
	if err != nil {
		return nil, err
	}

	return customers, nil
}

// Handler is the main handler function
func Handler(c *gin.Context) {
	var req Request

	// Step 1: Validate query parameter request
	if err := c.ShouldBindQuery(&req); err != nil {
		c.JSON(http.StatusBadRequest, Response{
			Status:  "error",
			Message: "Invalid request data",
			Data:    nil,
		})
		return
	}

	// Step 2: Connect to database
	db := pgopencode2.Connect()
	if db == nil {
		c.JSON(http.StatusInternalServerError, Response{
			Status:  "error",
			Message: "Database connection failed",
			Data:    nil,
		})
		return
	}

	// Step 3: Get customers
	customers, err := getERPCustomersByCustomerCode(c, db, req.CustomerCode)
	if err != nil {
		c.JSON(http.StatusInternalServerError, Response{
			Status:  "error",
			Message: "Failed to retrieve customers",
			Data:    nil,
		})
		return
	}

	// Step 4: Check if data found
	if len(customers) == 0 {
		c.JSON(http.StatusNotFound, Response{
			Status:  "error",
			Message: "Customer not found",
			Data:    nil,
		})
		return
	}

	// Step 5: Return response
	c.JSON(http.StatusOK, Response{
		Status:  "ok",
		Message: "Customers retrieved successfully",
		Data:    customers,
	})
}
