# Family invitations

Each of the app's 100 families has a real static page in `family/<number>/index.html`
and a 1200 × 630 PNG in `images/families/`. GitHub Pages serves these directories
at `/family/42/` (and redirects `/family/42` to that path). The app accepts both.
The shared URL remains `https://wordnice.app/family/42`.

Open Graph and Twitter metadata is in the initial HTML. A preview fetcher does
not need to run JavaScript or interpret a 404 page. Each card carries its family
number and uses the existing otter, rounded lettering, and app palette. It does
not reveal the puzzle's words or thank-you sentence.

To change the copy or page layout, edit `tools/build-family-pages.py`, then run:

```sh
python3 tools/build-family-pages.py
```

To change the artwork, edit `tools/render-family-cards.swift`, then run on macOS
from the site root (requires Xcode command-line tools, pngquant, and oxipng):

```sh
swift tools/render-family-cards.swift
sh tools/optimize-family-cards.sh
```

The optimizer uses `pngquant 24` with default dithering, followed by
`oxipng --opt max` (lossless compression). The cards stay at 1200 × 630;
optimized PNGs are approximately 35 kB each. Always regenerate full-color
originals before optimizing again to avoid repeated palette reduction.

Zopfli is intentionally omitted: on Family 1 it saved only 859 bytes (2.5%)
while taking roughly 15× longer than `--opt max`.

Commit the generated HTML and PNGs along with the generators; the hosting build
has no added runtime requirements. When adding families, update the ranges in
both generators to match `WordNicePuzzleCatalog` in the app.

The app shares a URL object without accompanying message text, letting receiving
apps render it as a link. The web metadata supplies the invitation. Each recipient
app decides whether to show the image, title, description, or a compact preview.

## Publishing and checking

Publish this repository through its existing GitHub Pages deployment. Then check
`https://wordnice.app/family/42` follows to a **200** response and that its HTML
contains the family-specific `og:title`, `og:image`, and `og:url`. Check that the
image URL returns **200** with `image/png`.

Share Family 42 from the updated app into a new Messages draft and inspect the
preview without sending. Also test a copied link and a family that has not been
shared before. Existing message previews can remain cached after a deployment;
a successful website update does not refresh old message bubbles. If replacing
an already-published image, change the image filename in both generators so
fetchers see a new asset URL.

The website still says “Coming soon,” matching the home page. At launch, update
the generated page template's availability copy and CTA to the real App Store
listing, then regenerate. The universal-link association file is unchanged.
