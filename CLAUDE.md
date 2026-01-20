# polpo-link

Landing page personale stile Linktree per polpo.

**Dominio**: https://polpo.tech/

## Stack

- HTML/CSS statico (no framework)
- Hosting: Cloudflare Pages
- Repo GitHub: github.com/Polp0/polpo-link
- **Deploy: manuale con wrangler** (vedi sezione Deploy)

## Dev locale

```bash
npx serve
```

Apri http://localhost:3000

## Deploy

```bash
export PATH="$HOME/.nvm/versions/node/v24.11.1/bin:$PATH"
npx wrangler pages deploy . --project-name=polpo-link --branch=production --commit-dirty=true
```

Richiede Node v20+. Il comando deploya direttamente su https://polpo.tech/

## Struttura

```
index.html      - pagina principale
styles.css      - stili
img/
  hero-img.jpg  - foto profilo (avatar)
  icons/        - icone SVG (instagram, soundcloud, telegram, youtube)
```

## Sezioni pagina

1. **Profilo** - avatar piccolo (96px) + nome + icone social (Instagram, SoundCloud)
2. **Tiles** - contenuti specifici con thumbnail (TEMPIO RADIO, Home Mixes)
3. **Collective kntk** - icone piccole (Instagram, SoundCloud, Telegram)

**Nota**: I link generali (Instagram, SoundCloud) sono icone, NON tiles. Le tiles sono solo per contenuti specifici.

## SEO

- Meta tags (description, keywords, author)
- Open Graph (Facebook, WhatsApp)
- Twitter Cards
- Schema.org JSON-LD (Person)
- Canonical URL: https://polpo.tech/
