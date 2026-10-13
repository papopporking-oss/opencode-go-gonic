package test1

import (
	"errors"
	"fmt"
	"testing"
)

func Hello(name string) (string, error) {
	if name == "" {
		return "", errors.New("empty name")
	}
	message := fmt.Sprintf("Hi, %v. Welcome!", name)
	return message, nil
}

func TestHelloName(t *testing.T) {
	name := "Gladys"
	want := "Hi, Gladys. Welcome!"

	msg, err := Hello(name)
	if msg != want || err != nil {
		t.Fatalf(`Hello(%q) = %q, %v, want match for %#q, nil`, name, msg, err, want)
	}
}

func TestHelloEmpty(t *testing.T) {
	msg, err := Hello("")
	if msg != "" || err == nil {
		t.Fatalf(`Hello("") = %q, %v, want "", error`, msg, err)
	}
}
