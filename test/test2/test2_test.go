package test2

import (
	"fmt"
	"os/exec"
	"testing"
)

func Test(t *testing.T) {
	cmd := exec.Command("ls", "-l")
	output, err := cmd.Output()
	if err != nil {
		fmt.Println("Error:", err)
		return
	}
	fmt.Println(string(output))
}
