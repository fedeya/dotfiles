" Keybindings
inoremap jk <Esc>
nnoremap <Space> <Nop>

let mapleader = "\<Space>" 

nnoremap <Leader>j J
nnoremap <Leader>/ :noh<CR>

" Accept Inline Suggestion (ex. Copilot)
nnoremap <Leader>a <Cmd>call VSCodeNotify('editor.action.inlineSuggest.commit')<CR>

" Move to Line
map <Leader>l <Plug>(easymotion-bd-jk)

" Move to Word
map  <Leader>w <Plug>(easymotion-bd-w)

" Macros 
let @i = "\yef';\"_dbP'" " Change file name to next word 

" Helpers
function! Cond(Cond, ...)
  let opts = get(a:000, 0, {})
  return a:Cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" Plugins
call plug#begin()

Plug 'kylechui/nvim-surround'

Plug 'easymotion/vim-easymotion', Cond(!exists('g:vscode'))
Plug 'asvetliakov/vim-easymotion' , Cond(exists('g:vscode'), { 'as': 'vsc-easymotion' })

call plug#end()

lua require("nvim-surround").setup()
