package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"time"
)

// Item представляет структуру элемента для API
type Item struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

// HealthResponse представляет ответ для проверки здоровья
type HealthResponse struct {
	Status    string `json:"status"`
	Version   string `json:"version"`
	Timestamp string `json:"timestamp"`
}

// APIResponse представляет стандартный ответ API
type APIResponse struct {
	Status  string `json:"status"`
	Message string `json:"message"`
	Version string `json:"version"`
}

func main() {
	// Получение порта из переменной окружения или использование дефолтного
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Получение версии API
	version := os.Getenv("API_VERSION")
	if version == "" {
		version = "1.0.0"
	}

	// Маршрут для главной страницы
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		response := APIResponse{
			Status:  "success",
			Message: "Go API is running",
			Version: version,
		}

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)
	})

	// Маршрут для проверки здоровья
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		response := HealthResponse{
			Status:    "up",
			Version:   version,
			Timestamp: time.Now().Format(time.RFC3339),
		}

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)
	})

	// Маршрут для API
	http.HandleFunc("/api/items", func(w http.ResponseWriter, r *http.Request) {
		items := []Item{
			{ID: 1, Name: "Item 1"},
			{ID: 2, Name: "Item 2"},
			{ID: 3, Name: "Item 3"},
		}

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(items)
	})

	// Запуск сервера
	log.Printf("Starting server on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatalf("Error starting server: %s", err)
	}
} 