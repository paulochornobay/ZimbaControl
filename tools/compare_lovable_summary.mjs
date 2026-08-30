import { execFileSync } from 'node:child_process';
import { mkdir, readFile, rm, writeFile } from 'node:fs/promises';
import { join, resolve } from 'node:path';
import { PNG } from 'pngjs';

const root = resolve(process.env.LOVABLE_SOURCE ?? 'C:/dev/pixel-perfect-pixels');
const sha = execFileSync('git', ['-C', root, 'rev-parse', 'HEAD'], { encoding: 'utf8' }).trim();
const reference = resolve(process.env.LOVABLE_CAPTURE_OUTPUT ?? 'artifacts/lovable-reference', sha);
const flutter = resolve(process.env.FLUTTER_SUMMARY_GOLDENS ?? 'apps/mobile/test/goldens/lovable_summary');
const output = resolve('artifacts/lovable-comparison', sha);
const names = [
  ...['360x800', '390x844', '440x900'].flatMap((viewport) =>
    ['pessoa', 'categoria', 'centro'].map((state) => `summary-${state}-${viewport}`)),
];
const maxChangedPercent = 0.002;
const colorTolerance = 8;

await rm(output, { recursive: true, force: true });
await mkdir(output, { recursive: true });
let failed = false;
for (const name of names) {
  const [base, actual, mask] = await Promise.all([
    PNG.sync.read(await readFile(join(reference, `${name}.png`))),
    PNG.sync.read(await readFile(join(flutter, `${name}.png`))),
    JSON.parse(await readFile(join(reference, `${name}.mask.json`), 'utf8')),
  ]);
  if (base.width !== actual.width || base.height !== actual.height) {
    throw new Error(`${name}: dimensões divergentes (${base.width}x${base.height} vs ${actual.width}x${actual.height}).`);
  }
  const ignored = new Uint8Array(base.width * base.height);
  for (const rect of mask) {
    for (let y = rect.y; y < rect.y + rect.height; y += 1)
      for (let x = rect.x; x < rect.x + rect.width; x += 1)
        if (x >= 0 && y >= 0 && x < base.width && y < base.height) ignored[y * base.width + x] = 1;
  }
  const diff = new PNG({ width: base.width, height: base.height });
  let compared = 0, changed = 0;
  for (let pixel = 0; pixel < ignored.length; pixel += 1) {
    const offset = pixel * 4;
    if (ignored[pixel]) { diff.data.set([255, 255, 255, 0], offset); continue; }
    compared += 1;
    const delta = Math.max(...[0, 1, 2].map((channel) => Math.abs(base.data[offset + channel] - actual.data[offset + channel])));
    if (delta > colorTolerance) { changed += 1; diff.data.set([255, 0, 0, 255], offset); }
    else diff.data.set([255, 255, 255, 0], offset);
  }
  const changedPercent = changed / compared;
  await writeFile(join(output, `${name}.diff.png`), PNG.sync.write(diff));
  const report = { name, compared, changed, changedPercent, passed: changedPercent <= maxChangedPercent };
  await writeFile(join(output, `${name}.json`), JSON.stringify(report, null, 2));
  console.log(`${name}: ${(changedPercent * 100).toFixed(3)}%`);
  failed ||= !report.passed;
}
if (failed) throw new Error(`Paridade estrutural excedeu ${(maxChangedPercent * 100).toFixed(2)}%. Veja ${output}.`);
