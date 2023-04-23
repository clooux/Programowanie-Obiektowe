package controller

import (
	"io/ioutil"
	"log"
	"myapp/models"
	"net/http"

	"github.com/labstack/echo/v4"
	"gorm.io/gorm"
)

type Controller struct {
	db *gorm.DB
}

func NewController(db *gorm.DB) *Controller {
	return &Controller{db: db}
}

var API_KEY string = "5e8f200d25b9219f586d216fccaa33ea"

func (controller *Controller) GetWeather(c echo.Context, id int) error {
	var weather models.Weather
	controller.db.First(&weather, "Id = ?", id)
	return c.JSON(http.StatusOK, weather)
}

func (controller *Controller) GetWeathers(c echo.Context) error {
	var weathers []models.Weather
	controller.db.Find(&weathers)
	return c.JSON(http.StatusOK, weathers)
}

func (controller *Controller) GetWeatherFromApi(c echo.Context) error {
	resp, err := http.Get("http://api.weatherapi.com/v1/current.json?key=7eb6d8e408a0400abe6154939231304&q=Cracow&aqi=no")
	if err != nil {
		log.Fatalln(err)
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	sb := string(body)
	return c.JSON(http.StatusOK, sb)
}
