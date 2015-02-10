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

if(has("win32") || has("win95") || has("win64") || has("win16")) "�ж���ǰ����ϵͳ����
    let g:iswindows=1
else
    let g:iswindows=0
endif
set nocompatible "��Ҫvimģ��viģʽ���������ã�������кܶ಻���ݵ�����
syntax on"�򿪸���
if has("autocmd")
    filetype plugin indent on "�����ļ���������
    augroup vimrcEx
        au!
        autocmd FileType text setlocal textwidth=78
        autocmd BufReadPost *
                    \ if line("'\"") > 1 && line("'\"") <= line("$") |
                    \ exe "normal! g`\"" |
                    \ endif
    augroup END
else
    "������������Ӧ����cindent���ٷ�˵autoindent����֧�ָ����ļ�������������Ч�����ֻ֧��C/C++��cindentЧ�����һ�㣬�����߲�û�п�����
    set autoindent " always set autoindenting on 
endif " has("autocmd")
set ic " ignore case
set expandtab
set shiftwidth=4
"thomas: 
"set cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,l0,gs,hs,ps,ts,+s,c3,C0,(2s,us,\U0,w0,m0,j0,)20,*30
set cinoptions=>s,b1,e0,n0,f0,{0,}0,^0,:0,=s,l0,gs,hs,ps,ts,+s,c3,C0,(2s,us,\U0,w0,m0,j0,)20,*30
set softtabstop=4
set tabstop=4 "��һ��tab����4���ո�
set vb t_vb=
set nowrap "���Զ�����
set hlsearch "������ʾ���
set incsearch "������Ҫ����������ʱ��vim��ʵʱƥ��
"set backspace=indent,eol,start whichwrap+=<,>,[,] "�����˸����ʹ��
if(g:iswindows==1) "��������ʹ��
    ""��ֹlinux�ն����޷�����
    "if has('mouse')
        "set mouse=a
    "endif
    au GUIEnter * simalt ~x
endif
"���������
"set guifont=Bitstream_Vera_Sans_Mono:h10:cANSI "��ס�ո����»��ߴ���Ŷ
"set gfw.����:h10:cGB2312
"set guifont=Lucida_Console:h10:cANSI "��ס�ո����»��ߴ���Ŷ
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



