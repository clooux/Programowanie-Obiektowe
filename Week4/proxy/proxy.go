package proxy

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"myapp/models"
	"net/http"
)

type Proxy struct {
}

// func () GetWeather(c echo.Context) error {
// 	id, err := strconv.Atoi(c.Param("id"))
// 	if err != nil {
// 		panic(err)
// 	}
// 	var weather models.Weather
// 	proxy.Controller{}
// 	proxy.Controller.db.First(&weather, "Id = ?", id)

// 	if (models.Weather{}) == weather {
// 		weather = GetWeatherFromApi()
// 		proxy.db.Create(&weather)

// 		return c.JSON(http.StatusOK, weather)
// 	}

// 	return proxy.GetWeather(c)
// }

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
