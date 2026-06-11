// fs-ops.js - the same filesystem operations as the shell scripts, in NodeJS.
// Demonstrates doing OS-independent file work via the built-in `fs` module.
// Run from the repo root:  node node-scripts/fs-ops.js
const fs = require("fs");
const path = require("path");

const work = path.join(__dirname, "..", "build", "fs-demo-node");

console.log("== 1. Create a working directory and a file ==");
fs.mkdirSync(work, { recursive: true });
fs.writeFileSync(path.join(work, "original.txt"), "hello from node\n");

console.log("== 2. List directory contents ==");
console.log(fs.readdirSync(work));

console.log("== 3. Copy the file ==");
fs.copyFileSync(path.join(work, "original.txt"), path.join(work, "copy.txt"));

console.log("== 4. Move (rename) the copy ==");
fs.renameSync(path.join(work, "copy.txt"), path.join(work, "moved.txt"));

console.log("== 5. Create a link ==");
const link = path.join(work, "link-to-original.txt");
if (fs.existsSync(link)) fs.unlinkSync(link);
// linkSync makes a hard link, which (like the PowerShell version) needs no elevation.
fs.linkSync(path.join(work, "original.txt"), link);

console.log("== 6. Change permissions (read-only) ==");
fs.chmodSync(path.join(work, "original.txt"), 0o444);

console.log("== 7. Final listing, then clean up ==");
console.log(fs.readdirSync(work));
fs.chmodSync(path.join(work, "original.txt"), 0o644); // restore so we can delete
fs.rmSync(work, { recursive: true, force: true });
console.log("Cleaned up", work);
