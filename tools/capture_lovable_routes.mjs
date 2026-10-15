import { execFileSync, spawn } from 'node:child_process';
import { createHash } from 'node:crypto';
import { mkdir, rm, writeFile } from 'node:fs/promises';
import { join, resolve } from 'node:path';
import { chromium } from 'playwright-core';

const source = resolve(
  process.env.LOVABLE_SOURCE ?? 'C:/dev/pixel-perfect-pixels',
);
const chrome =
  process.env.CHROME_PATH ??
  'C:/Program Files/Google/Chrome/Application/chrome.exe';
const outputRoot = resolve(
  process.env.LOVABLE_CAPTURE_OUTPUT ??
    'docs/product/baselines/lovable',
);
const port = Number(process.env.LOVABLE_CAPTURE_PORT ?? 41732);
const viewports = [
  [360, 800],
  [390, 844],
  [440, 900],
];
const routes = [
  ['review', '/'],
  ['summary', '/summary'],
  ['transaction-new', '/transaction/new'],
  ['transaction-detail', '/transaction/r1'],
  ['movimentacoes', '/movimentacoes'],
  ['settings', '/settings'],
  ['onboarding', '/onboarding'],
  ['import', '/import'],
  ['duplicates', '/duplicates'],
  ['family', '/family'],
  ['rules', '/rules'],
  ['backup', '/backup'],
  ['sync-privacy', '/sync-privacy'],
  ['reports-mensal', '/reports/mensal'],
  ['reports-parcelas', '/reports/parcelas'],
  ['identidade', '/identidade'],
  ['registries', '/registries'],
  ['invoices', '/invoices'],
  ['commitments', '/commitments'],
  ['capture', '/capture'],
  ['local-data', '/local-data'],
];

const sha = execFileSync('git', ['-C', source, 'rev-parse', 'HEAD'], {
  encoding: 'utf8',
}).trim();
const shortSha = sha.slice(0, 7);
const target = join(outputRoot, shortSha);
let vite;

async function waitForServer(url) {
  for (let attempt = 0; attempt < 100; attempt += 1) {
    try {
      const response = await fetch(url);
      if (response.ok) return;
    } catch (_) {
      // Vite may still be starting.
    }
    await new Promise((resolveWait) => setTimeout(resolveWait, 150));
  }
  throw new Error(`Lovable nao iniciou em ${url}.`);
}

try {
  await rm(target, { recursive: true, force: true });
  await mkdir(target, { recursive: true });
  vite = spawn(
    `npm run dev -- --host 127.0.0.1 --port ${port} --strictPort`,
    {
      cwd: source,
      stdio: 'ignore',
      windowsHide: true,
      shell: true,
    },
  );
  await waitForServer(`http://127.0.0.1:${port}/summary`);
  const browser = await chromium.launch({
    executablePath: chrome,
    headless: true,
  });
  const manifest = {
    source,
    commit: sha,
    chrome: browser.version(),
    generatedAt: new Date().toISOString(),
    captures: [],
  };

  for (const [width, height] of viewports) {
    const viewportName = `${width}x${height}`;
    const viewportTarget = join(target, viewportName);
    await mkdir(viewportTarget, { recursive: true });
    const context = await browser.newContext({
      viewport: { width, height },
      deviceScaleFactor: 1,
      colorScheme: 'light',
      reducedMotion: 'reduce',
    });
    for (const [slug, route] of routes) {
      const page = await context.newPage();
      await page.goto(`http://127.0.0.1:${port}${route}`, {
        waitUntil: 'networkidle',
      });
      await page.evaluate(async () => {
        await document.fonts.ready;
        document.documentElement.classList.add('visual-capture');
      });
      const bytes = await page.screenshot({
        fullPage: true,
        animations: 'disabled',
      });
      const fileName = `${slug}.png`;
      await writeFile(join(viewportTarget, fileName), bytes);
      manifest.captures.push({
        slug,
        route,
        viewport: viewportName,
        file: `${viewportName}/${fileName}`,
        sha256: createHash('sha256').update(bytes).digest('hex'),
      });
      await page.close();
    }
    await context.close();
  }
  await browser.close();
  await writeFile(
    join(target, 'manifest.json'),
    JSON.stringify(manifest, null, 2),
  );
  console.log(
    `Capturadas ${manifest.captures.length} telas Lovable em ${target}`,
  );
} finally {
  if (vite && !vite.killed) vite.kill();
}
