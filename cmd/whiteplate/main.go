package main

import (
	"log"
	"os"
	"strings"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

const appName = "whiteplate"

// to be changed using ldflags with the go build command
var version = "unknown"

func main() {
	logger := log.New(os.Stderr, "", log.LstdFlags)

	var rootCmd = &cobra.Command{
		Use: appName,
	}

	buildCmdTree(rootCmd)

	err := viper.BindPFlags(rootCmd.Flags())
	if err != nil {
		logger.Printf("unable to BindPFlags: %v", err)
		os.Exit(1)
	}

	if err := rootCmd.Execute(); err != nil {
		logger.Println(err)
		os.Exit(1)
	}
}

func viperAutoEnvVar() {
	// TODO(glynternet): make this non-global
	viper.SetEnvKeyReplacer(strings.NewReplacer("-", "_"))
	viper.AutomaticEnv() // read in environment variables that match
}
