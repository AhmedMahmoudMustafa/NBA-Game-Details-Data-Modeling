# NBA Game Details Data Modeling

## Overview

This project focuses on modeling NBA game details data to create a fact table suitable for analysis. The primary goal is to transform raw game details data into a `fact_game_details` table, addressing data duplication and deriving relevant metrics.

This project demonstrates the process of fact table creation, data deduplication, and basic data analysis using SQL.

## Key Concepts Demonstrated

* **Fact Table Creation:** Designing and implementing a fact table to store measures related to NBA game details.
* **Data Deduplication:** Using window functions (ROW_NUMBER) to remove duplicate records from the source data.
* **Data Transformation:** Deriving new columns and transforming existing data types to create meaningful metrics.
* **Data Analysis:** Performing basic analysis on the fact table to gain insights into player participation and "bailing" (not playing with the team).

## Dataset

The project utilizes data from two tables:

* **`game_details`:** Contains detailed information about individual player performance in each game.
* **`games`:** Contains general information about each game, such as game date and home team ID.

## Data Model

The project involves the creation of one fact table:

1.  **`fact_game_details` Table:**

    * This table stores measures related to NBA game details at the player level.
    * It includes the following columns:
        * `dim_game_date`: Date of the game.
        * `dim_season`: Season of the game.
        * `dim_is_playing_at_home`: Boolean indicating whether the player's team was the home team.
        * `dim_game_id`: Unique identifier for the game.
        * `dim_team_id`: Unique identifier for the team.
        * `dim_player_id`: Unique identifier for the player.
        * `dim_player_name`: Name of the player.
        * `dim_start_position`: Player's starting position.
        * `dim_did_not_play`: Boolean indicating if the player did not play.
        * `dim_did_not_dress`: Boolean indicating if the player did not dress.
        * `dim_did_not_with_team`: Boolean indicating if the player was did not with team.
        * `m_minutes`: Minutes played by the player.
        * `m_fgm`: Field goals made.
        * `m_fga`: Field goals attempted.
        * `m_fg3m`: 3-point field goals made.
        * `m_fg3a`: 3-point field goals attempted.
        * `m_ftm`: Free throws made.
        * `m_fta`: Free throws attempted.
        * `m_oreb`: Offensive rebounds.
        * `m_dreb`: Defensive rebounds.
        * `m_ast`: Assists.
        * `m_stl`: Steals.
        * `m_blk`: Blocks.
        * `m_turnovers`: Turnovers.
        * `m_pf`: Personal fouls.
        * `m_pts`: Points.
        * `m_plus_minus`: Plus-minus.
    * The primary key for this table is (`dim_game_date`, `dim_player_id`, `dim_team_id`).

## Queries

The project includes the following SQL queries:

1.  **Fact Table Population Query:**

    * Uses a Common Table Expression (CTE) called `deduped` to remove duplicate records from the `game_details` table based on `game_id`, `player_id`, and `team_id`.
    * Selects and transforms data from the `deduped` CTE to populate the `fact_game_details` table.
    * Derives columns such as `dim_is_playing_at_home`, `dim_did_not_play`, `dim_did_not_dress`, `dim_did_not_with_team`, and `m_minutes`.

2.  **`fact_game_details` Table Creation Query:**

    * Creates the `fact_game_details` table with the specified columns and data types.

3.  **Analysis Query:**

    * Performs an analysis on the `fact_game_details` table to calculate:
        * The number of games played by each player.
        * The number of times each player "bailed" (did not play with the team).
        * The percentage of times each player "bailed."
    * Groups the results by `dim_player_name` and orders them by the "bail" percentage in descending order.

## Business Impact

This project demonstrates how data modeling can be used to create a fact table that supports analysis of NBA game details.

* **Data Deduplication and Accuracy:** The project addresses the issue of data duplication, ensuring the accuracy and reliability of the `fact_game_details` table for analysis.
* **Performance Analysis:** The fact table provides a structured format for analyzing player performance metrics, such as points, rebounds, assists, and minutes played.
* **Player Availability Analysis:** The project derives columns related to player availability (`dim_did_not_play`, `dim_did_not_dress`, `dim_did_not_with_team`), enabling analysis of player absences and their reasons.
* **Game Context Analysis:** The inclusion of `dim_game_date`, `dim_season`, and `dim_is_playing_at_home` allows for analysis of player performance within the context of specific games and seasons.
* **Insights into Player Behavior:** The analysis query provides insights into player behavior, such as the frequency with which players "bail" (do not play with the team).
