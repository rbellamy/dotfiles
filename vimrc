"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Description:
""  This vimrc is my default vim configuration file.
""
"" Prerequisites:
""  - This configuration has been tested only on Ubuntu/Kubuntu version 10.10. It
""    may work in lower Ubuntu versions and other Debian distributions but there
""    is no guarantee.
""
"" Installation:
""  The instructions here install the required software packages and sets our
""  vim configuration directory under git versioning control. By using git to
""  manage our configuration we get several benefits:
""
""    - History record of our configuration files.
""    - Easy synchronization among several machines via git cloning.
""    - Easy handling of experimental configurations via branches.
""    - Easy setup of per machine configurations via tags.
""    - Easy handling of plugins via panthogen and git submodules.
""
""  This assumes you are starting with a fresh vim configuration. If not I
""  recommend you backup all your config files and then follow carefully the
""  instructions in this file. At the end you will have a powerful vim
""  configuration that you can then further modify to fit your tastes.
""
""  - Remove all your vim configurations if you have: 
""
""    rm -rf $HOME/.vim*
""
""  - Create a clean $HOME/.vim folder
""
""    mkdir -p $HOME/.vim
""
""  - Copy this configuration file inside the .vim folder:
""
""    cp -f vimrc $HOME/.vim
""
""  - Create a symbolic link so vim can find this configuration file:
""
""    ln -s $HOME/.vim/vimrc $HOME/.vimrc
""
""  - Initialize the git repo on the .vimrc folder:
""
""    cd $HOME/.vim
""    git init
""
""  From here there are two paths you may follow to complete the configuration.
""  The firt method is to read this vimrc file step by step executing the
""  Installation steps in each section. This is the  prefered method for first
""  timers because it will allow you to familiarize yourself with this config.
""
""  The second (faster) option is to extract all the Installation steps into a
""  bash script and run the script. When the script finishes you will have
""  everything setup automagically for you. To extract and execute this magic
""  bash script follow these instructions:
""
""    cat $HOME/.vim/vimrc | grep "\"\"  \\$" | cut -d' ' -f4- > $HOME/vim-install.sh
""    chmod +x $HOME/vim-install.sh
""    $HOME/vim-install.sh  # run the script
""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Vim base install
""
"" Prerequisites:
""  A running Ubuntu/Kubuntu system 10.10.
""  Basic knowledge of Git and K/Ubuntu administration.
""  A $HOME/.vim directory created and with this configuration file inside it.
""
"" Installation:
""  $ #!/usr/bin/env bash
""  $ set -o errexit
""  $ sudo aptitude install vim-ruby vim-common ack-grep exuberant-ctags
""  $ sudo aptitude install git-core wget sed
""
"" Resources:
""  http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/
""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" General Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible                      " Disable vi compatibility.
set fileformats=unix,dos              " Use unix file format.
set number                            " Show line number column.
set nobackup                          " Stop vim from creating ~ files.
set showcmd                           " Display commands as they are typed.
set ttyfast                           " Smoother screen redraws.
set hlsearch                          " Highlight search results.
set showmatch                         " Show briefly matching bracket when closing it.
autocmd InsertEnter * se cul          " Highlight current line in Insert Mode. 
autocmd InsertLeave * se nocul        " Don't highlight current line in other modes.

" Set search path for gf command
set path=/usr/include,/usr/local/include,**;$HOME

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Pathogen Plugin
""
"" Description:
""  This vim plugin allows easy management of other plugins in bundles.
""
"" Installation:
""  $ mkdir -p $HOME/.vim/autoload
""  $ wget --no-check-certificate \
""  $  https://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim \
""  $  -O $HOME/.vim/autolad/pathogen.vim
""
"" Resources:
""   http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/
""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype off " Needed so pathogen also loads ftdetect plugins.
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Re-enable per filetype plugins and indents after loading pathogen plugin
filetype plugin indent on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Filetype Settings
""
"" Description:
""  For each filetype we create a ftplugin/<filetype>.vim file with settings
""  particular to each filetype. For example we set tabs instead of spaces for
""  python and makefile files and enable the different omnufunctions for each
""  filetype that supports it.
""
"" Installation:
""  $ mkdir -p $HOME/.vim/ftdetect  # Folder used to add new filetypes.
""  $ mkdir -p $HOME/.vim/ftplugin  # Folder used to add per filetype settings.
""  $ mkdir -p $HOME/.vim/syntax    # Folder used to add per filetype highlight.
""  # Add ragel filetype and syntax:
""  $ echo "au BufRead,BufNewFile *.rl setlocal filetype=ragel" > $HOME/.vim/ftdetect/ragel.vim
""  $ wget http://www.complang.org/ragel/ragel.vim -O $HOME/.vim/syntax/ragel.vim
""  # Set omnifunctions for each filetype:
""  $ echo "setlocal omnifunc=csscomplete#CompleteCSS" > $HOME/.vim/ftplugin/css.vim
""  $ echo "setlocal omnifunc=ccomplete#Complete" > $HOME/.vim/ftplugin/c.vim
""  $ echo "let g:rubycomplete_buffer_loading = 1" > $HOME/.vim/ftplugin/eruby.vim
""  $ echo "let g:rubycomplete_rails = 1" >> $HOME/.vim/ftplugin/eruby.vim
""  $ echo "let g:rubycomplete_classes_in_global = 1" >> $HOME/.vim/ftplugin/eruby.vim
""  $ echo "setlocal omnifunc=rubycomplete#Complete" >> $HOME/.vim/ftplugin/eruby.vim
""  $ cp -f $HOME/.vim/ftplugin/eruby.vim $HOME/.vim/ftplugin/ruby.vim
""  $ echo "setlocal omnifunc=htmlcomplete#CompleteTags" > $HOME/.vim/ftplugin/html.vim
""  $ cp -f $HOME/.vim/ftplugin/html.vim $HOME/.vim/ftplugin/markdown.vim
""  $ echo "setlocal omnifunc=javacomplete#Complete" > $HOME/.vim/ftplugin/java.vim
""  $ echo "setlocal completefunc=javacomplete#CompleteParamsInfo" >> $HOME/.vim/ftplugin/java.vim
""  $ echo "setlocal omnifunc=javascriptcomplete#CompleteJS" > $HOME/.vim/ftplugin/javascript.vim
""  $ echo "setlocal noexpandtab" > $HOME/.vim/ftplugin/make.vim
""  $ echo "setlocal omnifunc=phpcomplete#CompletePHP" > $HOME/.vim/ftplugin/php.vim
""  $ echo "setlocal noexpandtab" > $HOME/.vim/ftplugin/python.vim
""  $ echo "setlocal omnifunc=pythoncomplete#Complete" >> $HOME/.vim/ftplugin/python.vim
""  # type /ref{fig: and press <C-n> to autocomplete references
""  $ echo "setlocal iskeyword+=:" > $HOME/.vim/ftplugin/tex.vim
""  $ echo "setlocal omnifunc=xmlcomplete#CompleteTags" > $HOME/.vim/ftplugin/xml.vim
""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Look and Feel Settings
""
"" Description:
""  These instructions are specific for using vim in a terminal window. They
""  support for 256 color terminals and sets the vividchalk color scheme as
""  default.
""
"" Prerequisites:
""  - Make sure you have the base system packages installed including git-core.
""  - Make sure you have the pathogen.vim plugin installed correctly.
""  - Make sure your terminal supports 256 colors. Konsole does but you must set
""    the TERM variable to xterm-256color in the schema properties.
""
"" Installation:
""  $ mkdir -p $HOME/.vim/bundle
""  $ git submodule add https://github.com/tpope/vim-vividchalk.git $HOME/.vim/bundle/vividchalk
""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on                             " Enable syntax highlighting.
set t_Co=256                          " Enable 256 color mode in terminal.
set background=dark                   " I like dark backgrounds.
colors vividchalk                     " My current favorite color scheme.

" Show tabs and tailing spaces.
" Note: to insert the middle point press ctrl+k .M in insert mode
:set list
:set listchars=tab:»·,trail:⋅,nbsp:⋅

" By default insert spaces instead of tabs. This may be overriden by the
" configuration inside ftplugin directory.
" Note: If you want a real tab use "ctrl-v, tab" in insert mode.
set expandtab

" Number of spaces to insert for a tab
set shiftwidth=2
set tabstop=2
set softtabstop=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Improve Vim's Command Line Autocompletion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildmode=full wildmenu              " Command-line tab completion
set infercase                           " AutoComplete in Vim
set completeopt=longest,menu,menuone
set wildignore+=*.o,*.obj,*.pyc,*.DS_STORE,*.db,*.swc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TOhtml
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let html_use_css = 1
let html_dynamic_folds = 1
let html_number_lines = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Word Wrap
"
" Auto formatting options. These determine where lines will be broken when
" auto wrapping. The last to (m/M) are needed for multi byte characters (e.g.
" Japanese)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set formatoptions=tcqmM

" There are two word wrap methods, one with line breaks that adds an actual
" '\n' character at the break place and without line breaks that only displays
" text as wrapped but there is no actual break added to the text.

" Word wrap with line breaks.
" Use "gq}" to wrap the current paragraph if it is not well formatted.
set textwidth=80    " Force wrap for lines longer than 80 characters

" Vim Tip #989: Word wrap without line breaks lines.
"set wrap           " Force wrap for lines linger than the vim window
"set lbr            " Force wrap at word boundaries not chars
"nnoremap k gk      " Enable navigation within long lines (up)
"nnoremap j gj      " Enable navigation within long lines (down)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Character encoding settings
"" By manipulating this variables it is possible to edit all files in one 
"" encoding while using the terminal in a different encoding and writing/reading
"" the file in another encoding. Here we set all three variables to UTF-8.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Default file encoding for new files
setglobal fenc=utf-8

" Auto detect file encoding when opening a file. To check what file encoding was
" selected run ":set fenc" and if you know the auto detection failed and want to
" force another one run ":edit ++enc=<your_enc>".
set fencs=utf-8,euc-jp,sjis

" Internal encoding used by vim buffers, help and commands
set encoding=utf-8

" Terminal encoding used for input and terminal display
" Make sure your terminal is configured with the same encoding.
set tenc=utf-8

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Improve QuickFix Window
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Always open the quickfix window when running make, grep, grepadd and vimgrep
autocmd QuickfixCmdPost make,grep,grepadd,vimgrep :botright cwindow
map <F6> <ESC>:cN<CR>                " Jump to prev error or warn
map <F7> <ESC>:cn<CR>                " Jump to next error or warn

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Ack Plugin
""
"" Description:
""  This plugin allows vim to use the faster and easier ack-grep tool for
""  searching inside files.
""
"" Prerequisites:
""  - Make sure you have the base system packages installed including git-core.
""  - Make sure you have the pathogen.vim plugin installed correctly.
""
"" Installation:
""  $ sudo aptitude install ack-grep
""  $ mkdir -p $HOME/.vim/bundle
""  $ git submodule add https://github.com/mileszs/ack.vim.git $HOME/.vim/bundle/ack
""
"" Usage:
""  - :Ack [options] {pattern} [{directory}]
""
"" Resources:
""   http://betterthangrep.com/
""   http://amaslov.wordpress.com/2009/04/23/vim-ack-instead-of-grep/
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ackprg="ack-grep -H --nocolor --nogroup --column"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" NERDTree Plugin
""
"" Description:
""  The all powerful file explorer plugin for vim.
""
"" Prerequisites:
""  - Make sure you have the base system packages installed including git-core.
""  - Make sure you have the pathogen.vim plugin installed correctly.
""
"" Usage:
""  :NERDTreeToggle
""
"" Installation:
""  $ mkdir -p $HOME/.vim/bundle
""  $ git submodule add https://github.com/scrooloose/nerdtree.git $HOME/.vim/bundle/nerdtree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set the window width
let g:NERDTreeWinSize = 35
" Set the window position
let g:NERDTreeWinPos = "left"
" Auto centre
let g:NERDTreeAutoCenter = 0
" Not Highlight the cursor line
let g:NERDTreeHighlightCursorline = 0
" Don't change working directory when opening files
set noautochdir
let g:NERDTreeChDirMode = 2
" Show bookmarks list
let g:NERDTreeShowBookmarks = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" VCSCommand Plugin
""
"" Description:
""  This plugin enables a generic interface to all common source version control
""  systems (e.g. svn, git, hg, cvs). This also sets the statusline so it shows
""  information about the versioning of the current buffer.
""
"" Prerequisites:
""  - Make sure you have the base system packages installed including git-core.
""  - Make sure you have the pathogen.vim plugin installed correctly.
""  - Depending on the version control system you want make sure you have
""    the corresponding tools (e.g. subversion, mercurial, git-core, etc.)
""
"" Notes:
""  - If you only use Git for all you projects you may consider installing the
""    vim-fugitive plugin that only supports Git. But is smaller and more
""    powerful than the VCSCommand Git module.
""
"" Installation:
""  $ mkdir -p $HOME/.vim/bundle
""  $ git submodule add git://repo.or.cz/vcscommand.git $HOME/.vim/bundle/vcscommand
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:VCSCommandEnableBufferSetup = 1
set laststatus=2
set statusline=%{VCSCommandGetStatusLine()}[%f]%=0x%B\ \ \ [%(%l/%L,%c%V%)]\ \ (%p%%)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Neocomplcache Plugin
""
"" Description:
""  A auto-complete plugin that actually works!
""
"" Prerequisites:
""  - Make sure you have the base system packages installed including git-core.
""  - Make sure you have the pathogen.vim plugin installed correctly.
""
"" Notes:
""  - The plugin works very well but can be very slow. This is specially true
""    when opening a file for the first time as the plugin will parse and cache
""    the file keywords, tags, etc.
""
"" Installation:
""  $ mkdir -p $HOME/.vim/bundle
""  $ git submodule add https://github.com/Shougo/neocomplcache.git $HOME/.vim/bundle/neocomplcache
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:neocomplcache_enable_at_startup = 1             " Enable neocomplcache
let g:neocomplcache_enable_smart_case = 1             " Use smart case
let g:neocomplcache_enable_camel_case_completion = 1  " Use camel case completion
let g:neocomplcache_enable_underbar_completion = 1    " Use underbar completion
let g:neocomplcache_min_syntax_length = 3

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" VimOutliner Plugin
""
"" Description:
""  An Outliner plugin for vim that allows you to create nice outline documents
""  for all kinds of things like tasks/todo lists, instruction manuals,
""  presentations and even some people have written books with this.
""
"" Prerequisites:
""  - Make sure you have the base system packages installed including wget.
""  - Make sure you have the pathogen.vim plugin installed correctly.
""
"" Installation:
""  $ mkdir -p $HOME/.vim/bundle/outliner
""  $ wget http://www.troubleshooters.com/projects/alt-vimoutliner-litt/download/0.3.4/vimoutliner-0.3.4.tgz \
""  $    -O /tmp/vimoutliner-0.3.4.tgz
""  $ tar xvfz /tmp/vimoutliner-0.3.4.tgz -C /tmp
""  $ cp -rf /tmp/vimoutliner-0.3.4/* $HOME/.vim/bundle/outliner
""  $ rm -rf /tmp/vimoutliner-0.3.4*
""  # The current outliner does not load under pathogen. Here we fix this:
""  $ cat $HOME/.vim/bundle/outliner/ftdetect/vo_base.vim | egrep  au! > /tmp/vo_base.vim
""  $ cp -f /tmp/vo_base.vim $HOME/.vim/bundle/outliner/ftdetect/vo_base.vim
""  # I prefer two spaces instead of 4 for tabs:
""  $ sed '/setlocal tabstop=4/c setlocal tabstop=2' \
""  $   $HOME/.vim/bundle/outliner/ftplugin/vo_base.vim > /tmp/vo_base.1.vim
""  $ sed '/setlocal shiftwidth=4/c setlocal shiftwidth=2' \
""  $   /tmp/vo_base.1.vim > $HOME/.vim/bundle/outliner/ftplugin/vo_base.vim
""
"" Resources:
""  http://www.troubleshooters.com/projects/alt-vimoutliner-litt/
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vo_modules_load = "checkbox:hoist"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" tGPG Plugin
""
"" Description:
""  tGPG Plugin for transparent editing of encrypted files. This is the only
""  plugin for handling encrypted GPG files that worked out of the box.
""
"" Prerequisites:
""  - Make sure you have the base system packages installed including git-core.
""  - Make sure you have the pathogen.vim plugin installed correctly.
""
"" Installation:
""  $ mkdir -p $HOME/.vim/bundle
""  $ git submodule add https://github.com/tomtom/tgpg_vim.git $HOME/.vim/bundle/tgpg
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Matchit Plugin
""
"" Description:
""  Allows you to configure % to match more than just single characters.
""
"" Prerequisites:
""  - Make sure you have the base system packages installed including wget.
""  - Make sure you have the pathogen.vim plugin installed correctly.
""
"" Installation:
""  $ mkdir -p $HOME/.vim/bundle/matchit
""  $ wget http://www.vim.org/scripts/download_script.php?src_id=8196 --output-document=/tmp/matchit.zip
""  $ unzip -d $HOME/.vim/bundle/matchit /tmp/matchit.zip
""  $ rm -f /tmp/matchit.zip
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Surround Plugin
""
"" Description:
""  Plugin for deleting, changing, and adding surroundings.
""
"" Prerequisites:
""  - Make sure you have the base system packages installed including git-core.
""  - Make sure you have the pathogen.vim plugin installed correctly.
""
"" Installation:
""  $ mkdir -p $HOME/.vim/bundle
""  $ git submodule add https://github.com/tpope/vim-surround.git $HOME/.vim/bundle/surround
""
"" Usage:
""  Old text                  Command     New text ~
""  Hello *world!"            ds"         Hello world!
""  [123+4*56]/2              cs])        (123+456)/2
""  "Look ma, I'm *HTML!"     cs"<q>      <q>Look ma, I'm HTML!</q>
""  if *x>3 {                 ysW(        if ( x>3 ) {
""  my $str = *whee!;         vlllls'     my $str = 'whee!';
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Initial Git Commit
""
"" Description:
""  After installing all the plugins and setting all filetype configurations we
""  can make our first commit to the git repository.
""
"" Prerequisites:
""  - Make sure you followed all the steps in this configuration file.
""
"" Installation:
""  $ cd $HOME/.vim
""  $ git add .
""  $ git commit -m "Initial vim configuration"

"" From my vimrc.local
""set autochdir
""set nowrap
""set guifont="Bitstream\ Vera\ Sans\ Mono\ 12"
""let vimclojure#HighlightBuiltins=1	" Highlight Clojure's builtins
""let vimclojure#ParenRainbow=1		" Rainbow parantheses'
""let g:miniBufExplMapWindowNavVim = 1 	" 
""let g:miniBufExplMapWindowNavArrows = 1 " 
""let g:miniBufExplMapCTabSwitchBufs = 1 	" 
""let g:miniBufExplModSelTarget = 1 	" 

" --- OmniCppComplete ---
" -- required --
" -- optional --
" auto close options when exiting insert mode
""autocmd InsertLeave * if pumvisible() == 0|pclose|endif
""set completeopt=menu,menuone
" -- configs --
""let OmniCpp_MayCompleteDot = 1 " autocomplete with .
""let OmniCpp_MayCompleteArrow = 1 " autocomplete with ->
""let OmniCpp_MayCompleteScope = 1 " autocomplete with ::
""let OmniCpp_SelectFirstItem = 2 " select first item (but don't insert)
""let OmniCpp_NamespaceSearch = 2 " search namespaces in this and included files
""let OmniCpp_ShowPrototypeInAbbr = 1 " show function prototype (i.e. parameters) in popup window
" -- ctags --
" map <ctrl>+F12 to generate ctags for current folder:
""map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR>
" add current directory's generated tags file to available tags
""let $kernel_version=system('uname -r | tr -d "\n"')
""set tags=./tags,tags,../tags,../../tags,../../../tags,../../../../tags,/lib/modules/$kernel_version/build/tags,/usr/include/tags
