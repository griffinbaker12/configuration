# nvim-minimal cheat sheet

Leader is Space. Backtick is the tmux prefix, so this sheet uses the `'` forms.

## Which tool for which job

| I want to...                                   | Use                                                         |
|------------------------------------------------|-------------------------------------------------------------|
| open a file by (part of) its name              | `<leader>pf` and type `ai-api/ integration.py$`             |
| search text inside files, browse as I type     | `<leader>ls` (live grep)                                    |
| search text, but only in certain files         | `<leader>ps` (multigrep): `pattern  glob  !glob`            |
| search text, keep the results as a list        | `<leader>rg` → `:silent grep! pattern -g glob` → quickfix   |
| search the word under the cursor               | `<leader>fc` (Telescope), or `<leader>rg` then `<C-r><C-w>` |
| reopen a recent file                           | `<leader>fr`                                                |
| browse / rename / move files                   | `-` (oil)                                                   |

Search inside files = grep (`ls`, `ps`, `rg`, `fc`). Search file names = `pf`.

## The three pattern languages (and the minimum of each)

| Where                         | Language | All you usually need                                         |
|-------------------------------|----------|--------------------------------------------------------------|
| Telescope prompts             | fuzzy    | plain words separated by spaces. Junk showing up? `'exact`, `!exclude`, `ends$` |
| `-g` in rg / multigrep        | globs    | `*.py` by extension · `!**/tests/**` skip a folder · `**/ai-api/**` only inside a folder |
| `<leader>rg`, `/`, `:s`, `:Cfilter` | regex | plain words. `-w` whole words; `-F 'foo(bar.baz)'` makes symbols literal |

In fuzzy, `.` is a real dot; in regex it means any character (that's what `-F` turns off).

## rg / globs (`<leader>rg`, multigrep)

- `-w` whole words only: `-w tldr` skips `patient_tldr` (but `-` and `.` are word breaks, so `patient-tldr` still matches)
- `-g '*.py'` only .py files, any depth. A glob with a `/` is anchored at nvim's cwd: `apps/**` ≠ `**/apps/**`
- Several `-g` = **OR** (a file matching any of them). Need both? Put them in one glob: `**/ai-api/**/*integration.py`
- `-g '!**/tests/**'` excludes, on top of whatever else
- `-A1` also show 1 line after each match; `-i` ignore case (default is smart-case)
- Or give a folder: `:silent grep! pattern apps/main/ai-api`
- Multigrep: two spaces separate pieces. Don't start with two spaces (that searches for "" and matches every line)

## Telescope prompt

| Keys                    | Does                                               |
|-------------------------|----------------------------------------------------|
| `<C-n>` / `<C-p>`       | move down / up the results                         |
| `<C-/>`                 | show every key the picker has                      |
| `<CR>`                  | open                                               |
| `<C-v>` / `<C-x>` / `<C-t>` | open in vsplit / hsplit / tab                  |
| `<Tab>` / `<S-Tab>`     | select an item (multi-select)                      |
| `<C-q>`                 | send **all** results to quickfix                   |
| `<M-q>`                 | send only the **<Tab>-selected** ones to quickfix  |
| `<C-u>`                 | clear the prompt                                   |
| `<C-w>`                 | delete a word in the prompt                        |
| `<C-b>` / `<C-f>`       | scroll the preview up / down (`<C-d>` also down)   |
| `<C-r><C-w>`            | type the word that was under your cursor           |
| `<Esc>`                 | normal mode in the prompt (`j`/`k` move, `<Esc>` again closes) |

Fuzzy (fzf) operators, space = AND in any order:
`'exact`  `^starts`  `ends$`  `!exclude`  `a | b` (OR).
Example: `ai-api/ integration.py$ !legacy`

## Quickfix

| Keys / command           | Does                                                      |
|--------------------------|-----------------------------------------------------------|
| `]q` / `[q`              | next / previous item (works with the list closed)         |
| `<leader>qo` / `<leader>qc` | open / close the list                                  |
| `<CR>` (in the list)     | jump to the item                                          |
| `<C-w><CR>` (in the list)| open it in a horizontal split                             |
| `dd` (in the list)       | remove that item (qfedit)                                 |
| `:Cfilter pat`           | keep items whose file name or text matches                |
| `:Cfilter! pat`          | drop them                                                 |
| `:colder` / `:cnewer`    | back to the previous list / forward again                 |
| `:chistory`              | list the saved lists                                      |
| `:Telescope quickfix`    | fuzzy-filter the list, then `<C-q>` to make it the new list |
| `:cdo s/old/new/ \| update` | run a command on every item                            |
| `:cfdo %s/old/new/ \| update` | run it once per file                                 |

Example (in ~/prompt-ai):
```
<leader>rg tldr<CR>          258 hits: also patient_tldr, patient_tldr_utils, ...
<leader>rg -w tldr<CR>        71 hits: just the word tldr
:Cfilter! modeling            33: drop the modeling/ notebooks and scripts
:Cfilter! test                30: drop tests
:Cfilter \.py$                22: only .py files (not yml)
:colder 3                     back to the 71
```

## LSP and diagnostics

| Keys           | Does                                                       |
|----------------|------------------------------------------------------------|
| `gd`           | definition (where it's declared; for an interface method, the interface) |
| `gi`           | implementations (the concrete code; not supported in Python) |
| `gR` / `grr`   | references (Telescope / quickfix)                          |
| `gt`           | type definition                                            |
| `gD`           | declaration                                                |
| `K`            | hover docs (press again to close)                          |
| `<M-i>` (insert) | signature help                                           |
| `<leader>rn` / `grn` | rename across the project                            |
| `<leader>ca`   | code actions                                               |
| `[d` / `]d`    | previous / next diagnostic                                 |
| `<leader>ld`   | diagnostic on this line                                    |
| `<leader>bd`   | this buffer's diagnostics (Telescope)                      |
| `:Telescope diagnostics` | every open buffer's diagnostics                  |
| `:lua vim.diagnostic.setqflist()` | diagnostics into quickfix               |

## Moving around

### Jumps (`<C-o>` back, `<C-i>` forward, `:jumps` lists)
Counts as a jump: `gg` `G` `:42` `/search` `n` `N` `*` `%` `{` `}` `'a` `''` `gd` and other LSP jumps, opening a file, `]q`.
Not a jump: `j` `k` `12j` `w` `b` `f` `t` `<C-d>` `<C-u>`, your `H` / `L`.

### Marks (`:marks` lists, `:delmarks a` / `:delmarks!` clears)

| Keys           | Does                                                         |
|----------------|--------------------------------------------------------------|
| `ma` / `'a`    | set / jump to mark a (this file)                             |
| `mA` / `'A`    | capital = remembers the file too, works from anywhere        |
| `''`           | back to where you were before the last jump (again = toggle) |
| `m'`           | "remember this spot" before moving with `j`/`k`/`w`; `''` comes back |
| `'.`           | line of your last change                                     |
| `g;` / `g,`    | back / forward through your changes (`:changes` lists)       |
| `'^`           | where you last left insert mode                              |
| `'<` / `'>`    | start / end of the last visual selection (`gv` reselects)    |
| `'0`           | where you were when you last quit nvim                       |

## Registers (`:reg` lists, `:Telescope registers`)

| Keys            | Does                                                    |
|-----------------|---------------------------------------------------------|
| `"ayiw` / `"ap` | yank into / paste from register a                       |
| `"Ayy`          | append to register a                                    |
| `"0p`           | paste your last yank (deletes and `c` don't touch it)   |
| `ci)<C-r>0`     | replace the inside of ( ) with what you last yanked; `.` repeats |
| `<C-r>a`        | (insert or `:` line) type out register a                |
| `<C-r>=`        | (insert) math: `<C-r>=60*60*24<CR>` → 86400             |
| `<C-r><C-w>`    | (`:` line) word under the cursor                        |
| `<C-r>/`        | (`:` line) your last search: `:%s/<C-r>//new/g`         |
| `@:`            | run the last `:` command again                          |
| `<leader>y`     | yank to the system clipboard                            |
| `<leader>d`     | delete without overwriting any register                 |
| `<leader>yp`    | copy `path/to/file.py:42`                               |

## Windows, files, git

| Keys                    | Does                                            |
|-------------------------|-------------------------------------------------|
| `<M-h/j/k/l>`           | move between splits (and tmux panes)            |
| `<leader>sv` / `<leader>sh` | vertical / horizontal split                 |
| `<leader>sx`            | close split                                     |
| `<leader>mm`            | maximize / restore the split                    |
| `-`                     | oil (parent folder); in oil `<M-v>` vsplit, `<M-d>` split, `<leader>cd` cd here |
| `<leader>gs`            | git status (fugitive)                           |
| `<leader>gd`            | diff this file vs git                           |
| `:Font`                 | switch kitty font                               |
| `:Theme`                | switch theme variant (sonokai 256-color / true color); remembered across restarts |
