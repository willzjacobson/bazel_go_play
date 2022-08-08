package main

import (
	"net/http"

	"privacy_go/libs/hello"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()
	e.GET("/two/hello", func(c echo.Context) error {
		return c.String(http.StatusOK, hello.Greet("Friend"))
	})
	_ = e.Start(":8081")
}
