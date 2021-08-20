let g:vigun_test_keywords = ['test', 'it', 'context', 'describe']
let g:vjs_tags_enabled = 0

fun! s:watch(cmd)
  return "rg --files | entr -r -c sh -c 'echo ".escape('"'.a:cmd.'"', '"')." && ".a:cmd."'"
endf

let g:vigun_mappings = [
        \ {
        \   'pattern': 'test/.*_test.rb$',
      \   'all': 'rails test #{file}',
      \   'nearest': 'rails test #{file}:#{line}',
      \   'watch-all': s:watch('rails test #{file}'),
      \   'watch-nearest': s:watch('rails test #{file}:#{line}'),
      \ },
      \ {
        \   'pattern': 'test/javascript/.*_test.js$',
      \   'all': 'yarn test #{file}',
      \   'nearest': 'yarn test --fgrep #{nearest_test} #{file}',
      \   'debug-all': 'yarn test --interactive #{file}',
      \   'debug-nearest': 'yarn test --interactive --fgrep #{nearest_test} #{file}',
      \ }
      \]

command! -nargs=0 Fixturex :cexpr system('./bin/fixturex.rb '. expand('%:t:r') .' '.shellescape(expand('<cword>'))) | copen

" open report fixture in a split to the right
" nnoremap gj :exec "botright vnew
" test/fixtures/reports/".expand('<cword>').".json"<cr>
