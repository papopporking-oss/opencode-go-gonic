package tspgopencode2

import (
	"os"
	"sync"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var (
	DB *gorm.DB
	mu sync.Mutex
)

func Connect() *gorm.DB {
	mu.Lock()
	defer mu.Unlock()
	if DB != nil {
		sqlDB, err := DB.DB()
		if err == nil {
			if err := sqlDB.Ping(); err == nil {
				return DB
			}
		}
		DB = nil
	}
	dsn := os.Getenv("TSPGOPENCODE2")
	db, err := gorm.Open(
		postgres.Open(dsn),
		&gorm.Config{},
	)
	if err != nil {
		return nil
	}
	sqlDB, err := db.DB()
	if err != nil {
		return nil
	}
	if err := sqlDB.Ping(); err != nil {
		return nil
	}
	sqlDB.SetMaxOpenConns(100)
	sqlDB.SetMaxIdleConns(50)
	DB = db
	return DB
}
