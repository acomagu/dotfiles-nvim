hi clear
syntax reset
let g:colors_name = 'minicomment'

if &background == "light"
  let g:terminal_color_0  = '#000000'   " black
  let g:terminal_color_1  = '#c62828'   " red
  let g:terminal_color_2  = '#008000'   " green
  let g:terminal_color_3  = '#b57300'   " yellow
  let g:terminal_color_4  = '#0066cc'   " blue
  let g:terminal_color_5  = '#8030a0'   " magenta
  let g:terminal_color_6  = '#00c8c8'   " cyan
  let g:terminal_color_7  = '#ffffff'   " white
  let g:terminal_color_8  = '#666666'   " gray
  let g:terminal_color_9  = '#e60026'   " bright red
  let g:terminal_color_10 = '#009900'   " bright green
  let g:terminal_color_11 = '#aa7700'   " bright yellow / orange
  let g:terminal_color_12 = '#007fff'   " bright blue
  let g:terminal_color_13 = '#c7008a'   " bright magenta
  let g:terminal_color_14 = '#009999'   " bright cyan
  let g:terminal_color_15 = '#ffffff'   " bright white
  let g:terminal_color_background = g:terminal_color_7
  let g:terminal_color_foreground = g:terminal_color_0
else
  " Base: Da One Black
  let g:terminal_color_0 =  "#000000"   " black
  let g:terminal_color_1 =  "#fa7883"   " red
  let g:terminal_color_2 =  "#98c379"   " green
  let g:terminal_color_3 =  "#ff9470"   " yellow
  let g:terminal_color_4 =  "#6bb8ff"   " blue
  let g:terminal_color_5 =  "#e799ff"   " magenta
  let g:terminal_color_6 =  "#8af5ff"   " cyan
  let g:terminal_color_7 =  "#ffffff"   " white
  let g:terminal_color_8 =  "#888888"   " gray
  let g:terminal_color_9 =  "#fa7883"   " bright red
  let g:terminal_color_10 = "#98c379"   " bright green
  let g:terminal_color_11 = "#ff9470"   " bright yellow / orange
  let g:terminal_color_12 = "#6bb8ff"   " bright blue
  let g:terminal_color_13 = "#e799ff"   " bright magenta
  let g:terminal_color_14 = "#8af5ff"   " bright cyan
  let g:terminal_color_15 = "#ffffff"   " bright white
  let g:terminal_color_background = g:terminal_color_0
  let g:terminal_color_foreground = g:terminal_color_15
endif

exec 'hi! NormalFloat guibg=' . g:terminal_color_8
exec 'hi! Normal      guifg=' . g:terminal_color_foreground . ' guibg=None'
exec 'hi! Comment     guifg=' . g:terminal_color_8
exec 'hi! String      guifg=' . g:terminal_color_10

" :h group-name
hi! link Constant        Normal
hi! link Character       Normal
hi! link Number          Normal
hi! link Boolean         Normal
" hi! link Float           Normal
hi! link Identifier      Normal
hi! link Function        Normal
hi! link Statement       Normal
hi! link Conditional     Normal
hi! link Repeat          Normal
hi! link Label           Normal
hi! link Operator        Normal
hi! link Keyword         Normal
hi! link Exception       Normal
hi! link PreProc         Normal
hi! link Include         Normal
hi! link Define          Normal
hi! link Macro           Normal
hi! link PreCondit       Normal
hi! link Type            Normal
hi! link StorageClass    Normal
hi! link Structure       Normal
hi! link Typedef         Normal
hi! link Special         Normal
hi! link SpecialChar     Normal
hi! link Tag             Normal
hi! link Delimiter       Normal
hi! link SpecialComment  Normal
hi! link Debug           Normal
hi! link Underlined      Normal
hi! link Ignore          Normal
" hi! link Error           Normal
hi! link Todo            Normal
" hi! link Added           Normal
" hi! link Changed         Normal
" hi! link Removed         Normal
