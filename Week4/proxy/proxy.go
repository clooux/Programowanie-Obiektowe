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
	location := c.QueryParam("location")

	if err != nil {
		panic(err)
	}
	var weather models.Weather
	db := proxy.controller.GetDB()
	error := db.First(&weather, id).Error

	if error != nil {
		weatherApi := GetWeatherFromApi(location)
		weather = models.Weather{Localization: weatherApi.Location.Name, Temperature: weatherApi.Current.Temp_c, Date: weatherApi.Location.Localtime}

		if weather.Localization == "" {
			return c.JSON(http.StatusBadRequest, "Bad location, send location as queryParam and use english version of location")
		}

		db.Create(&weather)

		return c.JSON(http.StatusOK, weather)
	}

	return proxy.controller.GetWeather(c, id)
}

func GetWeatherFromApi(location string) *models.WeatherApi {
	resp, err := http.Get("http://api.weatherapi.com/v1/current.json?key=7eb6d8e408a0400abe6154939231304&q=" + location + "&aqi=no")
	if err != nil {
		log.Fatalln(err)
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	var weatherApi models.WeatherApi
	err = json.Unmarshal(body, &weatherApi)
	if err != nil {
		panic(err)
	}

	return &weatherApi
}
