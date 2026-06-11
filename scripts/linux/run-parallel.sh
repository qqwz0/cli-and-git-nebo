#!/usr/bin/env bash
# run-parallel.sh - Run several tasks in parallel on Linux using background jobs.
# Demonstrates the & operator to background processes and wait to join them.
# Run from the repo root:  ./scripts/linux/run-parallel.sh
set -euo pipefail

worker() {
  local n="$1"
  sleep "$n"                      # simulate uneven work
  echo "worker-$n finished after ${n}s"
}

echo "== Starting 3 workers in parallel =="
pids=()
for n in 1 2 3; do
  worker "$n" &                   # run in background
  pids+=("$!")                    # remember each PID
  echo "launched worker-$n (pid $!)"
done

echo
echo "== Waiting for all workers to finish =="
for pid in "${pids[@]}"; do
  wait "$pid"
done

echo
echo "== All parallel work complete =="
