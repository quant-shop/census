import { build } from "esbuild";
import { copyFile, mkdir } from "node:fs/promises";
import { stripPngMetadata } from "./png.mjs";

await build({
  entryPoints: ["src/map-geometry.mjs"],
  outfile: "dist/map-geometry.mjs",
  bundle: true,
  format: "esm",
  target: "es2022",
  legalComments: "linked",
});

await copyFile("node_modules/us-atlas/counties-10m.json", "dist/counties-10m.json");
await stripPngMetadata("quant_workshop_logo6.png", "dist/quant_workshop_logo6.png");

await mkdir("dist/fonts", { recursive: true });
await mkdir("dist/licenses", { recursive: true });
for (const name of ["d3-geo", "topojson-client", "us-atlas"]) {
  await copyFile(`node_modules/${name}/LICENSE`, `dist/licenses/${name}.txt`);
}
for (const [family, files] of Object.entries({
  "dm-sans": ["400-normal", "500-normal", "600-normal"],
  newsreader: ["400-normal", "500-normal", "500-italic"],
})) {
  for (const style of files) {
    const name = `${family}-latin-${style}.woff2`;
    await copyFile(`node_modules/@fontsource/${family}/files/${name}`, `dist/fonts/${name}`);
  }
  await copyFile(`node_modules/@fontsource/${family}/LICENSE`, `dist/licenses/${family}.txt`);
}
