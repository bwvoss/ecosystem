package coordinator

import (
	"net/http"
)

type Context struct {
	Timeout   float64
	Url       string
	response  *http.Response
	contents  []byte
	CommitLog CommitLog
	Err       error
}

func Run(context *Context, actions []func(*Context)) {
	for _, action := range actions {
		action(context)

		if context.Err != nil {
			break
		}
	}
}
