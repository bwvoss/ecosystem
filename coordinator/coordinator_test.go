package coordinator_test

import (
	"../coordinator"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"io/ioutil"
)

var _ = Describe("Coordinator", func() {
	It("persists metrics and rescuetime intervals", func() {
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

		context := coordinator.Context{Url: url, Timeout: 5}
		coordinator.RunRescuetime(&context)

		persisted, _ := ioutil.ReadFile("rescuetime_response.json")

		Ω(persisted).Should(ContainSubstring("[{\"activity\":\"programming\"}]"))
		Ω(persisted).Should(ContainSubstring("{\"duration\":[{\"duration\":1.2}]"))
	})
})
