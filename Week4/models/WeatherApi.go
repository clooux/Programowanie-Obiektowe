package models

type WeatherApi struct {
	Location Location
	Current  Current
}

type Location struct {
	Name      string
	Localtime string
}

type Current struct {
	Temp_c float32
}
