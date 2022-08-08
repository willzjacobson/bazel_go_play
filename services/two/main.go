package main

import (
	"net/http"

	"github.com/willzjacobson/bazel_go_play/libs/hello"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()
	e.GET("/two/hello", func(c echo.Context) error {
		return c.String(http.StatusOK, hello.Greet("Friend"))
	})
	_ = e.Start(":8081")
}
