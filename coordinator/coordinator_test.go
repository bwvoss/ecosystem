package coordinator_test

import (
	"../coordinator"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("Coordinator", func() {
	It("puts the response in the commit log", func() {
		json := []byte(`
		  {
		  	"path":"/rescuetime?date=2009-11-10&api_key=123asdf",
		  	"response": {
		  		"rescuetime_intervals": [
		  			{"activity": "programming"}
		  		],
		  		"metrics": {
		  			"duration": [
		  				{"duration": 1.2}
		  			]
		  		}
		  	}
		  }
	  `)

		err := coordinator.PrepareServiceResponse(json)
		if err != nil {
			Fail(err.Error())
		}

		url := "http://localhost:9292/rescuetime?date=2009-11-10&api_key=123asdf"

		context := coordinator.Context{Url: url, Timeout: 5, CommitLog: &coordinator.InMemoryCommitLog{}}
		coordinator.RunRescuetime(&context)

		latestCommit := string(context.CommitLog.LatestCommit())

		Expect(latestCommit).To(
			Equal("INSERT:{\"rescuetime_intervals\":[{\"activity\":\"programming\"}],\"metrics\":{\"duration\":[{\"duration\":1.2}]}}"))
	})
})
