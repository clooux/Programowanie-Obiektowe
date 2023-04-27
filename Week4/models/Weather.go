package models

import "gorm.io/gorm"

type Weather struct {
	gorm.Model
	Localization string
	Temperature  float32
	Date         string
}
