name = "pru"
require "./lib/#{name}/version"

Gem::Specification.new name, Pru::VERSION do |s|
  s.summary = "Pipeable Ruby - forget about grep / sed / awk / wc ... use pure, readable Ruby!"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.required_ruby_version = '>= 2.0.0'
  s.files = `git ls-files lib`.split("\n")
  s.license = "MIT"
  s.executables = ["pru"]
  # 2.6 because that is sadly what is available by default on macs
  s.required_ruby_version = '>= 2.6' # must match lowest in .github/workflows/actions.yml
end
