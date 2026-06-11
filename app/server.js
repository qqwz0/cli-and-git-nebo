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

app.get("/api/health", (req, res) => {
  res.json({ status: "ok", service: "todos" });
});

app.get("/api/todos", (req, res) => {
  res.json(readTodos());
});

app.listen(PORT, () => {
  console.log(`Todo app listening on http://localhost:${PORT}`);
});
