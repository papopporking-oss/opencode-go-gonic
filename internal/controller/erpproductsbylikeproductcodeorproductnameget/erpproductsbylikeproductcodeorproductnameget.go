package erpproductsbylikeproductcodeorproductnameget

import (
	"go-gin-standard/internal/database/pgopencode2"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// Request
type Request struct {
	ProductCode string `form:"product_code"`
	ProductName string `form:"product_name"`
}

// Response
type Response struct {
	Status  string      `json:"status"`
	Message string      `json:"message"`
	Data    interface{} `json:"data"`
}

// ERPProduct represents the erp_products table
type ERPProduct struct {
	ID            int64      `json:"id" gorm:"column:id"`
	CreatedAt     time.Time  `json:"created_at" gorm:"column:created_at"`
	UpdatedAt     time.Time  `json:"updated_at" gorm:"column:updated_at"`
	ProductCode   string     `json:"product_code" gorm:"column:product_code"`
	ProductName   string     `json:"product_name" gorm:"column:product_name"`
	Description   *string    `json:"description" gorm:"column:description"`
	Price         float64    `json:"price" gorm:"column:price"`
	StockQuantity int64      `json:"stock_quantity" gorm:"column:stock_quantity"`
	Status        string     `json:"status" gorm:"column:status"`
}

func getERPProductsByLike(ctx interface{}, db *gorm.DB, productCode, productName string) ([]ERPProduct, error) {
	var products []ERPProduct

	query := `
		SELECT
			id,
			created_at,
			updated_at,
			product_code,
			product_name,
			description,
			price,
			stock_quantity,
			status
		FROM erp_products
		WHERE 1=1
	`

	args := []interface{}{}
	argIndex := 1

	if productCode != "" {
		query += " AND product_code ILIKE ?"
		args = append(args, "%"+productCode+"%")
		argIndex++
	}

	if productName != "" {
		query += " AND product_name ILIKE ?"
		args = append(args, "%"+productName+"%")
		argIndex++
	}

	query += " ORDER BY id ASC"

	err := db.WithContext(ctx.(gin.Context).Request.Context()).Raw(query, args...).Scan(&products).Error
	if err != nil {
		return nil, err
	}

	return products, nil
}

// Handler is the main handler function
func Handler(c *gin.Context) {
	var req Request

	// Step 1: Bind query parameters (optional)
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

	// Step 3: Get products
	products, err := getERPProductsByLike(c, db, req.ProductCode, req.ProductName)
	if err != nil {
		c.JSON(http.StatusInternalServerError, Response{
			Status:  "error",
			Message: "Failed to retrieve products",
			Data:    nil,
		})
		return
	}

	// Step 4: Return response
	c.JSON(http.StatusOK, Response{
		Status:  "ok",
		Message: "Products retrieved successfully",
		Data:    products,
	})
}
