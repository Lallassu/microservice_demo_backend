class BadSanta
    def initialize
        @db = Mysql2::Client.new(:host => ENV['HOST_IP'],
                                 :username => "game_", 
                                 :password => "game_",
                                 :database => "badsanta")
    end

    def close
        @db.close
    end

    def register_server(name, hostname)
        q = @db.prepare("replace into servers set created_ts = unix_timestamp(), name = ?, hostname = ?")
        q.execute(name, hostname)
        # Just some cleanup
        q = @db.prepare("delete from servers where unix_timestamp()-created_ts > 60")
        q.execute()
    end

    def update_db(params)
        query = "";

        if params["type"] == "0" 
            query = "update players set kills = kills + 1 where player_id = ?";
        elsif params["type"] == "1"
            query = "update players set deaths = deaths + 1 where player_id = ?";
        elsif params["type"] == "2"
            query = "update players set last_played_ts = unix_timestamp() where player_id = ?"; 
        end
        ap "QUERY: #{query}"
        ap "ID: #{params["id"]}, Type: #{params["type"]}"
        q = @db.prepare(query)
        q.execute(params["id"])
    end

    def auth_user(id)
        q = @db.prepare('select player_id, name from players where player_id = ?')
        res = q.execute(id)
        if res.count > 0
            return { :name => res.first["name"] }
        end
        return { :error => "Not logged in." }
    end

    def login(user, pass) 
        if user == "" || pass == ""
            return {:status => false}
        end

        hostname = `hostname`

        id = 0
        q = @db.prepare('select * from players where name = ? and password = ?')
        res = q.execute(user, pass)
        kills = 0
        deaths = 0
        last_played_ts = 0
        created_ts = 0
        if res.count > 0
            id = SecureRandom.hex
            kills = res.first["kills"]
            deaths = res.first["deaths"]
            created_ts = DateTime.strptime("#{res.first["created_ts"]}",'%s').strftime("%Y-%m-%d %H:%M:%S")
            last_played_ts = DateTime.strptime("#{res.first["last_played_ts"]}",'%s').strftime("%Y-%m-%d %H:%M:%S")
        else 
            # New user?
            q = @db.prepare('select name from players where name = ?')
            res = q.execute(user)
            if res.count == 0
                id = SecureRandom.hex
                q = @db.prepare('insert into players set created_on = ?, name = ?, password = ?, kills = 0, deaths = 0, created_ts = unix_timestamp(), last_played_ts = unix_timestamp()')
                q.execute(hostname, user, pass)
            end
        end
        if id != 0
            q = @db.prepare('update players set player_id = ? where name = ?')
            q.execute(id, user)
            close
            return {:status => true, :id => id, :kills => kills, :deaths => deaths, :last_played => last_played_ts, :created => created_ts}
        end
        close
        return {:status => false}
    end

    def servers
        q = @db.prepare('select name, hostname, unix_timestamp()-created_ts as last_seen from servers where unix_timestamp()-created_ts < 6')
        res = q.execute
        servers = []
        res.each do |r|
            servers.push(r)
        end
        close
        return servers
    end

    def toplist
        q = @db.prepare('select created_on, name, kills, deaths, last_played_ts, created_ts from players order by kills desc limit 20')
        res = q.execute
        players = []
        res.each do |r|
            r["last_played"] = DateTime.strptime("#{r["last_played_ts"]}", "%s").strftime("%Y-%m-%d %H:%M:%S")
            r["created"] = DateTime.strptime("#{r["created_ts"]}", "%s").strftime("%Y-%m-%d %H:%M:%S")
            players.push(r)
        end
        close
        return players
    end
end

