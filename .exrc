let g:vigun_extra_keywords = ['test']

let g:vigun_commands = [
      \ {
      \   'pattern': 'test/.*_test.rb$',
      \   'normal': 'rails test',
      \   'debug': 'BACKTRACE=1 rails test',
      \ }
      \]
