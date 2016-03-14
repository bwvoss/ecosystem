package main

import (
	"fmt"
	"github.com/gorilla/mux"
	"html"
	"log"
	"net/http"
)

func main() {
	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/run_rescuetime", runRescuetime)
	log.Fatal(http.ListenAndServe(":8080", router))
}

func runRescuetime(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, %q", html.EscapeString(r.URL.Path))
}
