package coordinator

import (
	"errors"
	//"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"time"
)

type Context struct {
	Timeout  float64
	Url      string
	response *http.Response
	contents []byte
	file     *os.File
	Err      error
}

func RunRescuetime(context *Context) {
	actions := []func(*Context){
		makeGetRequest,
		getContents,
		createFile,
		saveData,
	}

	for _, action := range actions {
		if context.Err != nil {
			break
		}

		action(context)
	}
}

func makeGetRequest(context *Context) {
	timeoutSeconds := time.Duration(context.Timeout*1000) * time.Millisecond
	client := http.Client{Timeout: timeoutSeconds}
	context.response, context.Err = client.Get(context.Url)
	if context.Err != nil {
		return
	}

	if context.response.StatusCode != http.StatusOK {
		context.Err = errors.New("Non-200 response")
	}
}

func getContents(context *Context) {
	response := context.response
	defer response.Body.Close()

	context.contents, context.Err = ioutil.ReadAll(response.Body)
}

func createFile(context *Context) {
	context.file, context.Err = os.Create("rescuetime_response.json")
}

func saveData(context *Context) {
	file := context.file
	defer file.Close()
	_, context.Err = file.Write(context.contents)
}
