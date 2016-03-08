package coordinator

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"time"
)

func check(e error) {
	if e != nil {
		fmt.Println(e)
	}
}

func RunRescuetime(url string) {
	timeout := time.Duration(5 * time.Second)
	client := http.Client{Timeout: timeout}
	response, err := client.Get(url)
	check(err)

	defer response.Body.Close()
	contents, err := ioutil.ReadAll(response.Body)
	check(err)

	file, err := os.Create("rescuetime_response.json")
	check(err)

	defer file.Close()
	_, err = file.Write(contents)
	check(err)

	err = file.Sync()
	check(err)
}
