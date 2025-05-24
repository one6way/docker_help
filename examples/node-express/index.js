const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const { config } = require('dotenv');

// Загрузка переменных окружения из .env файла
config();

// Создание Express приложения
const app = express();
const port = process.env.PORT || 3000;

// Настройка middleware
app.use(helmet()); // Безопасность
app.use(cors()); // CORS
app.use(express.json()); // Парсинг JSON
app.use(morgan('combined')); // Логирование

// Основной маршрут
app.get('/', (req, res) => {
  res.json({
    message: 'Express API is running',
    version: process.env.API_VERSION || '1.0.0',
    environment: process.env.NODE_ENV || 'development'
  });
});

// Проверка работоспособности для контейнера
app.get('/health', (req, res) => {
  res.json({
    status: 'up',
    timestamp: new Date().toISOString()
  });
});

// Пример API маршрута
app.get('/api/items', (req, res) => {
  const items = [
    { id: 1, name: 'Item 1' },
    { id: 2, name: 'Item 2' },
    { id: 3, name: 'Item 3' }
  ];
  res.json(items);
});

// Обработка ошибок
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Internal Server Error',
    message: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// Запуск сервера
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
}); 