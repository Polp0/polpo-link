# polpo-link

Landing page personale stile Linktree per polpo (DJ/producer).

## Dev

```bash
npx serve
```

Apri http://localhost:3000

## Struttura

```
index.html      - pagina principale
styles.css      - stili
img/
  hero-img.jpg  - foto profilo
  icons/        - icone SVG (instagram, soundcloud, telegram, youtube)
```

## Sezioni pagina

1. **Profilo** - avatar piccolo (96px) + nome + icone social (Instagram, SoundCloud)
2. **Tiles** - contenuti specifici (TEMPIO RADIO, Home Mixes)
3. **Collective kntk** - icone piccole (Instagram, SoundCloud, Telegram)

**Nota**: I link generali (Instagram, SoundCloud) sono icone, NON tiles. Le tiles sono solo per contenuti specifici.

## SEO

- Meta tags (description, keywords, author)
- Open Graph (Facebook, WhatsApp)
- Twitter Cards
- Schema.org JSON-LD (Person)

## Deploy

Hostato su Cloudflare Pages (vedi wrangler.toml)
