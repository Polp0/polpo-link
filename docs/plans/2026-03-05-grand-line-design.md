# grand-line — One Piece Filler Guide

**URL**: filler.polpo.tech
**Repo**: grand-line
**Stack**: HTML/CSS/JS statico, Cloudflare Pages

## Cosa

Pagina mobile-first per navigare gli episodi di One Piece per tipo (canon, filler, mixed, anime canon). Due pannelli collegati bidirezionalmente.

## Pannello superiore (fisso, ~40vh)

- **Input numerico grande** — campo prominente per digitare il numero episodio
- **Card risultato**:
  - Episodio corrente: numero + tipo con colore (es. "EP 45 — MIXED")
  - Prossimo episodio: numero + tipo
  - Prossimo episodio non-filler: "Skip to EP X (CANON)" — mostrato se corrente o prossimo è filler
- Tap su "prossimo" aggiorna entrambi i pannelli

## Pannello inferiore (scrollabile, ~60vh)

- **Heatmap grid** di 1155 celle colorate
- ~28px per cella, ~12 per riga su mobile
- Numeri visibili dentro le celle (font 9-10px)
- Episodio selezionato evidenziato con ring bianco
- Interazioni:
  - Tap cella → aggiorna pannello superiore
  - Input sopra → griglia scrolla all'episodio

## Colori

| Tipo | Colore | Hex |
|------|--------|-----|
| Manga Canon | Verde acqua | #2d6a4f |
| Filler | Rosso | #c1121f |
| Mixed Canon/Filler | Ambra/giallo | #e9c46a |
| Anime Canon | Azzurro | #219ebc |

- Sfondo: navy scuro (#0a1628)
- Accent titoli: giallo straw hat (#f4d35e)
- Testo: bianco

## Tipografia

- system-ui, -apple-system, BlinkMacSystemFont, sans-serif
- "ONE PIECE" bold, "filler guide" sottile

## Dati episodi

Hardcodati in JS come array di range `{start, end, type}`:

- Manga Canon: 1-44, 48-49, 52-53, 62-67, 70-92, 94-97, 100, 103-130, 144-195, 207-212, 217-219, 227-278, 284-290, 293-302, 304-316, 320-325, 337-353, 355-381, 385-405, 408-417, 422-425, 430-452, 459-488, 490-491, 493-496, 500-505, 507-519, 521-541, 543-573, 579-589, 591-624, 629-632, 634-652, 654-656, 658-678, 680-689, 691-730, 732-736, 739-746, 752-774, 776, 779, 783-788, 790-802, 804-806, 808-877, 880, 886, 891-894, 897-906, 908-923, 925-987, 990, 992-1028, 1031-1083, 1085-1155
- Mixed Canon/Filler: 45-47, 61, 68-69, 101, 226, 354, 421, 489, 520, 574, 625, 628, 633, 653, 657, 679, 690, 731, 738, 751, 777-778, 789, 803, 807, 878-879, 881-885, 887-890, 924, 988-989, 991
- Filler: 54-60, 98-99, 102, 131-143, 196-206, 220-225, 279-283, 291-292, 303, 317-319, 326-336, 382-384, 406-407, 426-429, 457-458, 492, 542, 575-578, 590, 626-627, 747-750, 780-782, 895-896, 907, 1029-1030
- Anime Canon: 50-51, 93, 213-216, 418-420, 453-456, 497-499, 506, 737, 775, 1084

Al load: genera array[1155] per lookup O(1) per numero episodio.

## Performance

1155 celle DOM — nessuna virtualizzazione necessaria. Rendering immediato.

## Deploy

1. Nuovo repo GitHub: `grand-line`
2. Nuovo progetto Cloudflare Pages: `grand-line`
3. CNAME in Cloudflare DNS: `filler` → progetto Pages
4. Deploy: `npx wrangler pages deploy . --project-name=grand-line --branch=main --commit-dirty=true`
5. Richiede nvm per Node v20+

## Animazioni

Minimal: solo transizione colore sulla card risultato quando cambia episodio.

## Stile comunicazione

Etichette secche, funzionali. Nessun testo promozionale. Coerente con il tone of voice di polpo.tech.
