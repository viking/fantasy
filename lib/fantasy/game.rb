class Fantasy
  class Game
    class BoxScore
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
          <tr\sclass="ysprow\d"\salign="right">[\s\n]+
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

      def self.parse(*args)
        bs = new(*args)
        bs.pbp_url
      end

      attr_reader :pbp_url
      def initialize(body, game)
        @body = body
        @game = game
        parse_body
        %r{<td><a href="(?<pbp>.+?)">Play by Play</a></td>} =~ body
        @pbp_url = pbp
      end

      def parse_body
        parse_scores
        parse_stats
      end

      def parse_scores
        which = :away
        pos   = 0
        md    = nil
        2.times do
          md = SCORING_RE.match(@body, pos); pos = md.begin(0) + 1
          name = md[:team_name]
          md = SCORING_RE.match(@body, pos); pos = md.begin(0) + 1
          @game.add_team(which, name, md[:score_value])
          which = :home
        end
      end

      def parse_stats
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
              team = team.nil? ? :away : :home
              headers = md[:team_headers].scan(/>([\w\d\/]+)(?:&nbsp;)?</)
              headers.flatten!
            when md[:player_name]
              name = defense ? "Defense" : md[:player_name]
              stats = md[:player_stats].scan(/>(\d+(?:\.\d+)?)(?:&nbsp;)?</)
              stats.flatten!
              @game.add_stats(team, name, type, stats.zip(headers))
          end
          md = PARSING_RE.match(@body, pos+1)
          pos = md ? md.begin(0) : nil
        end
      end
    end

    class PlayByPlay
      FG_RE = %r!
        (?<team>
          <th\sclass="l"\scolspan="3">[\s\n]+
            (?<team_name> [\w\s\.]+? )\n\s+
            -\s\d+:\d+[\s\n]+
          </th>
        ){0}
        (?<fg>
          <td\svalign="top">
            (?<player_name>[\w\s\.\-']+)\s
            (?<result>kicked|missed)\sa\s
            (?<yards>\d+)-yard\sfield\sgoal
          </td>
        ){0}
        (?<pat>
          (?<player_name>[\w\s\.\-']+)\s
          (?<result>made|missed)\s
          PAT
        ){0}

        (?:\g<team>|\g<fg>|\g<pat>)
      !x
      def self.parse(*args)
        new(*args)
      end

      def initialize(body, game)
        @body = body
        @game = game
        parse_body
      end

      def parse_body
        team = nil
        md   = FG_RE.match(@body); pos = md ? md.begin(0) : nil
        while pos
          if md[:team]
            team = md[:team_name]
          else
            player = md[:player_name]
            if md[:fg] then
              type = md[:result] == "kicked" ? "FGMade" : "FGMissed"
              num  = md[:yards]
            else
              type = md[:result] == "made" ? "XPMade" : "XPMissed"
              num  = 1
            end
            @game.add_stats(team, player, "Kicking", [[num, type]])
          end
          md = FG_RE.match(@body, pos+1)
          pos = md ? md.begin(0) : nil
        end
      end
    end

    def initialize(url, config)
      @config = config
      @teams  = {}
      config.fetcher.fetch(url) do |body|
        pbp = BoxScore.parse(body, self)
        config.fetcher.fetch(pbp) do |pbp|
          PlayByPlay.parse(pbp, self)
        end
      end
    end

    def home_team
      @teams[:home]
    end

    def away_team
      @teams[:away]
    end

    def add_team(which, name, score)
      @teams[which] = t = Team.new(name)
      t.score = score.to_i
      if @teams.length == 2
        @teams[:home].add(p = Player.new('Defense', @config))
        p.via("Defense").add(@teams[:away].score, "PtsAllowed")
        @teams[:away].add(p = Player.new('Defense', @config))
        p.via("Defense").add(@teams[:home].score, "PtsAllowed")
      end
    end

    def add_stats(which, name, category, stats)
      team = case which
             when Symbol then @teams[which]
             else
               @teams[:home].name == which ? @teams[:home] : @teams[:away]
             end
      player = team.find_player(name)
      unless player
        team.add(player = Player.new(name, @config))
      end
      player.via(category).add(stats)
    end
  end
end
