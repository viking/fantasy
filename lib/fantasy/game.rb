class Fantasy
  class Game
    @@type_re = %r{<td.+class="ysptblhdr">&nbsp;(?<type>Passing)}
    @@team_re = %r{<td.+class="yspdetailttl first".+>&nbsp;(?<team>[\w\s]+)</td>}

    attr_reader :home_team, :away_team
    def initialize(body)
      @body = body

      set_teams
      create_players
    end

    def set_teams
      # <td class="yspsctnhdln">
      #   <a href="/nfl/teams/ten">Tennessee</a> 19,
      #   <a href="/nfl/teams/gnb">Green Bay</a> 16
      %r{
        <td\sclass="yspsctnhdln">[\s\n]+
        <a\shref="/nfl/teams/\w{3}">(?<home>[\w\s]+)</a>\s+\d+,[\s\n]+
        <a\shref="/nfl/teams/\w{3}">(?<away>[\w\s]+)</a>
      }x =~ @body
      @home_team = Team.new(home)
      @away_team = Team.new(away)
    end

    def create_players
      #<table width="100%" border="0" cellspacing="0" cellpadding="0" class="yspwhitebg">
      # <tr class="yspsctbg">
      #	  <td width="24%" height="18" class="ysptblhdr">&nbsp;Passing</td>
      pos, md = @@type_re.matchn(@body, 0)
      while pos
        pos, md = @@type_re.matchn(@body, pos+1)
      end
    end
  end
end
