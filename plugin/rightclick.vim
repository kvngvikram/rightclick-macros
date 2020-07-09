
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Initial configurations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set mouse=a
set mousemodel=popup  "" This is for the popup menu in GUI, but it disables right-click drag (I don't want that).
" Go to insert mode where ever you click
nnoremap <LeftMouse> <LeftMouse>i

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Menu items check
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function s:Rightclick_normal_defaults()
	let g:rightclick_normal_items = ['save', 'quit', 'undo', 'redo', 'paste']
	let g:rightclick_normal_macros = [':w' , ':q', 'u', '', 'p']
	" Ctrl-v Ctrl-M in insert mode to get '', the literal for <Enter>
	" Similarly Ctrl-v <Tab or Esc> for the corresponding literal characters.
endfunction

function s:Rightclick_visual_defaults()
	let g:rightclick_visual_items = ['copy', 'cut', 'paste']
	let g:rightclick_visual_macros = ['y' , 'd', 'p']
endfunction

if( !exists('rightclick_normal_items') || !exists('rightclick_normal_macros') )
	call s:Rightclick_normal_defaults()
elseif( len(rightclick_normal_items) != len(rightclick_normal_macros) )
	call s:Rightclick_normal_defaults()
endif

if( !exists('rightclick_visual_items') || !exists('rightclick_visual_macros') )
	call s:Rightclick_visual_defaults()
elseif( len(rightclick_visual_items) != len(rightclick_visual_macros) )
	call s:Rightclick_visual_defaults()
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" Getting largest width to give as menu box width
let s:no_normal_items = len(rightclick_normal_items)
let s:normal_width = 0
for i in rightclick_normal_items
	if len(i) > s:normal_width
		let s:normal_width = len(i)
	endif
endfor

let s:no_visual_items = len(rightclick_visual_items)
let s:visual_width = 0
for i in rightclick_visual_items
	if len(i) > s:visual_width
		let s:visual_width = len(i)
	endif
endfor


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Run neovim or vim parts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('nvim')

	let g:rightclick_nvim_boarder_nw = exists('g:rightclick_nvim_boarder_nw') ? g:rightclick_nvim_boarder_nw : '╭'
	let g:rightclick_nvim_boarder_ne = exists('g:rightclick_nvim_boarder_ne') ? g:rightclick_nvim_boarder_ne : '╮'
	let g:rightclick_nvim_boarder_sw = exists('g:rightclick_nvim_boarder_sw') ? g:rightclick_nvim_boarder_sw : '╰'
	let g:rightclick_nvim_boarder_se = exists('g:rightclick_nvim_boarder_se') ? g:rightclick_nvim_boarder_se : '╯'
	let g:rightclick_nvim_boarder_h  = exists('g:rightclick_nvim_boarder_h ') ? g:rightclick_nvim_boarder_h  : '─'
	let g:rightclick_nvim_boarder_v  = exists('g:rightclick_nvim_boarder_v ') ? g:rightclick_nvim_boarder_v  : '│'

	let s:normal_width += 4
	let i = 0
	while i < s:no_normal_items
		if( len(rightclick_normal_items[i]) < s:normal_width )
			let rightclick_normal_items[i] = rightclick_normal_items[i] . repeat(' ', s:normal_width - len(rightclick_normal_items[i]) - 4 )
		endif
		let rightclick_normal_items[i] = rightclick_nvim_boarder_v . ' ' . rightclick_normal_items[i] . ' ' . rightclick_nvim_boarder_v
		let i += 1
	endwhile

	let rightclick_normal_items = [rightclick_nvim_boarder_nw . repeat(rightclick_nvim_boarder_h, s:normal_width - 2) . rightclick_nvim_boarder_ne] +
				\rightclick_normal_items + [rightclick_nvim_boarder_sw . repeat(rightclick_nvim_boarder_h, s:normal_width - 2) . rightclick_nvim_boarder_se]
	let rightclick_normal_macros = [' '] + rightclick_normal_macros + [' ']

	let s:normal_height = len(rightclick_normal_items)
	let s:normal_buf_opts = {'relative': 'cursor', 'row': 1, 'col': 0, 'width': s:normal_width, 'height': s:normal_height, 'style': 'minimal'}


	let s:visual_width += 4
	let i = 0
	while i < s:no_visual_items
		if( len(rightclick_visual_items[i]) < s:visual_width )
			let rightclick_visual_items[i] = rightclick_visual_items[i] . repeat(' ', s:visual_width - len(rightclick_visual_items[i]) - 4 )
		endif
		let rightclick_visual_items[i] = rightclick_nvim_boarder_v . ' ' . rightclick_visual_items[i] . ' ' . rightclick_nvim_boarder_v
		let i += 1
	endwhile

	let rightclick_visual_items = [rightclick_nvim_boarder_nw . repeat(rightclick_nvim_boarder_h, s:visual_width - 2) . rightclick_nvim_boarder_ne] +
				\ rightclick_visual_items + [rightclick_nvim_boarder_sw . repeat(rightclick_nvim_boarder_h, s:visual_width - 2) . rightclick_nvim_boarder_se]
	let rightclick_visual_macros = [' '] + rightclick_visual_macros + [' ']

	let s:visual_height = len(rightclick_visual_items)
	let s:visual_buf_opts = {'relative': 'cursor', 'row': 1, 'col': 0, 'width': s:visual_width, 'height': s:visual_height, 'style': 'minimal'}


	nnoremap <silent> <RightMouse> <LeftMouse>:call Rightclick_normal_nvim()<CR>
	inoremap <silent> <RightMouse> <Esc>:call Rightclick_normal_nvim()<CR>
	vnoremap <silent> <RightMouse> <LeftMouse>:call Rightclick_visual_nvim()<CR>

else

	nnoremap <silent> <RightMouse> <LeftMouse>:call popup_create(rightclick_normal_items, #{
				\ title: "Use keyboard",
				\ callback: 'Rightclick_normal_vim',
				\ line: 'cursor+1',
				\ col: 'cursor',
				\ border: [],
				\ cursorline: 1,
				\ padding: [0,1,0,1],
				\ filter: 'popup_filter_menu'
				\ })<CR>

	inoremap <silent> <RightMouse> <Esc>:call popup_create(rightclick_normal_items, #{
				\ title: "Use keyboard",
				\ callback: 'Rightclick_normal_vim',
				\ line: 'cursor+1',
				\ col: 'cursor',
				\ border: [],
				\ cursorline: 1,
				\ padding: [0,1,0,1],
				\ filter: 'popup_filter_menu'
				\ })<CR>

	vnoremap <silent> <RightMouse> <LeftMouse>:call popup_create(rightclick_visual_items, #{
				\ title: "Use keyboard",
				\ callback: 'Rightclick_visual_vim',
				\ line: 'cursor+1',
				\ col: 'cursor',
				\ border: [],
				\ cursorline: 1,
				\ padding: [0,1,0,1],
				\ filter: 'popup_filter_menu'
				\ })<CR>

endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Functions for neovim and vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function Rightclick_normal_vim(id, result)

	let s:rightclick_normal_z_reg_backup = @z
	let @z = g:rightclick_normal_macros[a:result - 1]
	normal @z
	let @z = s:rightclick_normal_z_reg_backup
endfunction


function Rightclick_visual_vim(id, result)

	let s:rightclick_visual_z_reg_backup = @z
	let @z = g:rightclick_visual_macros[a:result - 1]
	normal gv@z
	let @z = s:rightclick_visual_z_reg_backup
endfunction


function Rightclick_normal_nvim()

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
				\\| let @z = g:rightclick_normal_macros[g:rightclick_command_number-1]
				\\|endif<CR>
				\@z
				\:let @z = g:rightclick_normal_z_reg_backup<CR>

	nnoremap <buffer> <silent> <Enter> :let g:rightclick_command_number = getcurpos()[1]<CR>
				\:let g:rightclick_new_window_id = win_getid()<CR>
				\:call nvim_win_close(g:rightclick_window_id, 1)<CR>
				\:if(g:rightclick_new_window_id == rightclick_window_id)
				\\| let @z = g:rightclick_normal_macros[g:rightclick_command_number-1]
				\\|endif<CR>
				\@z
				\:let @z = g:rightclick_normal_z_reg_backup<CR>

	nnoremap <buffer> <silent> <Esc> :bw<CR>
				\:let @z = g:rightclick_normal_z_reg_backup<CR>

	nnoremap <buffer> <silent> <RightMouse> <LeftMouse>
				\:call nvim_win_close(g:rightclick_window_id, 1)<CR>
				\:let @z = g:rightclick_normal_z_reg_backup<CR>
endfunction


function Rightclick_visual_nvim()

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
				\\| let @z = g:rightclick_visual_macros[g:rightclick_command_number-1]
				\\|endif<CR>
				\gv@z
				\:let @z = g:rightclick_visual_z_reg_backup<CR>

	noremap <buffer> <silent> <Enter> :let g:rightclick_command_number = getcurpos()[1]<CR>
				\:let g:rightclick_new_window_id = win_getid()<CR>
				\:call nvim_win_close(g:rightclick_window_id, 1)<CR>
				\:if(g:rightclick_new_window_id == rightclick_window_id)
				\\| let @z = g:rightclick_visual_macros[g:rightclick_command_number-1]
				\\|endif<CR>
				\gv@z
				\:let @z = g:rightclick_visual_z_reg_backup<CR>

	nnoremap <buffer> <silent> <Esc> :bw<CR>
				\:let @z = g:rightclick_visual_z_reg_backup<CR>

	nnoremap <buffer> <silent> <RightMouse> <LeftMouse>
				\:call nvim_win_close(g:rightclick_window_id, 1)<CR>
				\:let @z = g:rightclick_visual_z_reg_backup<CR>
endfunction
