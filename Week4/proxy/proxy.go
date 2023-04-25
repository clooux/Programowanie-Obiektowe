package proxy

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"myapp/controller"
	"myapp/models"
	"net/http"
	"strconv"

	"github.com/labstack/echo/v4"
)

type Proxy struct {
	controller *controller.Controller
}

func NewProxy(c *controller.Controller) *Proxy {
	return &Proxy{controller: c}
}

func (proxy *Proxy) GetWeather(c echo.Context) error {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		panic(err)
	}
	var weather models.Weather
	db = proxy.controller.GetDB()
	db.First(&weather, "Id = ?", id)

	if (models.Weather{}) == weather {
		weather = GetWeatherFromApi()
		db.Create(&weather)

		return c.JSON(http.StatusOK, weather)
	}

	return proxy.GetWeather(c)
}

func GetWeatherFromApi() models.Weather {
	resp, err := http.Get("http://api.weatherapi.com/v1/current.json?key=7eb6d8e408a0400abe6154939231304&q=Cracow&aqi=no")
	if err != nil {
		log.Fatalln(err)
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	var weather models.Weather
	err = json.Unmarshal(body, weather)

	if err != nil {
		panic(err)
	}

	return weather
}
