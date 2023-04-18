" Keybindings
inoremap jk <Esc>
nnoremap <Space> <Nop>

let mapleader = "\<Space>" 

nnoremap <Leader>j J
nnoremap <Leader>/ :noh<CR>

" Accept Inline Suggestion (ex. Copilot)
nnoremap <Leader>a <Cmd>call VSCodeNotify('editor.action.inlineSuggest.commit')<CR>

" Macros 
let @i = "\yef';\"_dbP'" " Change file name to next word 

" Plugins
call plug#begin()

Plug 'kylechui/nvim-surround'
Plug 'phaazon/hop.nvim' " easymotion replacement

call plug#end()

lua require("plugins")
