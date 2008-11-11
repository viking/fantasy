class Fantasy
  class Game
    # this regex owns you; it will match type, team, and player
    @@parsing_re = %r!
      (?<type>
        <tr\sclass="yspsctbg">[\s\n]+
        <td.+class="ysptblhdr">
          &nbsp;
          (?<type_name>
            Passing | Rushing | Receiving | Kicking | Punting |
            Kick/Punt\sReturns | Defense
          )
        </td>
      ){0}
      (?<team>
        <tr\sclass="ysptblthbody1"\salign="right">[\s\n]+
          <td.+class="yspdetailttl\sfirst"\salign="left">
            &nbsp; (?<team_name> [\w\s\.]+ )
          </td>[\s\n]+
          (?<team_headers>
          (?:
          <td.+class="yspdetailttl">[\w\d/]+(?:&nbsp;)?</td>[\s\n]+
          )+
          )
        </tr>
      ){0}
      (?<player>
        <tr\sclass="ysprow1"\salign="right">[\s\n]+
          <td\sclass="first"\salign="left">
            &nbsp; (?<player_name> [\w\s\.\-']+ )
          </td>[\s\n]+
          (?<player_stats>
          (?:
          <td>
            \d+(?:\.\d+)?(?:&nbsp;)?
          </td>[\s\n]+
          )+
          )
        </tr>
      ){0}

      (?:\g<type>|\g<team>|\g<player>)
    !x

    attr_reader :home_team, :away_team
    def initialize(body)
      @body = body
      parse_body
    end

    def parse_body
      type, team, headers = nil
      pos, md = @@parsing_re.matchn(@body, 0)
      while pos
        case
          when md[:type_name]
            type = md[:type_name]
            team = nil
            puts "Type: #{type}"  if $DEBUG
          when md[:team_name]
            puts "  Team: #{md[:team_name]}"  if $DEBUG
            if team.nil?
              team = @away_team ||= Team.new(md[:team_name])
            else
              team = @home_team ||= Team.new(md[:team_name])
            end
            headers = md[:team_headers].scan(/>([\w\d\/]+)(?:&nbsp;)?</)
            headers.flatten!
          when md[:player_name]
            name = md[:player_name]
            puts "    Player: #{name}"  if $DEBUG
            player = team.find_player(name)
            unless player
              player = Player.new(name)
              team.add(player)
            end
            stats = md[:player_stats].scan(/>(\d+(?:\.\d+)?)(?:&nbsp;)?</)
            stats.flatten!
            stats.each_with_index do |stat, i|
              player.via(type).had(stat, headers[i])
            end
        end
        pos, md = @@parsing_re.matchn(@body, pos+1)
      end
    end
  end
end
