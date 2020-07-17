
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:rightclick_default_mappings = exists('g:rightclick_default_mappings') ? g:rightclick_default_mappings : 1
if (s:rightclick_default_mappings)
	nnoremap <silent> <RightMouse> <LeftMouse>:call Rightclick_normal()<CR>
	inoremap <silent> <RightMouse> <Esc>:call Rightclick_normal()<CR>
	vnoremap <silent> <RightMouse> <LeftMouse>:call Rightclick_visual()<CR>
	" Go to insert mode where ever you click
	nnoremap <LeftMouse> <LeftMouse>i
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Initial configurations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:rightclick_default_config = exists('g:rightclick_default_config') ? g:rightclick_default_config : 1
if (s:rightclick_default_config)
	set mouse=a
	set mousemodel=popup  "" This is for the popup menu in GUI, but it disables right-click drag (I don't want that).
endif

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

	let s:rightclick_nvim_boarder_nw = exists('g:rightclick_nvim_boarder_nw') ? g:rightclick_nvim_boarder_nw : '┣'  " it was '┏' before
	let s:rightclick_nvim_boarder_ne = exists('g:rightclick_nvim_boarder_ne') ? g:rightclick_nvim_boarder_ne : '┓'
	let s:rightclick_nvim_boarder_sw = exists('g:rightclick_nvim_boarder_sw') ? g:rightclick_nvim_boarder_sw : '┗'
	let s:rightclick_nvim_boarder_se = exists('g:rightclick_nvim_boarder_se') ? g:rightclick_nvim_boarder_se : '┛'
	let s:rightclick_nvim_boarder_h  = exists('g:rightclick_nvim_boarder_h' ) ? g:rightclick_nvim_boarder_h  : '━'
	let s:rightclick_nvim_boarder_v  = exists('g:rightclick_nvim_boarder_v' ) ? g:rightclick_nvim_boarder_v  : '┃'


	let s:normal_width += 4
	let i = 0
	while i < s:no_normal_items
		if( len(rightclick_normal_items[i]) < s:normal_width )
			let rightclick_normal_items[i] = rightclick_normal_items[i] . repeat(' ', s:normal_width - len(rightclick_normal_items[i]) - 4 )
		endif
		let rightclick_normal_items[i] = s:rightclick_nvim_boarder_v . ' ' . rightclick_normal_items[i] . ' ' . s:rightclick_nvim_boarder_v
		let i += 1
	endwhile

	let rightclick_normal_items = [s:rightclick_nvim_boarder_nw . repeat(s:rightclick_nvim_boarder_h, s:normal_width - 2) . s:rightclick_nvim_boarder_ne] +
				\rightclick_normal_items + [s:rightclick_nvim_boarder_sw . repeat(s:rightclick_nvim_boarder_h, s:normal_width - 2) . s:rightclick_nvim_boarder_se]
	let rightclick_normal_macros = [' '] + rightclick_normal_macros + [' ']

	let s:normal_height = len(rightclick_normal_items)
	let s:normal_buf_opts = {'relative': 'cursor', 'row': 1, 'col': 0, 'width': s:normal_width, 'height': s:normal_height, 'style': 'minimal'}


	let s:visual_width += 4
	let i = 0
	while i < s:no_visual_items
		if( len(rightclick_visual_items[i]) < s:visual_width )
			let rightclick_visual_items[i] = rightclick_visual_items[i] . repeat(' ', s:visual_width - len(rightclick_visual_items[i]) - 4 )
		endif
		let rightclick_visual_items[i] = s:rightclick_nvim_boarder_v . ' ' . rightclick_visual_items[i] . ' ' . s:rightclick_nvim_boarder_v
		let i += 1
	endwhile

	let rightclick_visual_items = [s:rightclick_nvim_boarder_nw . repeat(s:rightclick_nvim_boarder_h, s:visual_width - 2) . s:rightclick_nvim_boarder_ne] +
				\ rightclick_visual_items + [s:rightclick_nvim_boarder_sw . repeat(s:rightclick_nvim_boarder_h, s:visual_width - 2) . s:rightclick_nvim_boarder_se]
	let rightclick_visual_macros = [' '] + rightclick_visual_macros + [' ']

	let s:visual_height = len(rightclick_visual_items)
	let s:visual_buf_opts = {'relative': 'cursor', 'row': 1, 'col': 0, 'width': s:visual_width, 'height': s:visual_height, 'style': 'minimal'}



	let g:rightclick_enable_wrap_later = 0
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Functions for neovim and vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Generic function
function Rightclick_normal()
	if has('nvim')
		call s:Rightclick_normal_nvim()
	else
		call popup_create(g:rightclick_normal_items, #{
				\ title: "Use keyboard",
				\ callback: 'Rightclick_normal_vim_callback',
				\ line: 'cursor+1',
				\ col: 'cursor',
				\ border: [],
				\ cursorline: 1,
				\ padding: [0,1,0,1],
				\ filter: 'popup_filter_menu'
				\ })
	endif
endfunction


" Generic function
function Rightclick_visual()
	if has('nvim')
		call s:Rightclick_visual_nvim()
	else
		call popup_create(g:rightclick_visual_items, #{
				\ title: "Use keyboard",
				\ callback: 'Rightclick_visual_vim_callback',
				\ line: 'cursor+1',
				\ col: 'cursor',
				\ border: [],
				\ cursorline: 1,
				\ padding: [0,1,0,1],
				\ filter: 'popup_filter_menu'
				\ })
	endif
endfunction


" Callback functions are required only in Vim
if !has('nvim')
	function Rightclick_normal_vim_callback(id, result)

		let s:rightclick_normal_z_reg_backup = @z
		let @z = g:rightclick_normal_macros[a:result - 1]
		normal @z
		let @z = s:rightclick_normal_z_reg_backup
	endfunction


	function Rightclick_visual_vim_callback(id, result)

		let s:rightclick_visual_z_reg_backup = @z
		let @z = g:rightclick_visual_macros[a:result - 1]
		normal gv@z
		let @z = s:rightclick_visual_z_reg_backup
	endfunction
endif


function s:Rightclick_normal_nvim()

	" Scroll window lines downwards with CTRL-E to fit the menu if the cursor
	" line is at the end of the window
	let l:no_lines_below_cursorline_in_win = nvim_win_get_height(0) - (line('.') - line('w0')) - 1
	if( s:normal_height > l:no_lines_below_cursorline_in_win)
		let g:rightclick_enable_wrap_later = &wrap ? 1 : 0
		set nowrap
		exe 'normal ' . (s:normal_height - l:no_lines_below_cursorline_in_win) . ''
	endif

	let l:no_cols_after_cursor_in_win = winwidth(0) - wincol()
	if( s:normal_width > l:no_cols_after_cursor_in_win + 1 )
		let g:rightclick_enable_wrap_later = (g:rightclick_enable_wrap_later || &wrap) ? 1 : 0
		set nowrap
		exe 'normal '.(s:normal_width - l:no_cols_after_cursor_in_win -1).'zl'
	endif


	let s:buf = nvim_create_buf(v:false, v:true)
	call nvim_buf_set_lines(s:buf, 0, -1, v:true, g:rightclick_normal_items)
    call nvim_open_win(s:buf, v:true, s:normal_buf_opts)
	let g:rightclick_window_id = win_getid()
	" setlocal winhl=Normal:Pmenu,CursorLine:PmenuSel
	setlocal winhl=Normal:Floating
	" setlocal cursorline
	normal jl

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
				\:if(g:rightclick_enable_wrap_later)
				\\| set wrap
				\\| let g:rightclick_enable_wrap_later = 0
				\\|endif<CR>

	nnoremap <buffer> <silent> <Enter> :let g:rightclick_command_number = getcurpos()[1]<CR>
				\:let g:rightclick_new_window_id = win_getid()<CR>
				\:call nvim_win_close(g:rightclick_window_id, 1)<CR>
				\:if(g:rightclick_new_window_id == rightclick_window_id)
				\\| let @z = g:rightclick_normal_macros[g:rightclick_command_number-1]
				\\|endif<CR>
				\@z
				\:let @z = g:rightclick_normal_z_reg_backup<CR>
				\:if(g:rightclick_enable_wrap_later)
				\\| set wrap
				\\| let g:rightclick_enable_wrap_later = 0
				\\|endif<CR>

	nnoremap <buffer> <silent> <Esc> :bw<CR>
				\:let @z = g:rightclick_normal_z_reg_backup<CR>
				\:if(g:rightclick_enable_wrap_later)
				\\| set wrap
				\\| let g:rightclick_enable_wrap_later = 0
				\\|endif<CR>

	nnoremap <buffer> <silent> <RightMouse> <LeftMouse>
				\:call nvim_win_close(g:rightclick_window_id, 1)<CR>
				\:let @z = g:rightclick_normal_z_reg_backup<CR>
				\:if(g:rightclick_enable_wrap_later)
				\\| set wrap
				\\| let g:rightclick_enable_wrap_later = 0
				\\|endif<CR>
endfunction


function s:Rightclick_visual_nvim()

	" Scroll window lines downwards with CTRL-E to fit the menu if the cursor
	" line is at the end of the window
	let l:no_lines_below_cursorline_in_win = nvim_win_get_height(0) - (line('.') - line('w0')) - 1
	if( s:visual_height > l:no_lines_below_cursorline_in_win)
		let g:rightclick_enable_wrap_later = &wrap ? 1 : 0
		set nowrap
		exe 'normal ' . (s:visual_height - l:no_lines_below_cursorline_in_win) . ''
	endif

	let l:no_cols_after_cursor_in_win = winwidth(0) - wincol()
	if( s:visual_width > l:no_cols_after_cursor_in_win + 1 )
		let g:rightclick_enable_wrap_later = (g:rightclick_enable_wrap_later || &wrap) ? 1 : 0
		set nowrap
		exe 'normal '.(s:visual_width - l:no_cols_after_cursor_in_win -1).'zl'
	endif


	let s:buf = nvim_create_buf(v:false, v:true)
	call nvim_buf_set_lines(s:buf, 0, -1, v:true, g:rightclick_visual_items)
    call nvim_open_win(s:buf, v:true, s:visual_buf_opts)
	stopinsert
	let g:rightclick_window_id = win_getid()
	" setlocal winhl=Normal:Pmenu,CursorLine:PmenuSel
	setlocal winhl=Normal:Floating
	" setlocal cursorline
	normal jl

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
				\:if(g:rightclick_enable_wrap_later)
				\\| set wrap
				\\| let g:rightclick_enable_wrap_later = 0
				\\|endif<CR>

	noremap <buffer> <silent> <Enter> :let g:rightclick_command_number = getcurpos()[1]<CR>
				\:let g:rightclick_new_window_id = win_getid()<CR>
				\:call nvim_win_close(g:rightclick_window_id, 1)<CR>
				\:if(g:rightclick_new_window_id == rightclick_window_id)
				\\| let @z = g:rightclick_visual_macros[g:rightclick_command_number-1]
				\\|endif<CR>
				\gv@z
				\:let @z = g:rightclick_visual_z_reg_backup<CR>
				\:if(g:rightclick_enable_wrap_later)
				\\| set wrap
				\\| let g:rightclick_enable_wrap_later = 0
				\\|endif<CR>

	nnoremap <buffer> <silent> <Esc> :bw<CR>
				\:let @z = g:rightclick_visual_z_reg_backup<CR>
				\:if(g:rightclick_enable_wrap_later)
				\\| set wrap
				\\| let g:rightclick_enable_wrap_later = 0
				\\|endif<CR>

	nnoremap <buffer> <silent> <RightMouse> <LeftMouse>
				\:call nvim_win_close(g:rightclick_window_id, 1)<CR>
				\:let @z = g:rightclick_visual_z_reg_backup<CR>
				\:if(g:rightclick_enable_wrap_later)
				\\| set wrap
				\\| let g:rightclick_enable_wrap_later = 0
				\\|endif<CR>
endfunction
