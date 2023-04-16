package controller

import (
	"io/ioutil"
	"log"
	"net/http"

	"github.com/labstack/echo/v4"
)

type Controller struct {
}

var API_KEY string = "5e8f200d25b9219f586d216fccaa33ea"

func (*Controller) GetWeather(c echo.Context) error {
	resp, err := http.Get("http://api.weatherapi.com/v1/current.json?key=7eb6d8e408a0400abe6154939231304&q=Cracow&aqi=no")
	if err != nil {
		log.Fatalln(err)
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	sb := string(body)
	return c.JSON(http.StatusOK, sb)
}
