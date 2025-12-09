package main

import (
	"context"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

// Seu Handler original (Lógica Pura)
func Handler(ctx context.Context, req events.APIGatewayV2HTTPRequest) (events.APIGatewayProxyResponse, error) {
	fmt.Printf("Request recebido! Body: %s\n", req.Body)

	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Body:       `{"message": "Recebido com sucesso", "status": "processing"}`,
		Headers:    map[string]string{"Content-Type": "application/json"},
	}, nil
}

func main() {
	// Se tivermos uma variável de ambiente LOCAL definida, rodamos como servidor HTTP
	if os.Getenv("LOCAL") == "true" {
		runLocalServer()
	} else {
		// Se não, rodamos como Lambda (Modo AWS)
		lambda.Start(Handler)
	}
}

// Essa função simula o API Gateway localmente
func runLocalServer() {
	http.HandleFunc("/webhook", func(w http.ResponseWriter, r *http.Request) {
		// --- BLOQUEIO DE SEGURANÇA LOCAL ---
		// Verifica se o método é POST. Se não for, rejeita.
		if r.Method != http.MethodPost {
			http.Error(w, "Method Not Allowed (Local Simulation)", http.StatusMethodNotAllowed)
			return
		}
		// -----------------------------------

		bodyBytes, _ := io.ReadAll(r.Body)

		lambdaReq := events.APIGatewayV2HTTPRequest{
			Body: string(bodyBytes),
		}

		resp, err := Handler(context.TODO(), lambdaReq)
		if err != nil {
			http.Error(w, err.Error(), 500)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(resp.StatusCode)
		w.Write([]byte(resp.Body))
	})

	fmt.Println("🚀 Servidor local rodando em http://localhost:8080/webhook (Somente POST)")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
