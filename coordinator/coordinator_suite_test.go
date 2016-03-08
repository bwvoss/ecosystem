package coordinator_test

import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"testing"
)

func TestCoordinator(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Coordinator Suite")
}
