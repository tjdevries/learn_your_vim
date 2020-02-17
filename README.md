# LearnYourVim

To vim is to LYV.

Learn Your Vim helps you make an Anki deck from:

- Your personal mappings
- Mappings you want to remember
- Built-in Shortcuts


## Personal Mappings

```vim
" For vim code, simply prepend a mapping line w/ " ANKI: <description>

" ANKI: Open fuzzy finder window for project files
nnoremap <space><space> <cmd>FzfPreviewProjectFiles<CR>
```

After running `<insert command here>`, you'll have an Anki card that looks like:

```
Open fuzzy finder window for project files; <space><space>;
```


## TODO:

- Add tags support
- Options to:
    - Show code
    - Show mode
