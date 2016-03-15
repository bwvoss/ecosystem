package coordinator_test

import (
	"../coordinator"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("When the commit log fails", func() {
	It("responds with a populated Err field", func() {
		json := []byte(`
		  {
		  	"path":"/rescuetime",
		  	"response": {}
		  }
	  `)

		err := coordinator.PrepareServiceResponse(json)
		if err != nil {
			Fail(err.Error())
		}

		url := "http://localhost:9292/rescuetime"

		context := coordinator.Context{Url: url, Timeout: 5, CommitLog: &coordinator.ErrorCommitLog{}}

		coordinator.RunRescuetime(&context)

		Expect(context.Err.Error()).To(Equal("Failure of Commit Log"))
	})
})
