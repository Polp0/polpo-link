# polpo-link

Sito statico HTML/CSS, dominio polpo.tech, hosted Cloudflare Pages.

> Default: branch "Muoviti libero" del global CLAUDE.md. Nessun DB/auth/migration qui.

## Deploy

```bash
export PATH="$HOME/.nvm/versions/node/v24.11.1/bin:$PATH"
npx wrangler pages deploy . --project-name=polpo-link --branch=main --commit-dirty=true
```

Branch `main`, NON `production`. Richiede Node v20+.

## Workflow CSS

Dopo ogni modifica `styles.css`, bumpa `?v=N` nel link tag in `index.html`.

## Regola design

Tiles (con thumbnail) = contenuti specifici (set, evento singolo). Link generali (Instagram, SoundCloud, Telegram) = icone, NON tiles.

## Tono polpo (per copy sul sito)

Essenziale, impersonale, non vende. NO imperativi ("ascolta", "seguimi", "check out"), NO descrizioni. Etichette secche: "sets / links" non "Listen to my sets".
