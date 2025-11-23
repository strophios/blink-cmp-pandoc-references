# blink-cmp-pandoc-references

Based on https://github.com/jc-doyle/cmp-pandoc-references and more recently the [fork by jmbuhr](https://github.com/jmbuhr/cmp-pandoc-references). Provides completion for bibliography, reference and cross-ref items as a source for [blink.cmp](https://github.com/saghen/blink.cmp). The main point of the fork is to switch to using CSL-JSON rather than BibTeX for autocomplete of citations (see below for a brief discussion of why). In order to simplify the change, I have dropped functionality as a [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) source and dropped supported filetypes to only quarto or other species of markdown with a YAML header specified bibliography file. Should this fork develop beyond just being for personal use, adding functionality and support back would likely be at the top of the list of updates. 

## Why do this at all?

This fork is primarily intended for personal use, aiming to get it working with my own Neovim configuration (which it is not at the time of the fork). It thus has three goals: 

- Rewrite to just a blink-cmp source as a way of making sure I understand how blink-cmp sources work and eliminate one potential source of complexity. (Hence the name change.) 
- Relatedly, identify and remove a number of bugs in how it currently works in my configuration.
- Update to work with CSL-JSON files rather than `.bib` files, matching my (at the moment personal) update of [telescope-zotero](http://github.com/strophios/telescope-zotero.nvim) to do the same. 

## Why switch to CSL-JSON?

The short answer is that this is about making interfacing with [Better BibtTeX](https://retorque.re/zotero-better-bibtex/) easier, given that they now recommend [using CSL instead of bibtex when working with pandoc](https://retorque.re/zotero-better-bibtex/exporting/pandoc/index.html#use-csl-not-bibtex-with-pandoc). 

The slightly longer answer (which I suspect is also part of the reason that Better BibTeX recommends CSL in general) is that switching to CSL has *dramatically* simplified the parsing process compared to working with BibTex, while also making it more robust. 

## Demo

![cmp-pandoc-references](https://user-images.githubusercontent.com/59124867/134782887-33872ae0-a23e-4f5b-99cd-74c3b0e6f497.gif)

## Installation

Install with your favorite package manager from:

```lua
"strophios/blink-cmp-pandoc-references"
```

## blink.cmp

```lua
-- ...
    references = {
        name = "pandoc_references",
        module = "blink-cmp-pandoc-references",
    },
-- ...
```

## nvim-cmp

As said above, I have currently removed nvim-cmp support from this fork. That said, if my updates ever graduate to being anything but purely personal use, I suspect I'd want to add it back. 

## Explanation & Limitations

This source parses and validates the `bibliography: <your/bib/location.json>` YAML metadata field, to determine the destination of the file (see [Pandoc](https://pandoc.org/MANUAL.html#specifying-bibliographic-data)). If it is not included (or you specify it through a command-line argument), no bibliography completion items will be found. Also, note that this fork assumes a CSL-JSON file rather than a `.bib` file for the bibliography. 

