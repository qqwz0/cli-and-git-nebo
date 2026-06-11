// migrate.js - a tiny "DB migration" over the JSON data file.
// Demonstrates a server-side maintenance task run from the CLI, the kind of thing
// you would run against a real database (e.g. adding a column / backfilling values).
//
// This migration adds a `createdAt` field to every todo that lacks one.
// It is idempotent: running it twice changes nothing the second time.
//
// Run from the repo root:  node node-scripts/migrate.js
const fs = require("fs");
const path = require("path");

const DATA_FILE = path.join(__dirname, "..", "app", "data", "todos.json");

function migrate() {
  const todos = JSON.parse(fs.readFileSync(DATA_FILE, "utf-8"));
  let changed = 0;

  for (const todo of todos) {
    if (!("createdAt" in todo)) {
      todo.createdAt = new Date().toISOString();
      changed++;
    }
  }

  if (changed === 0) {
    console.log("Migration: nothing to do, all todos already have createdAt.");
    return;
  }

  fs.writeFileSync(DATA_FILE, JSON.stringify(todos, null, 2) + "\n");
  console.log(`Migration: added createdAt to ${changed} todo(s).`);
}

migrate();
