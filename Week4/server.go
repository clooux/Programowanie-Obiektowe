package main

import (
	"myapp/controller"
	"myapp/models"
	"myapp/proxy"

	"github.com/glebarez/sqlite"
	"github.com/labstack/echo/v4"
	"gorm.io/gorm"
)

func main() {
	e := echo.New()
	db, err := gorm.Open(sqlite.Open("gorm.db"), &gorm.Config{})
	if err != nil {
		panic("failed to connect database")
	}
	// Migrate the schema
	db.AutoMigrate(&models.Weather{})
	db.Create(&models.Weather{Localization: "Cracow", Temp: 21, Date: "21.04.2023"})

	controller := controller.NewController(db)
	proxy := proxy.Proxy{}

	e.GET("/weather", controller.GetWeathers)
	e.GET("/weather/:id", proxy.GetWeather)

	e.Logger.Fatal(e.Start(":1323"))
}
