package coordinator

import (
	"bytes"
	"net/http"
)

func PrepareServiceResponse(json []byte) error {
	err := setResponse(json)

	return err
}

func setResponse(json []byte) error {
	req, _ := http.NewRequest("PUT", "http://localhost:9292/__config__/set_response", bytes.NewBuffer(json))
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	_, err := client.Do(req)

	return err
}
