class Fantasy
  class Game
    # this regex owns you; it will match type, team, and player
    @@parsing_re = %r!
      (?<type>
        <tr\sclass="yspsctbg">[\s\n]+
        <td\swidth="\d+%"\sheight="18"\sclass="ysptblhdr">
          &nbsp; (?<type_name> [\w\s\\]+ )
        </td>
      ){0}
      (?<team>
        <tr\sclass="ysptblthbody1"\salign="right">[\s\n]+
          <td\sheight="18"\sclass="yspdetailttl\sfirst"\salign="left">
            &nbsp; (?<team_name> [\w\s]+ )
          </td>
      ){0}
      (?<player>
        <tr\sclass="ysprow1"\salign="right">[\s\n]+
          <td\sclass="first"\salign="left">
            &nbsp; (?<player_name> [\w\s\.\-']+ )
          </td>
      ){0}

      (?:\g<type>|\g<team>|\g<player>)
    !x

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
      type, team = nil
      pos, md = @@parsing_re.matchn(@body, 0)
      while pos
        case
          when md[:type_name]
            type = md[:type_name]
          when md[:team_name]
            team = team ? @home_team : @away_team
          when md[:player_name]
            name = md[:player_name]
            player = team.find_player(name)
            unless player
              player = Player.new(name)
              team.add(player)
            end
        end
        pos, md = @@parsing_re.matchn(@body, pos+1)
      end
    end
  end
end
