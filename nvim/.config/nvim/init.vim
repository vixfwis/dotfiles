call plug#begin(stdpath('data') . '/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'
Plug 'tpope/vim-fugitive'
Plug 'zacanger/angr.vim'
Plug 'junegunn/fzf.vim'
syntax on
let g:airline_theme='angr'
let g:airline_powerline_fonts = 1

set softtabstop=4
set grepprg=rg\ --vimgrep\ --smart-case\ --follow

nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <Leader>x *``cgn
nnoremap <silent> <Leader>X #``cgN
nnoremap <silent> <Leader>b :Buffers<CR>

call plug#end()
