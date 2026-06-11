const express = require("express");
const fs = require("fs");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 3000;
const DATA_FILE = path.join(__dirname, "data", "todos.json");

app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

function readTodos() {
  return JSON.parse(fs.readFileSync(DATA_FILE, "utf-8"));
}

function writeTodos(todos) {
  fs.writeFileSync(DATA_FILE, JSON.stringify(todos, null, 2) + "\n");
}

app.get("/api/health", (req, res) => {
  res.json({ status: "ok", service: "todos" });
});

app.get("/api/todos", (req, res) => {
  res.json(readTodos());
});

app.post("/api/todos", (req, res) => {
  const { title } = req.body;
  if (!title) {
    return res.status(400).json({ error: "title is required" });
  }
  const todos = readTodos();
  const nextId = todos.length ? Math.max(...todos.map((t) => t.id)) + 1 : 1;
  const todo = { id: nextId, title, done: false };
  todos.push(todo);
  writeTodos(todos);
  res.status(201).json(todo);
});

app.listen(PORT, () => {
  console.log(`Todo app listening on http://localhost:${PORT}`);
});
