CREATE TABLE IF NOT EXISTS players( 
    name VARCHAR(10) NOT NULL, PRIMARY KEY (name),
    password VARCHAR(20),
    kills INT,
    deaths INT,
    last_played_ts INT,
    player_id VARCHAR(50),
    created_on VARCHAR(50),
    created_ts INT)
    DEFAULT CHARSET=utf8,
    ENGINE=InnoDB,
    DEFAULT COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS servers( 
    name VARCHAR(20) NOT NULL, PRIMARY KEY(hostname),
    hostname VARCHAR(50),
    up boolean,
    created_ts INT)
    DEFAULT CHARSET=utf8,
    ENGINE=InnoDB,
    DEFAULT COLLATE=utf8_general_ci;
