package coordinator_test

import (
	"../coordinator"
	"bytes"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"io/ioutil"
	"net/http"
)

func prepareServiceResponse() {
	jsonConfig := []byte(`
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

	req, _ := http.NewRequest("PUT", "http://localhost:9292/__config__/set_response", bytes.NewBuffer(jsonConfig))
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	_, err := client.Do(req)

	if err != nil {
		Fail(err.Error())
	}
}

var _ = Describe("Coordinator", func() {
	It("persists metrics and rescuetime intervals", func() {
		prepareServiceResponse()

		url := "http://localhost:9292/rescuetime?date=2009-11-10&api_key=123asdf"

		coordinator.RunRescuetime(url)

		persisted, _ := ioutil.ReadFile("rescuetime_response.json")

		Ω(persisted).Should(ContainSubstring("[{\"activity\":\"programming\"}]"))
		Ω(persisted).Should(ContainSubstring("{\"duration\":[{\"duration\":1.2}]"))
	})
})
