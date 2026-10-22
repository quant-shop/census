import test from "node:test";
import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";

test("deployed page restricts scripts and connections to expected origins", async () => {
  const html = await readFile("dist/index.html", "utf8");
  const app = await readFile("dist/app.js", "utf8");
  const css = await readFile("dist/styles.css", "utf8");
  assert.match(html, /script-src 'self'/);
  assert.match(html, /connect-src 'self' https:\/\/api\.census\.gov/);
  assert.match(html, /name="referrer" content="no-referrer"/);
  assert.doesNotMatch(app, /import\("https:\/\//);
  assert.doesNotMatch(css, /@import\s+url\(['"]?https:\/\//);
});

test("published logo contains no embedded text or EXIF metadata", async () => {
  const png = await readFile("dist/quant_workshop_logo6.png");
  let offset = 8;
  const types = [];
  while (offset + 12 <= png.length) {
    const length = png.readUInt32BE(offset);
    const type = png.toString("ascii", offset + 4, offset + 8);
    types.push(type);
    offset += 12 + length;
    if (type === "IEND") break;
  }
  assert.ok(types.includes("IDAT"));
  assert.ok(types.includes("IEND"));
  assert.ok(types.every((type) => !["tEXt", "zTXt", "iTXt", "eXIf"].includes(type)));
});
