# choose_ltf multi-select page - UI design

The visual + interaction design for the new "choose up to 5 LTFs" group-practice
page in creator. This is the front-end counterpart to the cross-repo data design
in `multi-ltf-group-practice.md` (which calls the multi-LTF umbrella a "cluster").

A clickable mock-up of everything below was built and approved before writing
this doc.

> **Count:** a practice offers **1-5** LTFs (`MAX = 5`), matching the cross-repo
> plan in `multi-ltf-group-practice.md`.

## Behaviour change

- **Old:** the instructor picks **one** LTF, clicks `next`, and a single group id
  is created.
- **New:** the instructor picks **up to 5** LTFs, clicks `next`, and the umbrella
  id is created. When anyone later joins with that id they choose **one** of those
  LTFs.
- Fewer than 5 is common and fully valid - an instructor will often offer 1, 2 or
  3. There is therefore **no "you must pick 5"** prompt and **no greying / blocking
  when fewer than 5 are chosen**. `next` only requires **>= 1**.

## Audience / scope constraint

- cyber-dojo is **laptop only**. Mobile / touch is explicitly out of scope, so
  hover-driven behaviour (preview on hover) is acceptable.

## Layout

```
+-----------------------------------------------------------------------+
|  create a new practice                                                |
|  choose up to 5 language & test-frameworks                            |
|                                                                       |
|  +-------------------+      [ next ]   * On next the group is created  |
|  | chosen row 1      |                   with the chosen list; each    |
|  | chosen row 2      |                   joiner then picks one of them. |
|  | 3                 |                 * I'd like to help maintain the   |
|  | 4                 |                   language & test-frameworks      |
|  | 5                 |                                                  |
|  +-------------------+                                                 |
|         (up/down double-headed arrow, centered under the list column)  |
|  +-------------------+   +------------------------------------------+  |
|  | available row     |   |  preview pane (white, monospace)         |  |
|  | available row     |s  |  shows the hovered LTF's starting file   |s |
|  | available row     |c  |                                          |c |
|  | ...               |b  |                                          |b |
|  +-------------------+   +------------------------------------------+  |
|                                                                       |
+-----------------------------------------------------------------------+
   "s c b" = the custom always-on scrollbar on each scrollable area
```

- Overall split width **805px**; left "list" column **300px**, right column **500px**
  (matches the existing `#choose-ltf-page .edged-panel { width:835px }` and the
  existing 300/500 `display-names`/`display-content` split).
- **Top-left:** the chosen list - up to 5 rows. Filled rows use the exact existing
  `.display-name` row style. Remaining slots are faint dashed placeholders labelled
  with just their number (`1`..`5`).
- **Top-right (beside the chosen rows):** the `next` button, and to its right a
  two-item bulleted help list (same `#f6f0b9` colour, Trebuchet 13px):
  1. "On `next` the group is created with the chosen list; each joiner then picks
     one of them."
  2. "I'd like to help maintain the language & test-frameworks" - where **"I'd like
     to help"** links to
     `https://github.com/cyber-dojo/cyber-dojo/blob/master/docs/how-to-contribute-to-start-points.md`
     (target `_blank`). This is the existing help link, relocated.
- **Between the two lists:** a vertical **double-headed arrow** centered under the
  300px column, signalling rows move in either direction.
- **Bottom-left:** the available list (the full LTF catalogue, never consumed),
  scrollable.
- **Bottom-right:** the preview pane (white) showing the starting file of whichever
  row is hovered, in either list.

There is **no** "(0/5)" counter and **no** section headings above the lists (both
were tried and removed - the 5 numbered slots and the sub-title carry the "up to 5"
message).

## Interaction model

- **Click a row in the available list** -> a **copy** is appended to the chosen list
  (in pick order). The available row is **not** removed - the available list is a
  fixed catalogue you pick from, not a pool you empty. Blocked silently once 5 are
  chosen.
- **Duplicates are allowed.** The same LTF may be chosen more than once (e.g. 5x
  `Java, JUnit`) - useful for running several parallel groups of the same LTF. Each
  chosen entry is independent.
- **Click a row in the chosen list** -> that one entry is removed (freeing a slot).
  The available list is unaffected.
- **Hover a row in either list** -> the preview pane shows that LTF's starting file.
- **On page load** -> a random available row is "hovered" (gets the dotted
  highlight, is scrolled into view) and its file populates the preview, mirroring
  the existing page's `$displayNames.random().click()` behaviour.
- The available list is the full catalogue, sorted alphabetically (case-insensitive)
  and never mutated; the chosen list keeps pick order and may contain duplicates.

## The LTF list

- The full set of language-test-frameworks comes from the languages-start-points
  service (as today, via `data_source=` -> `manifests`).
- At time of writing that is **82 entries**, taken from
  `https://beta.cyber-dojo.org/creator/choose_ltf?type=kata`. They are display
  names like `Python, pytest` / `Ruby, MiniTest` / `C++ (g++), GoogleTest`.

## Colours and fonts (from creator `pre-built-app.css`)

| Token | Value |
| --- | --- |
| Page / panel background | `#262626` |
| Panel border | `#5a5a5a` |
| Text (khaki) | `#f6f0b9` |
| Title / button / panel font | `Impact, "Trebuchet MS", Tahoma, Arial, sans-serif` |
| Row / help-text font | `"Trebuchet MS", Tahoma, Arial, sans-serif` |
| Link colour | `khaki` |
| `next` button background | `#efe483`, border `2px solid #262626`, hover dotted `#595959`, disabled bg `#595959` |
| `next` size | `button.large` = 40px |

### Rows (`.display-name`, reused verbatim)

- text `#f6f0b9`, background `#262626`, border `1px solid #262626` (invisible until
  hover).
- hover / `preview-active`: border `1px dotted #666666`.
- `selected` (legacy single-select state): text `#262626`, background `white`.

### Chosen empty slots

- faint dashed: text `#555`, border `1px dashed #444`, content = the slot number.

### Sub-title spacing

- sub-title `margin-bottom: 28px` (extra breathing room below "choose up to 5...").

### Double-headed arrow (inline SVG, no external asset)

- `viewBox 0 0 24 48`, stroke `#f6f0b9`, round caps/joins.
- shaft `stroke-width: 6` (deliberately fat); arrowheads `stroke-width: 2.5`.
- centered in the 300px column between the chosen and available lists.

## Custom always-on scrollbars

The native scrollbar is **not** used. On this user's Chrome the macOS overlay
scrollbar faded after a few seconds even with `::-webkit-scrollbar` styling and
`overflow-y: scroll`, so both scrollable areas use a **drawn** scrollbar that
cannot fade.

Mechanism (single `wireScrollbar($scroll, $track, $thumb)` helper):

- The scrollable element keeps `overflow-y: scroll` but its native scrollbar is
  hidden (`scrollbar-width: none` + `::-webkit-scrollbar { display:none }`), so the
  mouse wheel still scrolls.
- A plain `div` track holds a `div` thumb (so it is always visible). The thumb's
  height and top are computed from `clientHeight / scrollHeight / scrollTop`.
- Wheel scrolling updates the thumb; the thumb is draggable; clicking the track
  jumps to that position. `resize` re-syncs.
- The scrollable area is narrowed by 14px (300 -> 286 list, 500 -> 486 preview) to
  leave room for the 14px scrollbar.

Geometry: track `width: 14px`, `top:6px; bottom:6px; right:0`, radius 7px; thumb
`width:14px`, `min-height:24px`, radius 7px, `border: 3px solid <bg>` (the inset
border makes it read as a pill and matches the background so it floats),
`box-sizing: border-box`.

### Available list scrollbar (floats on the dark panel)

- track `#262626` (same as page background -> invisible, "floats").
- thumb `#bdb784` (a dimmed khaki - deliberately less bright than the `#f6f0b9`
  text), hover `#d2cb96`, border `3px solid #262626`.

### Preview pane scrollbar (subtle, blends into the page)

- The preview pane is a white div (`background:#fff; color:#000`, monospace, 11px,
  `white-space:pre`, 320px tall) - it replaces the old read-only `<textarea>` so it
  can host the custom scrollbar.
- Its scrollbar track sits in the gap to the right of the white pane (over the dark
  panel), so: track `#262626` (blends into the page), thumb a subtle dark grey
  `#555555`, hover `#6e6e6e`, border `3px solid #262626`.

Colour principle used throughout: **thumb = the area's accent/text, track = its
surrounding background** (so the track disappears and only the pill shows). The
available list followed this literally (khaki on dark); the preview pane was then
deliberately tuned to a subtle grey rather than its black text, on request.

## Implementation pointers (creator)

The page is `app/views/choose_ltf.erb` + the shared `app/views/shared/display_names.erb`
partial, with JS in `app/assets/javascripts/creator.js`. To deliver this design:

- **State:** replace the single `cd.selectedDisplayName` with an ordered list
  (max `MAX`). Selection is now move-between-lists, not the legacy `.selected`
  white-row state.
- **Payload:** the selections go in the POST **body** as JSON - the page URL only
  holds `type`/`exercise_name` as navigation state, and `create.json` reads the body
  only (`app_base.rb` `json_payload` -> `JSON.parse`). For a **single** LTF the UX
  posts `type: 'group'` with the singular `language_name` (the current wire form,
  unchanged). For **2-5** it posts `type: 'cluster'` with `language_names` as a real
  JSON **array** (display names in pick order) - each name is its own element, so the
  commas inside display names are not a delimiter problem. `cd.toJSON` (creator.js)
  is a naive `k=v&k=v` splitter that cannot express an array, so the cluster case
  builds a proper object and POSTs `application/json` (e.g.
  `$.ajax({contentType:'application/json', data: JSON.stringify(payload)})`).
  `symbolized` touches only top-level keys, so the array passes through intact.
- **Server:** `create.json` dispatches on `type` (`app.rb` `create`):
  **`type: 'group'`** -> `Creator#group_create(language_name:, exercise_name:)` ->
  today's bare `Group_v2` (unchanged, so trainers' existing scripts are unaffected);
  **`type: 'cluster'`** -> `Creator#cluster_create(exercise_name:, language_names:)`
  -> `saver.cluster_create` (clusters are the saver's multi-LTF mechanism - see
  `multi-ltf-group-practice.md`). `group_create` is untouched.
- **Join side** (out of scope for this page): the joiner picks one of the
  **distinct** chosen LTFs (duplicates collapse to a single entry); which duplicate
  child is used is deferred - see `multi-ltf-group-practice.md`.
