package coordinator_test

//"fmt"
//"io/ioutil"
//response, _ := http.Get("http://localhost:9292/rescuetime?date=2009-11-10&api_key=123asdf")
//defer response.Body.Close()
//contents, _ := ioutil.ReadAll(response.Body)
//fmt.Println(string(contents))

import (
	"../coordinator"
	"bytes"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"io/ioutil"
	"net/http"
)

var _ = Describe("Coordinator", func() {
	It("persists metrics and rescuetime intervals", func() {
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

		coordinator.RunRescuetime("2009-11-10", "123asdf")

		rescuetimeIntervals, _ := ioutil.ReadFile("db/rescuetime_intervals.json")
		metrics, _ := ioutil.ReadFile("db/metrics.json")

		Expect(rescuetimeIntervals).To(Equal("[{\"activity\":\"programming\"}]"))
		Expect(metrics).To(Equal("{\"duration\":[{\"duration\":1.2}]"))
	})
})
