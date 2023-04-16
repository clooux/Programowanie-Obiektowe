package main

import (
	"myapp/controller"

	"github.com/labstack/echo/v4"
	"gorm.io/gorm"
)

type Weather struct {
	gorm.Model
	Localization string
	Temp         int
	Date         string
}

func main() {
	e := echo.New()

	controller := controller.Controller{}
	e.GET("/", controller.GetWeather)

	e.Logger.Fatal(e.Start(":1323"))
}
