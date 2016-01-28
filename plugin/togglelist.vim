" toggle list plugin
"
" Donald Ephraim Curtis (2011)
"
" boom
"
" This plugin allows you to use \l and \q to toggle the location list and
" quickfix list (respectively).
"
"

if exists("g:loaded_toggle_list")
  finish
endif

function! s:GetBufferList() 
  redir =>buflist 
  silent! ls 
  redir END 
  return buflist 
endfunction

function! ToggleLocationList()
  for bufnum in map(filter(split(s:GetBufferList(), '\n'), 'v:val =~ "Location List"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    lclose
    return
  endfor

  let winnr = winnr()
  try
    lopen
  catch /E776/
      echohl ErrorMsg 
      echo "Location List is Empty."
      echohl None
      return
  endtry
  if winnr() != winnr
    wincmd p
  endif
endfunction

function! ToggleQuickfixList()
  for bufnum in map(filter(split(s:GetBufferList(), '\n'), 'v:val =~ "Quickfix List"'), 'str2nr(matchstr(v:val, "\\d\\+"))') 
    if bufwinnr(bufnum) != -1
      cclose
      return
    endif
  endfor
  let winnr = winnr()
  if exists("g:toggle_list_copen_command")
    exec(g:toggle_list_copen_command)
  else
    copen
  endif
  if winnr() != winnr
    wincmd p
  endif
endfunction

if !exists("g:toggle_list_no_mappings")
    nmap <script> <silent> <leader>l :call ToggleLocationList()<CR>
    nmap <script> <silent> <leader>q :call ToggleQuickfixList()<CR>
endif



