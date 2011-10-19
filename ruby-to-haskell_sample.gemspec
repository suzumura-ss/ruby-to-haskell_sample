spec = Gem::Specification.new do |s|
  s.name = 'ruby-to-haskell_sample'
  s.version = '0.0.1'
  s.has_rdoc = false
  s.extra_rdoc_files = %w(README LICENSE)
  s.summary = 'Haskell-extension sample.'
  s.description = s.summary
  s.author = 'Toshiyuki Suzumura'
  s.email = 'Twitter: @suzumura_ss'
  s.files = %w(README LICENSE) + Dir.glob("{ext,lib}/**/*")
  s.require_path = 'lib'
  s.extensions = %w(ext/extconf.rb)
end
