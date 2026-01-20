# polpo-link

Landing page personale stile Linktree per polpo.

**Dominio**: https://polpo.tech/

## Stack

- HTML/CSS statico (no framework)
- Hosting: Cloudflare Pages
- Repo GitHub: github.com/Polp0/polpo-link
- **Deploy: AUTOMATICO su push a branch main** (Cloudflare Pages collegato a GitHub)

## Dev locale

```bash
npx serve
```

Apri http://localhost:3000

## Deploy

**BASTA PUSHARE SU GITHUB:**
```bash
git add . && git commit -m "message" && git push
```

Cloudflare Pages è collegato al repo GitHub (branch main).
Ogni push triggera automaticamente il deploy su https://polpo.tech/

NON serve wrangler, NON serve login Cloudflare, NON serve nient'altro.

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
