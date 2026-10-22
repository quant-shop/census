import { readFile, writeFile } from "node:fs/promises";

const signature = Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]);
const metadataChunks = new Set(["tEXt", "zTXt", "iTXt", "eXIf"]);

export async function stripPngMetadata(source, destination) {
  const input = await readFile(source);
  if (!input.subarray(0, 8).equals(signature)) throw new Error("Expected a PNG image.");
  const chunks = [signature];
  let offset = 8;
  let ended = false;
  while (offset + 12 <= input.length) {
    const length = input.readUInt32BE(offset);
    const end = offset + 12 + length;
    if (end > input.length) throw new Error("Invalid PNG chunk length.");
    const type = input.toString("ascii", offset + 4, offset + 8);
    if (!metadataChunks.has(type)) chunks.push(input.subarray(offset, end));
    offset = end;
    if (type === "IEND") { ended = true; break; }
  }
  if (!ended) throw new Error("PNG image is missing IEND.");
  await writeFile(destination, Buffer.concat(chunks));
}
