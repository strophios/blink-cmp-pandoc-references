# blink-cmp-pandoc-references

Based on https://github.com/jc-doyle/cmp-pandoc-references and more recently the fork by jmbuhr. A source for [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) or [blink.cmp](https://github.com/saghen/blink.cmp). Provides completion for bibliography, reference and cross-ref items.

This fork is primarily intended for personal use, aiming to get it working with my own Neovim configuration (which it is not at the time of the fork). It thus has three goals: 

- Rewrite to just a blink-cmp source as a way of making sure I understand how blink-cmp sources work and eliminate one potential source of complexity. (Hence the name change.) 
- Relatedly, identify and remove a number of bugs in how it currently works in my configuration.
- Update to work with CSL-JSON files rather than `.bib` files, matching my (at the moment personal) update of [telescope-zotero](http://github.com/strophios/telescope-zotero.nvim) to do the same. 

A brief note on this shift: in essence, this is about making working with [Better BibtTeX](https://retorque.re/zotero-better-bibtex/) easier, given that they now recommend [using CSL instead of bibtex when working with pandoc](https://retorque.re/zotero-better-bibtex/exporting/pandoc/index.html#use-csl-not-bibtex-with-pandoc). 

## Demo

![cmp-pandoc-references](https://user-images.githubusercontent.com/59124867/134782887-33872ae0-a23e-4f5b-99cd-74c3b0e6f497.gif)

## Installation

Install with your favorite package manager from:

```lua
"strophios/blink-cmp-pandoc-references"
```

## nvim-cmp

I have currently removed nvim-cmp support from this fork. That said, if my updates ever graduate to being anything but purely personal use, I suspect I'd want to add it back. 

## blink.cmp

```lua
-- ...
    references = {
        name = "pandoc_references",
        module = "blink-cmp-pandoc-references",
    },
-- ...
```

## Explanation & Limitations

This source parses and validates the `bibliography: <your/bib/location.json>` YAML metadata field, to determine the destination of the file (see [Pandoc](https://pandoc.org/MANUAL.html#specifying-bibliographic-data)). If it is not included (or you specify it through a command-line argument), no bibliography completion items will be found. Also, note that this fork assumes a CSL-JSON file rather than a `.bib` file for the bibliography. 

