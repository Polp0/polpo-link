# grand-line Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a mobile-first One Piece filler guide at filler.polpo.tech with dual-panel UI (search + heatmap grid).

**Architecture:** Single static HTML page with inline CSS and JS. Episode data hardcoded as range arrays, expanded to a flat lookup array at load. Two bidirectionally-linked panels: search/info (fixed top) and heatmap grid (scrollable bottom).

**Tech Stack:** HTML/CSS/JS (no dependencies), Cloudflare Pages, wrangler CLI.

**Design doc:** `docs/plans/2026-03-05-grand-line-design.md`

---

### Task 1: Create repo and project scaffold

**Files:**
- Create: `~/repos/grand-line/index.html`
- Create: `~/repos/grand-line/CLAUDE.md`

**Step 1: Create directory and init git repo**

```bash
mkdir -p ~/repos/grand-line
cd ~/repos/grand-line
git init
```

**Step 2: Create CLAUDE.md with project conventions**

Create `~/repos/grand-line/CLAUDE.md`:

```markdown
# grand-line

One Piece filler guide — filler.polpo.tech

## Stack

- HTML/CSS/JS statico (no framework, no dipendenze)
- Hosting: Cloudflare Pages
- Dominio: filler.polpo.tech

## Dev locale

```bash
npx serve
```

Apri http://localhost:3000

## Deploy

```bash
export PATH="$HOME/.nvm/versions/node/v24.11.1/bin:$PATH"
npx wrangler pages deploy . --project-name=grand-line --branch=main --commit-dirty=true
```

## Struttura

```
index.html  - tutto in un file (HTML + CSS inline + JS inline)
```
```

**Step 3: Create minimal index.html skeleton**

Create `~/repos/grand-line/index.html`:

```html
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>ONE PIECE filler guide</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        html, body { height: 100%; }
        body {
            font-family: system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
            background: #0a1628;
            color: #fff;
        }
    </style>
</head>
<body>
    <div id="app">
        <section id="search-panel"></section>
        <section id="grid-panel"></section>
    </div>
</body>
</html>
```

**Step 4: Verify and commit**

```bash
open index.html  # should show navy background, nothing else
git add -A
git commit -m "Initial scaffold: index.html + CLAUDE.md"
```

---

### Task 2: Episode data layer

**Files:**
- Modify: `~/repos/grand-line/index.html` (add `<script>` block)

**Step 1: Add episode range data and lookup builder**

Add before `</body>` in index.html:

```html
<script>
// Episode types
const CANON = 'canon';
const FILLER = 'filler';
const MIXED = 'mixed';
const ANIME = 'anime';

const TOTAL_EPISODES = 1155;

// Ranges: [start, end, type] — single episodes have start === end
const RANGES = [
    [1,44,CANON],[45,47,MIXED],[48,49,CANON],[50,51,ANIME],[52,53,CANON],
    [54,60,FILLER],[61,61,MIXED],[62,67,CANON],[68,69,MIXED],[70,92,CANON],
    [93,93,ANIME],[94,97,CANON],[98,99,FILLER],[100,100,CANON],[101,101,MIXED],
    [102,102,FILLER],[103,130,CANON],[131,143,FILLER],[144,195,CANON],
    [196,206,FILLER],[207,212,CANON],[213,216,ANIME],[217,219,CANON],
    [220,225,FILLER],[226,226,MIXED],[227,278,CANON],[279,283,FILLER],
    [284,290,CANON],[291,292,FILLER],[293,302,CANON],[303,303,FILLER],
    [304,316,CANON],[317,319,FILLER],[320,325,CANON],[326,336,FILLER],
    [337,353,CANON],[354,354,MIXED],[355,381,CANON],[382,384,FILLER],
    [385,405,CANON],[406,407,FILLER],[408,417,CANON],[418,420,ANIME],
    [421,421,MIXED],[422,425,CANON],[426,429,FILLER],[430,452,CANON],
    [453,456,ANIME],[457,458,FILLER],[459,488,CANON],[489,489,MIXED],
    [490,491,CANON],[492,492,FILLER],[493,496,CANON],[497,499,ANIME],
    [500,505,CANON],[506,506,ANIME],[507,519,CANON],[520,520,MIXED],
    [521,541,CANON],[542,542,FILLER],[543,573,CANON],[574,574,MIXED],
    [575,578,FILLER],[579,589,CANON],[590,590,FILLER],[591,624,CANON],
    [625,625,MIXED],[626,627,FILLER],[628,628,MIXED],[629,632,CANON],
    [633,633,MIXED],[634,652,CANON],[653,653,MIXED],[654,656,CANON],
    [657,657,MIXED],[658,678,CANON],[679,679,MIXED],[680,689,CANON],
    [690,690,MIXED],[691,730,CANON],[731,731,MIXED],[732,736,CANON],
    [737,737,ANIME],[738,738,MIXED],[739,746,CANON],[747,750,FILLER],
    [751,751,MIXED],[752,774,CANON],[775,775,ANIME],[776,776,CANON],
    [777,778,MIXED],[779,779,CANON],[780,782,FILLER],[783,788,CANON],
    [789,789,MIXED],[790,802,CANON],[803,803,MIXED],[804,806,CANON],
    [807,807,MIXED],[808,877,CANON],[878,879,MIXED],[880,880,CANON],
    [881,885,MIXED],[886,886,CANON],[887,890,MIXED],[891,894,CANON],
    [895,896,FILLER],[897,906,CANON],[907,907,FILLER],[908,923,CANON],
    [924,924,MIXED],[925,987,CANON],[988,989,MIXED],[990,990,CANON],
    [991,991,MIXED],[992,1028,CANON],[1029,1030,FILLER],[1031,1083,CANON],
    [1084,1084,ANIME],[1085,1155,CANON]
];

// Build flat lookup: episodes[1] through episodes[1155]
const episodes = new Array(TOTAL_EPISODES + 1);
for (const [start, end, type] of RANGES) {
    for (let i = start; i <= end; i++) episodes[i] = type;
}

// Helper: find next non-filler episode after ep
function nextNonFiller(ep) {
    for (let i = ep + 1; i <= TOTAL_EPISODES; i++) {
        if (episodes[i] !== FILLER) return i;
    }
    return null;
}

// Type display config
const TYPE_INFO = {
    [CANON]:  { label: 'CANON',       color: '#2d6a4f' },
    [FILLER]: { label: 'FILLER',      color: '#c1121f' },
    [MIXED]:  { label: 'MIXED',       color: '#e9c46a' },
    [ANIME]:  { label: 'ANIME CANON', color: '#219ebc' }
};
</script>
```

**Step 2: Verify in browser console**

Open index.html, open DevTools console:
```js
episodes[1]    // "canon"
episodes[54]   // "filler"
episodes[45]   // "mixed"
episodes[50]   // "anime"
nextNonFiller(54) // 61 (mixed, which is non-filler)
```

**Step 3: Commit**

```bash
git add index.html
git commit -m "Add episode data layer with ranges and lookup"
```

---

### Task 3: Search panel HTML + CSS

**Files:**
- Modify: `~/repos/grand-line/index.html`

**Step 1: Add search panel HTML**

Replace `<section id="search-panel"></section>` with:

```html
<section id="search-panel">
    <div class="title">
        <h1>ONE PIECE</h1>
        <span class="subtitle">filler guide</span>
    </div>
    <div class="search-box">
        <input type="number" id="ep-input" min="1" max="1155" placeholder="episode #" inputmode="numeric">
    </div>
    <div id="result-card" class="result-card hidden">
        <div class="result-current" id="result-current"></div>
        <div class="result-next" id="result-next"></div>
        <div class="result-skip" id="result-skip"></div>
    </div>
    <div class="legend">
        <span class="legend-item"><span class="dot" style="background:#2d6a4f"></span>Canon</span>
        <span class="legend-item"><span class="dot" style="background:#c1121f"></span>Filler</span>
        <span class="legend-item"><span class="dot" style="background:#e9c46a"></span>Mixed</span>
        <span class="legend-item"><span class="dot" style="background:#219ebc"></span>Anime</span>
    </div>
</section>
```

**Step 2: Add CSS for search panel**

Add inside `<style>`:

```css
#app {
    display: flex;
    flex-direction: column;
    height: 100%;
    overflow: hidden;
}

/* --- Search Panel --- */
#search-panel {
    flex-shrink: 0;
    padding: 20px 16px 12px;
    padding-top: calc(20px + env(safe-area-inset-top, 0px));
    background: #0a1628;
    border-bottom: 1px solid rgba(255,255,255,0.1);
}

.title {
    text-align: center;
    margin-bottom: 16px;
}

.title h1 {
    font-size: 24px;
    font-weight: 800;
    color: #f4d35e;
    letter-spacing: 2px;
}

.title .subtitle {
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 3px;
    opacity: 0.5;
}

.search-box {
    margin-bottom: 12px;
}

#ep-input {
    width: 100%;
    padding: 14px 16px;
    font-size: 20px;
    font-weight: 600;
    font-family: inherit;
    background: rgba(255,255,255,0.08);
    border: 2px solid rgba(255,255,255,0.15);
    border-radius: 12px;
    color: #fff;
    text-align: center;
    outline: none;
    -moz-appearance: textfield;
}

#ep-input::-webkit-inner-spin-button,
#ep-input::-webkit-outer-spin-button {
    -webkit-appearance: none;
}

#ep-input:focus {
    border-color: #f4d35e;
}

#ep-input::placeholder {
    color: rgba(255,255,255,0.3);
    font-weight: 400;
}

/* --- Result Card --- */
.result-card {
    background: rgba(255,255,255,0.06);
    border-radius: 12px;
    padding: 12px 16px;
    margin-bottom: 12px;
    transition: opacity 0.2s;
}

.result-card.hidden {
    display: none;
}

.result-current {
    font-size: 18px;
    font-weight: 700;
    margin-bottom: 6px;
}

.result-next, .result-skip {
    font-size: 13px;
    opacity: 0.7;
    margin-top: 4px;
    cursor: pointer;
}

.result-next:hover, .result-skip:hover {
    opacity: 1;
}

.type-tag {
    display: inline-block;
    padding: 2px 8px;
    border-radius: 4px;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 1px;
    vertical-align: middle;
    margin-left: 6px;
}

/* --- Legend --- */
.legend {
    display: flex;
    justify-content: center;
    gap: 12px;
    font-size: 10px;
    opacity: 0.6;
}

.dot {
    display: inline-block;
    width: 8px;
    height: 8px;
    border-radius: 50%;
    margin-right: 4px;
    vertical-align: middle;
}
```

**Step 3: Verify — open in browser**

Should see: navy background, yellow "ONE PIECE" title, "filler guide" subtitle, large input field, legend at bottom.

**Step 4: Commit**

```bash
git add index.html
git commit -m "Add search panel HTML and CSS"
```

---

### Task 4: Grid panel HTML + CSS

**Files:**
- Modify: `~/repos/grand-line/index.html`

**Step 1: Add grid panel HTML**

Replace `<section id="grid-panel"></section>` with:

```html
<section id="grid-panel">
    <div id="grid" class="grid"></div>
</section>
```

**Step 2: Add CSS for grid panel**

Add inside `<style>`:

```css
/* --- Grid Panel --- */
#grid-panel {
    flex: 1;
    overflow-y: auto;
    overflow-x: hidden;
    padding: 12px 8px;
    -webkit-overflow-scrolling: touch;
    scrollbar-width: none;
}

#grid-panel::-webkit-scrollbar {
    display: none;
}

.grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, 28px);
    justify-content: center;
    gap: 3px;
}

.cell {
    width: 28px;
    height: 28px;
    border-radius: 4px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 9px;
    font-weight: 600;
    cursor: pointer;
    user-select: none;
    -webkit-user-select: none;
    transition: outline 0.15s;
    color: rgba(255,255,255,0.7);
}

.cell:active {
    transform: scale(0.92);
}

.cell.selected {
    outline: 2px solid #fff;
    outline-offset: 1px;
    color: #fff;
}
```

**Step 3: Verify — open in browser**

Grid panel should appear as empty scrollable area below the search panel.

**Step 4: Commit**

```bash
git add index.html
git commit -m "Add grid panel HTML and CSS"
```

---

### Task 5: Grid rendering (JS)

**Files:**
- Modify: `~/repos/grand-line/index.html` (add to `<script>`)

**Step 1: Add grid rendering function**

Add to the script block:

```js
const grid = document.getElementById('grid');
const cells = [];

function renderGrid() {
    const fragment = document.createDocumentFragment();
    for (let i = 1; i <= TOTAL_EPISODES; i++) {
        const cell = document.createElement('div');
        cell.className = 'cell';
        cell.textContent = i;
        cell.style.background = TYPE_INFO[episodes[i]].color;
        cell.dataset.ep = i;
        fragment.appendChild(cell);
        cells[i] = cell;
    }
    grid.appendChild(fragment);
}

renderGrid();
```

**Step 2: Verify in browser**

Should see a colored grid of 1155 numbered cells. Green dominant (canon), red patches (filler arcs), yellow/blue scattered.

**Step 3: Commit**

```bash
git add index.html
git commit -m "Render episode heatmap grid"
```

---

### Task 6: Search panel logic (JS)

**Files:**
- Modify: `~/repos/grand-line/index.html` (add to `<script>`)

**Step 1: Add search/result logic**

Add to the script block:

```js
const epInput = document.getElementById('ep-input');
const resultCard = document.getElementById('result-card');
const resultCurrent = document.getElementById('result-current');
const resultNext = document.getElementById('result-next');
const resultSkip = document.getElementById('result-skip');

let selectedEp = null;

function makeTag(type) {
    const info = TYPE_INFO[type];
    return `<span class="type-tag" style="background:${info.color}">${info.label}</span>`;
}

function selectEpisode(ep) {
    ep = parseInt(ep);
    if (isNaN(ep) || ep < 1 || ep > TOTAL_EPISODES) {
        resultCard.classList.add('hidden');
        if (selectedEp && cells[selectedEp]) cells[selectedEp].classList.remove('selected');
        selectedEp = null;
        return;
    }

    // Update selected cell
    if (selectedEp && cells[selectedEp]) cells[selectedEp].classList.remove('selected');
    selectedEp = ep;
    cells[ep].classList.add('selected');

    // Current episode
    resultCurrent.innerHTML = `EP ${ep} ${makeTag(episodes[ep])}`;

    // Next episode
    if (ep < TOTAL_EPISODES) {
        const next = ep + 1;
        resultNext.innerHTML = `next: EP ${next} ${makeTag(episodes[next])}`;
        resultNext.dataset.ep = next;
        resultNext.style.display = '';
    } else {
        resultNext.style.display = 'none';
    }

    // Skip to next non-filler (only show if current or next is filler)
    const isFiller = episodes[ep] === FILLER;
    const nextIsFiller = ep < TOTAL_EPISODES && episodes[ep + 1] === FILLER;
    if (isFiller || nextIsFiller) {
        const skipTo = nextNonFiller(isFiller ? ep : ep + 1);
        if (skipTo) {
            resultSkip.innerHTML = `skip to: EP ${skipTo} ${makeTag(episodes[skipTo])}`;
            resultSkip.dataset.ep = skipTo;
            resultSkip.style.display = '';
        } else {
            resultSkip.style.display = 'none';
        }
    } else {
        resultSkip.style.display = 'none';
    }

    resultCard.classList.remove('hidden');

    // Scroll grid to show selected cell
    cells[ep].scrollIntoView({ behavior: 'smooth', block: 'center' });
}

// Input handler
epInput.addEventListener('input', () => selectEpisode(epInput.value));
```

**Step 2: Verify in browser**

- Type "54" in input → should show "EP 54 FILLER", next EP 55 FILLER, skip to EP 61 MIXED
- Type "1" → EP 1 CANON, next EP 2 CANON, no skip shown
- Type "45" → EP 45 MIXED, next EP 46 MIXED, no skip (not filler)
- Grid scrolls to highlighted cell

**Step 3: Commit**

```bash
git add index.html
git commit -m "Add search panel logic with episode info and skip-to"
```

---

### Task 7: Bidirectional linking (JS)

**Files:**
- Modify: `~/repos/grand-line/index.html` (add to `<script>`)

**Step 1: Add grid click handler and result tap handlers**

Add to the script block:

```js
// Grid cell click → update search panel
grid.addEventListener('click', (e) => {
    const cell = e.target.closest('.cell');
    if (!cell) return;
    const ep = parseInt(cell.dataset.ep);
    epInput.value = ep;
    selectEpisode(ep);
});

// Result next/skip click → navigate to that episode
resultNext.addEventListener('click', () => {
    const ep = resultNext.dataset.ep;
    if (ep) { epInput.value = ep; selectEpisode(ep); }
});

resultSkip.addEventListener('click', () => {
    const ep = resultSkip.dataset.ep;
    if (ep) { epInput.value = ep; selectEpisode(ep); }
});
```

**Step 2: Verify in browser**

- Tap a grid cell → input updates, result card shows info, cell highlighted
- Tap "next: EP X" → jumps to that episode
- Tap "skip to: EP X" → jumps to next non-filler
- Input → grid scrolls and highlights

**Step 3: Commit**

```bash
git add index.html
git commit -m "Add bidirectional linking between panels"
```

---

### Task 8: Desktop responsive + polish

**Files:**
- Modify: `~/repos/grand-line/index.html` (CSS)

**Step 1: Add desktop media query and polish**

Add inside `<style>`:

```css
/* --- Desktop --- */
@media (min-width: 768px) {
    body {
        display: flex;
        justify-content: center;
        align-items: center;
    }

    #app {
        max-width: 480px;
        height: 100vh;
        border-left: 1px solid rgba(255,255,255,0.05);
        border-right: 1px solid rgba(255,255,255,0.05);
    }
}
```

**Step 2: Verify on desktop**

Content should be centered in a max-480px column.

**Step 3: Commit**

```bash
git add index.html
git commit -m "Add desktop responsive layout"
```

---

### Task 9: Create GitHub repo and deploy

**Step 1: Create GitHub repo**

```bash
cd ~/repos/grand-line
gh repo create Polp0/grand-line --public --source=. --push
```

**Step 2: Deploy to Cloudflare Pages**

```bash
export PATH="$HOME/.nvm/versions/node/v24.11.1/bin:$PATH"
npx wrangler pages deploy . --project-name=grand-line --branch=main --commit-dirty=true
```

**Step 3: Configure custom domain**

In Cloudflare Dashboard:
1. Go to Pages → grand-line → Custom domains
2. Add `filler.polpo.tech`
3. Cloudflare will auto-add the DNS record

**Step 4: Verify**

Open https://filler.polpo.tech — should load the full filler guide.

**Step 5: Commit any final changes and push**

```bash
git push
```
