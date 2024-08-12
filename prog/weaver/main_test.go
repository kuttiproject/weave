package main

import (
	"testing"

	weavetest "github.com/kuttiproject/weave/internal/testing"
)

func TestMain(t *testing.T) {
	if weavetest.TrimTestArgs() {
		main()
	}
}
