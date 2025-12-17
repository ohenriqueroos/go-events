package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

// Handler is the function that runs when your API is hit
func Handler(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	fmt.Printf("Processing request data: %s\n", request.Body)

	return events.APIGatewayProxyResponse{
		Body:       "Hello from Go and OpenTofu!",
		StatusCode: 200,
	}, nil
}

func main() {
	lambda.Start(Handler)
}
