set nocompatible
source $VIMRUNTIME/vimrc_example.vim
"source $VIMRUNTIME/mswin.vim
"behave mswin

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

colorscheme desert
set nobackup

if(has("win32") || has("win95") || has("win64") || has("win16")) "判定当前操作系统类型
    let g:iswindows=1
else
    let g:iswindows=0
endif
set nocompatible "不要vim模仿vi模式，建议设置，否则会有很多不兼容的问题
syntax on"打开高亮
if has("autocmd")
    filetype plugin indent on "根据文件进行缩进
    augroup vimrcEx
        au!
        autocmd FileType text setlocal textwidth=78
        autocmd BufReadPost *
                    \ if line("'\"") > 1 && line("'\"") <= line("$") |
                    \ exe "normal! g`\"" |
                    \ endif
    augroup END
else
    "智能缩进，相应的有cindent，官方说autoindent可以支持各种文件的缩进，但是效果会比只支持C/C++的cindent效果会差一点，但笔者并没有看出来
    set autoindent " always set autoindenting on 
endif " has("autocmd")
set ic " ignore case
set expandtab
set shiftwidth=4
"thomas: 
"set cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,l0,gs,hs,ps,ts,+s,c3,C0,(2s,us,\U0,w0,m0,j0,)20,*30
set cinoptions=>s,b1,e0,n0,f0,{0,}0,^0,:0,=s,l0,gs,hs,ps,ts,+s,c3,C0,(2s,us,\U0,w0,m0,j0,)20,*30
set softtabstop=4
set tabstop=4 "让一个tab等于4个空格
set vb t_vb=
set nowrap "不自动换行
set hlsearch "高亮显示结果
set incsearch "在输入要搜索的文字时，vim会实时匹配
"set backspace=indent,eol,start whichwrap+=<,>,[,] "允许退格键的使用
if(g:iswindows==1) "允许鼠标的使用
    ""防止linux终端下无法拷贝
    "if has('mouse')
        "set mouse=a
    "endif
    au GUIEnter * simalt ~x
endif
"字体的设置
"set guifont=Bitstream_Vera_Sans_Mono:h10:cANSI "记住空格用下划线代替哦
"set gfw.宋体:h10:cGB2312
"set guifont=Lucida_Console:h10:cANSI "记住空格用下划线代替哦
set guifont=Courier:h12:cANSI 
"
"
"autocmd BufEnter * lcd %:p:h

map <F8> :NERDTreeToggle<CR>
map <C-F8> :NERDTreeFind<CR>

set tags=./tags,tags;
let mapleader=","

"thomas: already done in vimfiles/plugin/cscope_maps.vim
"set csto=1
"if has("cscope")
    "set csprg=d:/Vim/vim73/cscope/notepad++.exe "cscope.exe
    "set csto=0
    "set nocst
    "set nocsverb
    "" add any database in current directory
    "if filereadable("cscope.out")
        "cs add cscope.out
    "" else add database pointed to by environment
    "elseif $CSCOPE_DB != ""
        "cs add $CSCOPE_DB
    "endif
    "set csverb
    "map <C-_> :cstag <C-R>=expand("<cword>")<CR><CR>
	"nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
	"nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
	"nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
	"nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
	"nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
	"nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
	"nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	"nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>

"endif

"if(has('cscope'))
    ""set csprg=d:/Vim/vim73/cscope/insight3.exe
    "set csto=1
    ""if filereadable("cscope.out")
        ""execute "cs add cscope.out"
    ""endif
    "set nocsverb
"endif

map <F11> :call Do_CsTag()<CR>
map <F12> :call Do_CTag()<CR>

function Do_CsTag()
    let dir = getcwd()
    "if(executable('cscope')&&has('cscope'))
    if(executable('notepad++')&&has('cscope'))
        if has("cscope")
            silent! execute "cs kill -l"
        endif

        if filereadable("cscope.files")
            if(g:iswindows==1)
                let csfilesdeleted=delete(dir."\\"."cscope.files")
            else
                let csfilesdeleted=delete("./"."cscope.files")
            endif
            if(csfilesdeleted!=0)
                echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
                return
            endif
        endif
        if filereadable("cscope.out")
            if(g:iswindows==1)
                let csoutdeleted=delete(dir."\\"."cscope.out")
            else
                let csoutdeleted=delete("./"."cscope.out")
            endif
            if(csoutdeleted!=0)
                echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
                return
            endif
        endif
        if(g:iswindows!=1)
            silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
        else
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs,*.def >> cscope.files"
        endif
        "silent! execute "!notepad++ -b"
        execute "!notepad++ -b"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endf

function Do_CTag()
    let dir = getcwd()
    if filereadable("tags")
        if(g:iswindows==1)
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif


    if(executable('ctags'))
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
        "silent! execute "!insight3 -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
endfunction



