function! SetMark()
  let keycode = getchar()
  let keystr = nr2char(keycode)
  let upper = toupper(keystr)
  execute 'norm! mark ' . keystr
  execute 'norm! redraw'
endfunction

function! DelMark()
  let keycode = getchar()
  let keystr = nr2char(keycode)
  " Ideavim only supports upper case marks so
  " ensure our pressed key is uppercase
  " let upper = toupper(keystr)
  execute 'norm! delmark ' . keystr
  execute 'norm! redraw'
endfunction

function! DelAllMarks()
  execute 'delmarks!'
  execute 'norm! redraw'
endfunction

function! JumpToMark()
  let keycode = getchar()
  let keystr = nr2char(keycode)
  " Ideavim only supports upper case marks so
  " ensure our pressed key is uppercase
  " let upper = toupper(keystr)
  execute 'norm! `' . keystr
endfunction

