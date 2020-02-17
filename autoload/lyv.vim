
let g:lyv_fileoutput = get(g:, "lyv_fileoutput", expand("$XDG_CONFIG_HOME/anki_decks/nvim_shortcuts.anki_deck"))

let s:anki_note_tag = "ANKI:"
let s:anki_divider = ","

function! lyv#test() abort
  let keymap = nvim_get_keymap('n')

  let anki_lines = []
  for mapping_dict in keymap
    let script_file = scriptease#scriptname(mapping_dict.sid)
    let line_number = mapping_dict.lnum

    let result = systemlist(printf("sed '%sq;d' %s", line_number - 1, script_file))

    if len(result) == 0
      continue
    endif

    let value = result[0]

    if match(value, s:anki_note_tag) >= 0
      " echo "============="
      " echo value
      " echo mapping_dict

      call add(anki_lines, {"anki_note": value, "keymap": mapping_dict})
    endif
  endfor

  return anki_lines
endfunction

function! lyv#export(anki_commands) abort
  let command_values = []
  for command_object in a:anki_commands
    let formatted_lhs = command_object.keymap.lhs
    let formatted_lhs = substitute(formatted_lhs, " ", '\&lt;space\&gt;', "g")
    let formatted_lhs = substitute(formatted_lhs, g:mapleader, '\&lt;leade\&gt;', "g")

    call add(
          \ command_values,
          \ trim(
            \ printf('"%s"%s"%s"%s%s',
              \ trim(substitute(command_object.anki_note, '" ' . s:anki_note_tag, "", "")),
              \ s:anki_divider,
              \ formatted_lhs,
              \ s:anki_divider,
              \ s:anki_divider,
              \ )
            \ ))
  endfor

  " Add in built-in files
  call extend(command_values, lyv#read_builtin_vim_commands())

  call writefile(command_values, g:lyv_fileoutput, "")

  return command_values
endfunction

function! s:change_quote_to_double_quote(input_string) abort
  return substitute(a:input_string, '"', '""', "g")
endfunction

function! s:convert_json_to_anki(card) abort
  return printf(
        \ '"%s"%s"%s"%s"%s"%s',
          \ s:change_quote_to_double_quote(a:card.question),
          \ s:anki_divider,
          \ s:change_quote_to_double_quote(a:card.answer),
          \ s:anki_divider,
          \ join(a:card.tags, ","),
          \ s:anki_divider
          \ )
endfunction


function! lyv#read_builtin_vim_commands() abort
  let vim_builtin_json_file = fnamemodify(expand("<sfile>"), ":p:h") . "/resources/vim_builtins.json"
  let vim_builtin_cards = json_decode(readfile(vim_builtin_json_file))

  let anki_cards = []
  for json_card in vim_builtin_cards
    call add(anki_cards, s:convert_json_to_anki(json_card))
  endfor

  return anki_cards
endfunction

" Time echo lyv#test()

" {
" 'lnum': 62,
" 'expr': 0,
" 'noremap': 0,
" 'lhs': '<C-A>',
" 'mode': 'n',
" 'nowait': 0,
" 'silent': 0,
" 'sid': 202,
" 'rhs': '<Plug>SpeedDatingUp',
" 'buffer': 0
" }
