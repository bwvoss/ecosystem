package coordinator_test

import (
	"../coordinator"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("When an http request timesout", func() {
	It("responds with a populated Err field", func() {
		json := []byte(`
		  {
		  	"path":"/http_error",
		  	"code": 500,
				"response": { "error": "No good" },
		  }
	  `)

		err := coordinator.PrepareServiceResponse(json)
		if err != nil {
			Fail(err.Error())
		}

		url := "http://localhost:9292/http_error"

		context := coordinator.Context{Url: url, Timeout: 5}

		coordinator.RunRescuetime(&context)

		Expect(context.Err.Error()).To(Equal("Non-200 response"))
	})
})
