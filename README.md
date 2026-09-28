## Запуск базы данных

### Требования
- Docker 24+ и Docker Compose v2
- (опционально) `psql` для подключения с хоста

### Настройка окружения
Скопируйте шаблон и задайте свой пароль:

```bash
cp .env.example .env
```

| Переменная | Назначение | Пример |
|---|---|---|
| `POSTGRES_USER` | пользователь БД | `credit` |
| `POSTGRES_PASSWORD` | пароль пользователя | `change_me` |
| `POSTGRES_DB` | имя базы | `credit_scoring` |
| `POSTGRES_HOST` | хост для подключения **с машины разработчика** | `localhost` |
| `POSTGRES_PORT` | порт на хосте | `5433` |

> Порт `5433` выбран, чтобы не конфликтовать с локально установленным PostgreSQL на `5432`.
> Внутри сети Docker Compose другие сервисы подключаются к БД по адресу `postgres:5432`.

### Запуск

```bash
docker compose up -d
docker compose ps        # статус сервиса postgres должен быть healthy
```

### Подключение
Изнутри контейнера:

```bash
docker compose exec postgres psql -U credit -d credit_scoring
```

С хоста:

```bash
psql -h localhost -p 5433 -U credit -d credit_scoring
```

### Остановка

```bash
docker compose down      # данные сохраняются в томе pgdata
docker compose down -v   # удалить том вместе с данными
```

> Если вы сменили `POSTGRES_USER` или `POSTGRES_PASSWORD` после первого запуска,
> пересоздайте том (`docker compose down -v`): образ PostgreSQL применяет учётные
> данные только при инициализации пустого тома.