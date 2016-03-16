package coordinator

import (
	//"fmt"
	"errors"
	"io/ioutil"
	"net/http"
	"time"
)

func RunRescuetime(context *Context) {
	actions := []func(*Context){
		makeGetRequest,
		getContents,
		verifyOkStatusCode,
		appendCommitLog,
	}

	Run(context, actions)
}

func makeGetRequest(context *Context) {
	timeoutSeconds := time.Duration(context.Timeout*1000) * time.Millisecond
	client := http.Client{Timeout: timeoutSeconds}
	context.response, context.Err = client.Get(context.Url)
}

func getContents(context *Context) {
	response := context.response
	defer response.Body.Close()

	context.contents, context.Err = ioutil.ReadAll(response.Body)
}

func verifyOkStatusCode(context *Context) {
	if context.response.StatusCode != http.StatusOK {
		context.Err = errors.New(string(context.contents))
	}
}

func appendCommitLog(context *Context) {
	commit := append([]byte{'I', 'N', 'S', 'E', 'R', 'T', ':'}, context.contents...)
	context.Err = context.CommitLog.AppendCommit(commit)
}
