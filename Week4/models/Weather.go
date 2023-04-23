package models

import "gorm.io/gorm"

type Weather struct {
	gorm.Model
	Localization string
	Temp         int
	Date         string
}
