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
		  	"path":"/timeout",
		  	"response": {},
				"hang": 0.02
		  }
	  `)

		err := coordinator.PrepareServiceResponse(json)
		if err != nil {
			Fail(err.Error())
		}

		url := "http://localhost:9292/timeout"

		context := coordinator.Context{Url: url, Timeout: 0.01}

		coordinator.RunRescuetime(&context)

		Expect(context.Err.Error()).To(Equal("Get http://localhost:9292/timeout: net/http: request canceled (Client.Timeout exceeded while awaiting headers)"))
	})
})
