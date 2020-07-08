
function s:Rightclick_normal_defaults()
	let g:rightclick_normal_items = ['save', 'quit', 'undo', 'redo', 'paste']
	let g:rightclick_normal_commands = [':w' , ':q', 'u', '', 'p']
	" Ctrl-v Ctrl-M in insert mode to get '', the literal for <Enter>
	" Similarly Ctrl-v <Tab or Esc> for the corresponding literal characters.
endfunction

function s:Rightclick_visual_defaults()
	let g:rightclick_visual_items = ['copy', 'cut', 'paste']
	let g:rightclick_visual_commands = ['y' , 'd', 'p']
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
set mousemodel=popup  "" This is for the popup menu in GUI, but it disables right-click drag (I don't want that).
" Go to insert mode where ever you click
nnoremap <LeftMouse> <LeftMouse>i
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
	let g:rightclick_window_id = win_getid()
	" setlocal winhl=Normal:Pmenu,CursorLine:PmenuSel
	setlocal winhl=Normal:Floating
	" setlocal cursorline

	let g:rightclick_normal_z_reg_backup = @z
	let @z = ''

	nnoremap <buffer> <silent> <LeftMouse> <LeftMouse>
				\:let g:rightclick_command_number = getcurpos()[1]<CR>
				\:let g:rightclick_new_window_id = win_getid()<CR>
				\:call nvim_win_close(g:rightclick_window_id, 1)<CR>
				\:if(g:rightclick_new_window_id == rightclick_window_id)
				\\| let @z = g:rightclick_normal_commands[g:rightclick_command_number-1]
				\\|endif<CR>
				\@z
				\:let @z = g:rightclick_normal_z_reg_backup<CR>

	nnoremap <buffer> <silent> <Esc> :bw<CR>
				\:let @z = g:rightclick_normal_z_reg_backup<CR>

	nnoremap <buffer> <silent> <RightMouse> <LeftMouse>
				\:call nvim_win_close(g:rightclick_window_id, 1)<CR>
				\:let @z = g:rightclick_normal_z_reg_backup<CR>
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


function Rightclick_visual()

	let s:buf = nvim_create_buf(v:false, v:true)
	call nvim_buf_set_lines(s:buf, 0, -1, v:true, g:rightclick_visual_items)
    call nvim_open_win(s:buf, v:true, s:visual_buf_opts)
	stopinsert
	let g:rightclick_window_id = win_getid()
	" setlocal winhl=Normal:Pmenu,CursorLine:PmenuSel
	setlocal winhl=Normal:Floating
	" setlocal cursorline

	let g:rightclick_visual_z_reg_backup = @z
	let @z = ''

	noremap <buffer> <silent> <LeftMouse> <LeftMouse>
				\:let g:rightclick_command_number = getcurpos()[1]<CR>
				\:let g:rightclick_new_window_id = win_getid()<CR>
				\:call nvim_win_close(g:rightclick_window_id, 1)<CR>
				\:if(g:rightclick_new_window_id == rightclick_window_id)
				\\| let @z = g:rightclick_visual_commands[g:rightclick_command_number-1]
				\\|endif<CR>
				\gv@z
				\:let @z = g:rightclick_visual_z_reg_backup<CR>

	nnoremap <buffer> <silent> <Esc> :bw<CR>
				\:let @z = g:rightclick_visual_z_reg_backup<CR>

	nnoremap <buffer> <silent> <RightMouse> <LeftMouse>
				\:call nvim_win_close(g:rightclick_window_id, 1)<CR>
				\:let @z = g:rightclick_visual_z_reg_backup<CR>
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> <RightMouse> <LeftMouse>:call Rightclick_normal()<CR>
inoremap <silent> <RightMouse> <Esc><LeftMouse>:call Rightclick_normal()<CR>
vnoremap <silent> <RightMouse> <LeftMouse>:call Rightclick_visual()<CR>
