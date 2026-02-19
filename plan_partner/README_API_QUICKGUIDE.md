# Plan Partner — API Quickguide

Overview: Minimal Express REST API for managing in-memory tasks (CRUD).

Prerequisites
- Node.js 18+ installed

Install & run

1. Open a terminal in the api folder:

   cd api

2. Install dependencies:

   npm install

3. Start the server:

   npm start

Or run in development with automatic reload:

   npm run dev

Server default: http://localhost:3000

Endpoints
- GET /tasks — list all tasks
- GET /tasks/:id — get task by id
- POST /tasks — create a task; body JSON: { "title": "...", "description": "..." }
- PUT /tasks/:id — update a task; body JSON with any fields to update
- DELETE /tasks/:id — delete a task

Examples (curl)

Create:

   curl -X POST http://localhost:3000/tasks -H "Content-Type: application/json" -d '{"title":"Buy milk","description":"2 liters"}'

List:

   curl http://localhost:3000/tasks

Get one:

   curl http://localhost:3000/tasks/1

Update:

   curl -X PUT http://localhost:3000/tasks/1 -H "Content-Type: application/json" -d '{"done":true}'

Delete:

   curl -X DELETE http://localhost:3000/tasks/1

Notes / Next steps
- This API uses memory storage — data is lost on restart. Replace with a DB for persistence.
- Optionally add validation, logging, and tests.
