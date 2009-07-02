# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fantasy}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Stephens"]
  s.date = %q{2009-07-02}
  s.email = %q{viking415@gmail.com}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    ".gitignore",
     "README",
     "Rakefile",
     "TODO",
     "examples/ichi.rb",
     "lib/fantasy.rb",
     "lib/fantasy/config.rb",
     "lib/fantasy/fetcher.rb",
     "lib/fantasy/game.rb",
     "lib/fantasy/player.rb",
     "lib/fantasy/scoreboard.rb",
     "lib/fantasy/team.rb",
     "script/server",
     "test/fantasy/test_fetcher.rb",
     "test/fantasy/test_game.rb",
     "test/fantasy/test_player.rb",
     "test/fantasy/test_scoreboard.rb",
     "test/fantasy/test_team.rb",
     "test/fixtures/html/bar.txt",
     "test/fixtures/html/foo.txt",
     "test/fixtures/html/nfl/boxscore_000.html",
     "test/fixtures/html/nfl/boxscore_001.html",
     "test/fixtures/html/nfl/boxscore_002.html",
     "test/fixtures/html/nfl/boxscore_003.html",
     "test/fixtures/html/nfl/boxscore_004.html",
     "test/fixtures/html/nfl/boxscore_005.html",
     "test/fixtures/html/nfl/boxscore_006.html",
     "test/fixtures/html/nfl/boxscore_007.html",
     "test/fixtures/html/nfl/boxscore_008.html",
     "test/fixtures/html/nfl/boxscore_009.html",
     "test/fixtures/html/nfl/boxscore_010.html",
     "test/fixtures/html/nfl/boxscore_011.html",
     "test/fixtures/html/nfl/boxscore_012.html",
     "test/fixtures/html/nfl/boxscore_013.html",
     "test/fixtures/html/nfl/mini-scoreboard.html",
     "test/fixtures/html/nfl/playbyplay_000.html",
     "test/fixtures/html/nfl/playbyplay_001.html",
     "test/fixtures/html/nfl/playbyplay_002.html",
     "test/fixtures/html/nfl/playbyplay_003.html",
     "test/fixtures/html/nfl/playbyplay_004.html",
     "test/fixtures/html/nfl/playbyplay_005.html",
     "test/fixtures/html/nfl/playbyplay_006.html",
     "test/fixtures/html/nfl/playbyplay_007.html",
     "test/fixtures/html/nfl/playbyplay_008.html",
     "test/fixtures/html/nfl/playbyplay_009.html",
     "test/fixtures/html/nfl/playbyplay_010.html",
     "test/fixtures/html/nfl/playbyplay_011.html",
     "test/fixtures/html/nfl/playbyplay_012.html",
     "test/fixtures/html/nfl/playbyplay_013.html",
     "test/fixtures/html/nfl/scoreboard.html",
     "test/test_fantasy.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/viking/fantasy}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.0")
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Fantasy football aggregator (Ruby 1.9)}
  s.test_files = [
    "test/test_fantasy.rb",
     "test/test_helper.rb",
     "test/fantasy/test_player.rb",
     "test/fantasy/test_team.rb",
     "test/fantasy/test_game.rb",
     "test/fantasy/test_fetcher.rb",
     "test/fantasy/test_scoreboard.rb",
     "examples/ichi.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<curb>, [">= 0"])
    else
      s.add_dependency(%q<curb>, [">= 0"])
    end
  else
    s.add_dependency(%q<curb>, [">= 0"])
  end
end
