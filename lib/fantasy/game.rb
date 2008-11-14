class Fantasy
  class Game
    SCORING_RE = %r!
      (?<score>
        <td\salign="right"\sclass="ysptblclbg6\stotal">[\s\n]+
          <span\sclass="yspscores">
            (?:<b>)? (?<score_value>\d+) (?:</b>)?
          &nbsp;</span>[\s\n]+
        </td>
      ){0}
      (?<team>
        <td\salign="left"\sclass="yspscores\steam">[\s\n]+
          <b><a\shref="/nfl/teams/\w+">
            (?<team_name> [\w\s\.]+ )
          </a></b>[\s\n]+
        </td>
      ){0}

      (?:\g<team>|\g<score>)
    !x

    # this regex owns you; it will match type, team, and player
    PARSING_RE = %r!
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

    def initialize(body, config)
      @body   = body
      @config = config
      @teams  = {}
      setup_teams
      setup_defenses
      parse_body
    end

    def home_team
      @teams[:home]
    end

    def away_team
      @teams[:away]
    end

    def setup_teams
      which = :away
      pos   = 0
      md    = nil
      2.times do
        md = SCORING_RE.match(@body, pos); pos = md.begin(0) + 1
        @teams[which] = t = Team.new(md[:team_name])
        md = SCORING_RE.match(@body, pos); pos = md.begin(0) + 1
        t.score = md[:score_value].to_i
        which = :home
      end
    end

    def setup_defenses
      @teams[:home].add(p = Player.new("Defense", @config))
      p.via("Defense").add(@teams[:away].score, "PtsAllowed")
      @teams[:away].add(p = Player.new("Defense", @config))
      p.via("Defense").add(@teams[:home].score, "PtsAllowed")
    end

    def parse_body
      type, team, headers = nil
      md  = PARSING_RE.match(@body, 0)
      pos = md ? md.begin(0) : nil
      defense = false
      while pos
        case
          when md[:type_name]
            team = nil
            type = md[:type_name]
            case type
            when "Defense", "Kick/Punt Returns"
              defense = true
            else
              defense = false
            end
          when md[:team_name]
            team = @teams[team.nil? ? :away : :home]
            headers = md[:team_headers].scan(/>([\w\d\/]+)(?:&nbsp;)?</)
            headers.flatten!
          when md[:player_name]
            name = defense ? "Defense" : md[:player_name]
            player = team.find_player(name)
            unless player
              player = Player.new(name, @config)
              team.add(player)
            end
            stats = md[:player_stats].scan(/>(\d+(?:\.\d+)?)(?:&nbsp;)?</)
            stats.flatten!
            stats.each_with_index do |stat, i|
              player.via(type).add(stat, headers[i])
            end
        end
        md = PARSING_RE.match(@body, pos+1)
        pos = md ? md.begin(0) : nil
      end
    end
  end
end
