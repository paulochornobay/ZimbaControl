import { execFileSync, spawn } from 'node:child_process';
import { createHash } from 'node:crypto';
import { mkdir, readFile, rm, writeFile } from 'node:fs/promises';
import { join, resolve } from 'node:path';
import { chromium } from 'playwright-core';
import { PNG } from 'pngjs';

const root = resolve(process.env.LOVABLE_SOURCE ?? 'C:/dev/pixel-perfect-pixels');
const chrome = process.env.CHROME_PATH ?? 'C:/Program Files/Google/Chrome/Application/chrome.exe';
const output = resolve(process.env.LOVABLE_CAPTURE_OUTPUT ?? 'artifacts/lovable-reference');
const port = Number(process.env.LOVABLE_CAPTURE_PORT ?? 41731);
const viewports = [[360, 800], [390, 844], [440, 900]];
const states = [
  ['pessoa', null], ['categoria', 'Categoria'], ['centro', 'Centro'],
];

const sha = execFileSync('git', ['-C', root, 'rev-parse', 'HEAD'], { encoding: 'utf8' }).trim();
const target = join(output, sha);
let vite;

async function waitForServer(url) {
  for (let attempt = 0; attempt < 80; attempt += 1) {
    try {
      const response = await fetch(url);
      if (response.ok) return;
    } catch (_) {}
    await new Promise((resolveWait) => setTimeout(resolveWait, 125));
  }
  throw new Error(`Lovable não iniciou em ${url}.`);
}

function textAndIconMask() {
  const rects = [];
  const add = (rect) => {
    if (rect.width < 1 || rect.height < 1) return;
    rects.push({
      x: Math.max(0, Math.floor(rect.left) - 2),
      y: Math.max(0, Math.floor(rect.top + scrollY) - 2),
      width: Math.min(innerWidth, Math.ceil(rect.right) + 2) - Math.max(0, Math.floor(rect.left) - 2),
      height: Math.ceil(rect.bottom + scrollY) + 2 - Math.max(0, Math.floor(rect.top + scrollY) - 2),
    });
  };
  const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
  for (let node = walker.nextNode(); node; node = walker.nextNode()) {
    if (!node.textContent?.trim()) continue;
    const range = document.createRange();
    range.selectNodeContents(node);
    for (const rect of range.getClientRects()) add(rect);
  }
  for (const icon of document.querySelectorAll('svg')) add(icon.getBoundingClientRect());
  return rects;
}

try {
  await rm(target, { recursive: true, force: true });
  await mkdir(target, { recursive: true });
  vite = spawn('npm run dev -- --host 127.0.0.1 --port ' + String(port) + ' --strictPort', {
    cwd: root, stdio: 'ignore', windowsHide: true, shell: true,
  });
  await waitForServer(`http://127.0.0.1:${port}/summary`);
  const browser = await chromium.launch({ executablePath: chrome, headless: true });
  const manifest = { source: root, commit: sha, chrome: browser.version(), generatedAt: new Date().toISOString(), captures: [] };
  for (const [width, height] of viewports) {
    const context = await browser.newContext({ viewport: { width, height }, deviceScaleFactor: 1, colorScheme: 'light' });
    for (const [state, button] of states) {
      const page = await context.newPage();
      await page.goto(`http://127.0.0.1:${port}/summary`, { waitUntil: 'networkidle' });
      await page.evaluate(async () => { await document.fonts.ready; });
      if (button) await page.getByRole('button', { name: button, exact: true }).click();
      await page.evaluate(() => document.documentElement.classList.add('visual-capture'));
      const name = `summary-${state}-${width}x${height}`;
      const png = join(target, `${name}.png`);
      const [fullBytes, masks, navigation] = await Promise.all([
        page.screenshot({ fullPage: true, animations: 'disabled' }),
        page.evaluate(textAndIconMask),
        page.locator('nav').boundingBox(),
      ]);
      const full = PNG.sync.read(fullBytes);
      const navigationHeight = Math.ceil(navigation?.height ?? 66);
      const composed = new PNG({ width, height });
      PNG.bitblt(full, composed, 0, 0, width, height - navigationHeight, 0, 0);
      PNG.bitblt(full, composed, 0, full.height - navigationHeight, width, navigationHeight, 0, height - navigationHeight);
      const bytes = PNG.sync.write(composed);
      await writeFile(png, bytes);
      const masksForViewport = masks.map((rect) => {
        if (rect.y >= full.height - navigationHeight - 4) {
          return { ...rect, y: rect.y - (full.height - height) };
        }
        return rect;
      }).filter((rect) => rect.y < height && rect.y + rect.height > 0);
      await writeFile(join(target, `${name}.mask.json`), JSON.stringify(masksForViewport));
      manifest.captures.push({ name, viewport: `${width}x${height}`, state, sha256: createHash('sha256').update(bytes).digest('hex'), mask: `${name}.mask.json` });
      await page.close();
    }
    await context.close();
  }
  await browser.close();
  await writeFile(join(target, 'manifest.json'), JSON.stringify(manifest, null, 2));
  console.log(`Referência Lovable capturada em ${target}`);
} finally {
  if (vite && !vite.killed) vite.kill();
}
