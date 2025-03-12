INSERT INTO fact_game_details
WITH deduped AS (
	SELECT  
		g.game_date_est,
		g.home_team_id,
		g.season,
		gd.*,
		ROW_NUMBER() OVER (PARTITION BY gd.game_id, player_id,team_id ORDER BY game_date_est) AS row_num
	FROM game_details gd JOIN games g
	ON gd.game_id = g.game_id
)
	
	
SELECT  game_date_est AS dim_game_date,
		season AS dim_season,
		home_team_id = team_id AS dim_is_playing_at_home,
		game_id AS dim_game_id,
		team_id AS dim_team_id,
		player_id AS dim_player_id,
		player_name AS dim_player_name,
		start_position AS dim_start_position,
		COALESCE(POSITION('DNP' IN comment), 0) > 0 AS dim_did_not_play,
		COALESCE(POSITION('DND' IN comment), 0) > 0 AS dim_did_not_dress,
		COALESCE(POSITION('NWT' IN comment), 0) > 0 AS dim_did_not_with_team,
		CAST(SPLIT_PART(min ,':' ,1) AS REAL)
			+ CAST(SPLIT_PART(min ,':' ,2) AS REAL)/60 AS m_minutes,
		fgm AS m_fgm,
		fga AS m_fga,
		fg3m AS m_fg3m,
		fg3a AS m_fg3a,
		ftm AS m_ftm,
		fta AS m_fta,
		oreb AS m_oreb,
		dreb AS m_dreb,
		ast AS m_ast,
		stl AS m_stl,
		blk AS m_blk,
		"TO" AS turnovers,
		pf AS m_pf,
		pts AS m_pts,
		plus_minus AS m_plus_minus
FROM deduped
where row_num = 1


CREATE TABLE fact_game_details (
		dim_game_date DATE,
		dim_season INTEGER,
		dim_is_playing_at_home BOOLEAN,
		dim_game_id INTEGER,
		dim_team_id INTEGER,
		dim_player_id INTEGER,
		dim_player_name TEXT,
		dim_start_position TEXT,
		dim_did_not_play BOOLEAN,
		dim_did_not_dress BOOLEAN,
		dim_did_not_with_team BOOLEAN,
		m_minutes REAL,
		m_fgm INTEGER,			
		m_fga INTEGER,
		m_fg3m INTEGER,			
		m_fg3a INTEGER,		
		m_ftm INTEGER,			
		m_fta INTEGER,			
		m_oreb INTEGER,			
		m_dreb INTEGER,			
		m_ast INTEGER,			
		m_stl INTEGER,			
		m_blk INTEGER,			
		m_turnovers INTEGER,	
		m_p INTEGER,			
		m_pts INTEGER,			
		m_plus_minus INTEGER,	
		PRIMARY KEY(dim_game_date, dim_player_id, dim_team_id)
)


SELECT dim_player_name,
	   COUNT(1) AS num_games,
	   COUNT(CASE WHEN dim_did_not_with_team THEN 1 END) AS most_bailed,
	   CAST(COUNT(CASE WHEN dim_did_not_with_team THEN 1 END) AS REAL)/COUNT(1) AS bail_prc
FROM fact_game_details
group by 1
ORDER BY 4 DESC