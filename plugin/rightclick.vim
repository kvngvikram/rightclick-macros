
function s:Rightclick_normal_defaults()
	let g:rightclick_normal_items = ['save', 'quit', 'undo bla']
	let g:rightclick_normal_commands = ['w' , 'q', 'u']
endfunction

function s:Rightclick_visual_defaults()
	let g:rightclick_visual_items = ['copy', 'cut']
	let g:rightclick_visual_commands = ['y' , 'd']
endfunction

if( !exists('rightclick_normal_items') || !exists('rightclick_normal_commands') )
	call s:Rightclick_normal_defaults()
elseif( len(rightclick_normal_items) != len(rightclick_normal_commands) )
	call s:Rightclick_normal_defaults()
endif

if( !exists('rightclick_visual_items') || !exists('rightclick_visual_commands') )
	call s:Rightclick_visual_defaults()
elseif( len(rightclick_visual_items) != len(rightclick_visual_commands) )
	call s:Rightclick_visual_defaults()
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set mouse=a
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:no_normal_items = len(rightclick_normal_items)

let s:normal_width = 0
for i in rightclick_normal_items
	if len(i) > s:normal_width
		let s:normal_width = len(i)
	endif
endfor

let i = 0
while i < s:no_normal_items
	if( len(rightclick_normal_items[i]) < s:normal_width )
		let rightclick_normal_items[i] = rightclick_normal_items[i] . repeat(' ', s:normal_width - len(rightclick_normal_items[i]) )
	endif
	let rightclick_normal_items[i] = '| ' . rightclick_normal_items[i] . ' |'
	let i += 1
endwhile

let s:normal_width = len(rightclick_normal_items[0])
let rightclick_normal_items = ['.' . repeat("-", s:normal_width - 2) . '.'] + rightclick_normal_items + ["'" . repeat("-", s:normal_width - 2) . "'"]
let rightclick_normal_commands = [' '] + rightclick_normal_commands + [' ']

let s:normal_height = len(rightclick_normal_items)
let s:normal_buf_opts = {'relative': 'cursor', 'row': 1, 'col': 0, 'width': s:normal_width, 'height': s:normal_height, 'style': 'minimal'}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:no_visual_items = len(rightclick_visual_items)

let s:visual_width = 0
for i in rightclick_visual_items
	if len(i) > s:visual_width
		let s:visual_width = len(i)
	endif
endfor

let i = 0
while i < s:no_visual_items
	if( len(rightclick_visual_items[i]) < s:visual_width )
		let rightclick_visual_items[i] = rightclick_visual_items[i] . repeat(' ', s:visual_width - len(rightclick_visual_items[i]) )
	endif
	let rightclick_visual_items[i] = '| ' . rightclick_visual_items[i] . ' |'
	let i += 1
endwhile

let s:visual_width = len(rightclick_visual_items[0])
let rightclick_visual_items = ['.' . repeat("-", s:visual_width - 2) . '.'] + rightclick_visual_items + ["'" . repeat("-", s:visual_width - 2) . "'"]
let rightclick_visual_commands = [' '] + rightclick_visual_commands + [' ']

let s:visual_height = len(rightclick_visual_items)
let s:visual_buf_opts = {'relative': 'cursor', 'row': 1, 'col': 0, 'width': s:visual_width, 'height': s:visual_height, 'style': 'minimal'}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function Rightclick_normal()

	let s:buf = nvim_create_buf(v:false, v:true)
	call nvim_buf_set_lines(s:buf, 0, -1, v:true, g:rightclick_normal_items)
    call nvim_open_win(s:buf, v:true, s:normal_buf_opts)
	let g:window_id = win_getid()
	" setlocal winhl=Normal:Pmenu,CursorLine:PmenuSel
	setlocal winhl=Normal:Floating
	setlocal cursorline

	nnoremap <buffer> <silent> <LeftMouse> <LeftMouse>
				\:let command_number = getcurpos()[1]<CR>
				\:let new_window_id = win_getid()<CR>
				\:call nvim_win_close(g:window_id, 1)<CR>
				\:if(new_window_id == window_id) \| exe g:rightclick_normal_commands[command_number-1] \| endif<CR>

	nnoremap <buffer> <silent> <Esc> :bw<CR>

	nnoremap <buffer> <silent> <RightMouse> <LeftMouse>
				\:call nvim_win_close(g:window_id, 1)<CR>
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


function Rightclick_visual()

	let s:buf = nvim_create_buf(v:false, v:true)
	call nvim_buf_set_lines(s:buf, 0, -1, v:true, g:rightclick_visual_items)
    call nvim_open_win(s:buf, v:true, s:visual_buf_opts)
	let g:window_id = win_getid()
	" setlocal winhl=Normal:Pmenu,CursorLine:PmenuSel
	setlocal winhl=Normal:Floating
	setlocal cursorline

	nnoremap <buffer> <silent> <LeftMouse> <LeftMouse>
				\:let command_number = getcurpos()[1]<CR>
				\:let new_window_id = win_getid()<CR>
				\:call nvim_win_close(g:window_id, 1)<CR>
				\:if(new_window_id == window_id) \| exe g:rightclick_visual_commands[command_number-1] \| endif<CR>

	nnoremap <buffer> <silent> <Esc> :bw<CR>

	nnoremap <buffer> <silent> <RightMouse> <LeftMouse>
				\:call nvim_win_close(g:window_id, 1)<CR>
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> <RightMouse> <LeftMouse>:call Rightclick_normal()<CR>
" nnoremap <silent> <RightMouse> <LeftMouse>:call Rightclick_normal()<CR>
vnoremap <silent> <RightMouse> :call Rightclick_visual()<CR>
