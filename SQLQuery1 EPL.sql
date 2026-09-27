select * from epl_final

-------------------Total matches played 
SELECT COUNT(*) AS total_matches
FROM epl_final

----------------Duplicate
SELECT
    Season,
    MatchDate,
    HomeTeam,
    AwayTeam,
    COUNT(*) AS match_count
FROM epl_final
GROUP BY
    Season,
    MatchDate,
    HomeTeam,
    AwayTeam
HAVING COUNT(*) > 1;


-------------Home Teams
SELECT DISTINCT HomeTeam
FROM epl_final
ORDER BY HomeTeam;


-----------------Away Team
SELECT DISTINCT AwayTeam
FROM epl_final
ORDER BY AwayTeam;



---------------match year

SELECT
    MatchDate,
    YEAR(MatchDate) AS MatchYear
FROM epl_final;

SELECT
    YEAR(MatchDate) AS MatchYear,
    MatchDate,
    HomeTeam,
    AwayTeam,
    FullTimeResult
FROM epl_final;


----------total goals 
SELECT *, 
      FullTimeHomeGoals + FullTimeAwayGoals AS TotalGoals
   
   FROM epl_final
    

    SELECT
    SUM(FullTimeHomeGoals + FullTimeAwayGoals) AS TotalGoals
FROM epl_final;

-----------------total goals by season 

SELECT
    Season,
    SUM(FullTimeHomeGoals + FullTimeAwayGoals) AS TotalGoals
FROM epl_final
GROUP BY Season
ORDER BY Season;

-----------------home and away goals by teams 


SELECT
    Team,
    SUM(GoalsFor) AS TotalGoals
FROM
(
    SELECT
        HomeTeam AS Team,
        FullTimeHomeGoals AS GoalsFor
    FROM epl_final

    UNION ALL

    SELECT
        AwayTeam AS Team,
        FullTimeAwayGoals AS GoalsFor
    FROM epl_final
) AS TeamGoals

GROUP BY Team
ORDER BY TotalGoals DESC;

---------------total shots
SELECT

     SUM(HomeShots + AwayShots) AS TotalShots
FROM epl_final


---------------Total shots on target
SELECT
     SUM(HomeShotsOnTarget + AwayShotsOnTarget) AS TotalShotsOnTarget
FROM epl_final
ELECT

---------------Total Fouls
SELECT

     SUM(HomeFouls + AwayFouls) AS TotalFouls
FROM epl_final


---------------Total Yellow cards 

SELECT

     SUM(HomeYellowCards + AwayYellowCards) AS TotalYellowCards
FROM epl_final


----------------total red cards
SELECT

     SUM(HomeRedCards + AwayRedCards) AS TotalRedCards
FROM epl_final

--------------------------shots conversion

SELECT
    
    CASE
        WHEN HomeShots > 0
        THEN CAST(FullTimeHomeGoals AS DECIMAL(10,2))
             / HomeShots
        ELSE 0
    END AS home_shot_conversion,

    CASE
        WHEN AwayShots > 0
        THEN CAST(FullTimeAwayGoals AS DECIMAL(10,2))
             / AwayShots
        ELSE 0
    END AS away_shot_conversion
FROM epl_final

----------------------creating Goals point home and away
SELECT
    CASE

    WHEN FullTimeResult = 'H' THEN 3
    WHEN FullTimeResult = 'D' THEN 1
    ELSE 0
END AS home_points
 FROM epl_final


 SELECT
    CASE

    WHEN FullTimeResult = 'A' THEN 3
    WHEN FullTimeResult = 'D' THEN 1
    ELSE 0
END AS Away_points
 FROM epl_final


 ---------------create away, home and draw wins
 
 SELECT
    CASE

    WHEN FullTimeResult = 'H' THEN 'Win'
    WHEN FullTimeResult = 'D' THEN 'Draw'
    
END AS HomeResults
 FROM epl_final

  SELECT
    CASE

    WHEN FullTimeResult = 'A' THEN 'Win'
    WHEN FullTimeResult = 'D' THEN 'Draw'
    
END AS AwayResults
 FROM epl_final


 SELECT
    CASE
    
    WHEN FullTimeResult = 'H' THEN 'Win'
    WHEN FullTimeResult = 'A' THEN 'Win'
    WHEN FullTimeResult = 'D' THEN 'Draw'
    
END AS MatchResult
 FROM epl_final


 -----------------------create a team level table


 SELECT
    Season,
    MatchDate,
    HomeTeam AS team,
    AwayTeam AS opponent,
    'Home' AS venue,

    FullTimeHomeGoals AS goals_for,
    FullTimeAwayGoals AS goals_against,

    CASE
        WHEN FullTimeResult = 'H' THEN 3
        WHEN FullTimeResult = 'D' THEN 1
        ELSE 0
    END AS points,

    CASE
        WHEN FullTimeResult = 'H' THEN 'W'
        WHEN FullTimeResult = 'D' THEN 'D'
        ELSE 'L'
    END AS result,

    HomeShots AS shots,
    HomeShotsOnTarget AS shots_on_target,
    HomeCorners AS corners,
    HomeFouls AS fouls,
    HomeYellowCards AS yellow_cards,
    HomeRedCards AS red_cards

FROM epl_final

UNION ALL

SELECT
    Season,
    MatchDate,
    AwayTeam AS team,
    HomeTeam AS opponent,
    'Away' AS venue,

    FullTimeAwayGoals AS goals_for,
    FullTimeHomeGoals AS goals_against,

    CASE
        WHEN FullTimeResult = 'A' THEN 3
        WHEN FullTimeResult = 'D' THEN 1
        ELSE 0
    END AS points,

    CASE
        WHEN FullTimeResult = 'A' THEN 'W'
        WHEN FullTimeResult = 'D' THEN 'D'
        ELSE 'L'
    END AS result,

    AwayShots AS shots,
    AwayShotsOnTarget AS shots_on_target,
    AwayCorners AS corners,
    AwayFouls AS fouls,
    AwayYellowCards AS yellow_cards,
    AwayRedCards AS red_cards

FROM epl_final;

------------------------League Table

WITH team_matches AS (

    SELECT
        Season,
        HomeTeam AS team,
        AwayTeam AS opponent,

        FullTimeHomeGoals AS goals_for,
        FullTimeAwayGoals AS goals_against,

        CASE
            WHEN FullTimeResult = 'H' THEN 3
            WHEN FullTimeResult = 'D' THEN 1
            ELSE 0
        END AS points,

        CASE
            WHEN FullTimeResult = 'H' THEN 'W'
            WHEN FullTimeResult = 'D' THEN 'D'
            ELSE 'L'
        END AS result

    FROM epl_final

    UNION ALL

    SELECT
        Season,
        AwayTeam AS team,
        HomeTeam AS opponent,

        FullTimeAwayGoals AS goals_for,
        FullTimeHomeGoals AS goals_against,

        CASE
            WHEN FullTimeResult = 'A' THEN 3
            WHEN FullTimeResult = 'D' THEN 1
            ELSE 0
        END AS points,

        CASE
            WHEN FullTimeResult = 'A' THEN 'W'
            WHEN FullTimeResult = 'D' THEN 'D'
            ELSE 'L'
        END AS result

    FROM epl_final
)

SELECT
    Season,
    team,

    COUNT(*) AS played,

    SUM(CASE WHEN result = 'W' THEN 1 ELSE 0 END) AS wins,

    SUM(CASE WHEN result = 'D' THEN 1 ELSE 0 END) AS draws,

    SUM(CASE WHEN result = 'L' THEN 1 ELSE 0 END) AS losses,

    SUM(goals_for) AS goals_for,

    SUM(goals_against) AS goals_against,

    SUM(goals_for) - SUM(goals_against) AS goal_difference,

    SUM(points) AS points

FROM team_matches

GROUP BY
    Season,
    team

ORDER BY
    Season,
    points DESC,
    goal_difference DESC,
    goals_for DESC;


----------------POINT PER MATCH 

SELECT
    Season,
    MatchDate,
    HomeTeam,
    AwayTeam,
    FullTimeResult,

    CASE
        WHEN FullTimeResult = 'H' THEN 3
        WHEN FullTimeResult = 'D' THEN 1
        ELSE 0
    END AS HomePoints,

    CASE
        WHEN FullTimeResult = 'A' THEN 3
        WHEN FullTimeResult = 'D' THEN 1
        ELSE 0
    END AS AwayPoints

FROM epl_final
ORDER BY
    Season,
    MatchDate;



    -----------------------------Team ranking
    SELECT
    Season,
    MatchDate,

    DENSE_RANK() OVER (
        PARTITION BY Season
        ORDER BY MatchDate
    ) AS Matchday,

    HomeTeam,
    AwayTeam,
    FullTimeResult,

    CASE
        WHEN FullTimeResult = 'H' THEN 3
        WHEN FullTimeResult = 'D' THEN 1
        ELSE 0
    END AS HomePoints,

    CASE
        WHEN FullTimeResult = 'A' THEN 3
        WHEN FullTimeResult = 'D' THEN 1
        ELSE 0
    END AS AwayPoints

FROM epl_final

ORDER BY
    Season,
    Matchday,
    MatchDate;


-------------------using all qwery to create a new dataset

WITH TeamMatches AS
(
    -- HOME TEAM
    SELECT
        Season,
        MatchDate,

        HomeTeam AS Team,
        AwayTeam AS Opponent,

        'Home' AS Venue,

        FullTimeHomeGoals AS GoalsFor,
        FullTimeAwayGoals AS GoalsAgainst,

        HomeShots AS Shots,
        HomeShotsOnTarget AS ShotsOnTarget,
        HomeCorners AS Corners,
        HomeFouls AS Fouls,

        CASE
            WHEN FullTimeResult = 'H' THEN 1
            ELSE 0
        END AS Wins,

        CASE
            WHEN FullTimeResult = 'D' THEN 1
            ELSE 0
        END AS Draws,

        CASE
            WHEN FullTimeResult = 'A' THEN 1
            ELSE 0
        END AS Losses,

        CASE
            WHEN FullTimeResult = 'H' THEN 3
            WHEN FullTimeResult = 'D' THEN 1
            ELSE 0
        END AS Points

    FROM epl_final


    UNION ALL


    -- AWAY TEAM
    SELECT
        Season,
        MatchDate,

        AwayTeam AS Team,
        HomeTeam AS Opponent,

        'Away' AS Venue,

        FullTimeAwayGoals AS GoalsFor,
        FullTimeHomeGoals AS GoalsAgainst,

        AwayShots AS Shots,
        AwayShotsOnTarget AS ShotsOnTarget,
        AwayCorners AS Corners,
        AwayFouls AS Fouls,

        CASE
            WHEN FullTimeResult = 'A' THEN 1
            ELSE 0
        END AS Wins,

        CASE
            WHEN FullTimeResult = 'D' THEN 1
            ELSE 0
        END AS Draws,

        CASE
            WHEN FullTimeResult = 'H' THEN 1
            ELSE 0
        END AS Losses,

        CASE
            WHEN FullTimeResult = 'A' THEN 3
            WHEN FullTimeResult = 'D' THEN 1
            ELSE 0
        END AS Points

    FROM epl_final
)

SELECT *
FROM TeamMatches
ORDER BY Season, MatchDate, Team;

-------------------match played table
WITH TeamMatches AS
(
    SELECT
        Season,
        MatchDate,
        HomeTeam AS Team,
        AwayTeam AS Opponent,
        'Home' AS Venue,

        FullTimeHomeGoals AS GoalsFor,
        FullTimeAwayGoals AS GoalsAgainst,

        HomeShots AS Shots,
        HomeCorners AS Corners,
        HomeFouls AS Fouls,

        CASE WHEN FullTimeResult = 'H' THEN 1 ELSE 0 END AS Wins,
        CASE WHEN FullTimeResult = 'D' THEN 1 ELSE 0 END AS Draws,
        CASE WHEN FullTimeResult = 'A' THEN 1 ELSE 0 END AS Losses,

        CASE
            WHEN FullTimeResult = 'H' THEN 3
            WHEN FullTimeResult = 'D' THEN 1
            ELSE 0
        END AS Points

    FROM epl_final

    UNION ALL

    SELECT
        Season,
        MatchDate,
        AwayTeam AS Team,
        HomeTeam AS Opponent,
        'Away' AS Venue,

        FullTimeAwayGoals AS GoalsFor,
        FullTimeHomeGoals AS GoalsAgainst,

        AwayShots AS Shots,
        AwayCorners AS Corners,
        AwayFouls AS Fouls,

        CASE WHEN FullTimeResult = 'A' THEN 1 ELSE 0 END,
        CASE WHEN FullTimeResult = 'D' THEN 1 ELSE 0 END,
        CASE WHEN FullTimeResult = 'H' THEN 1 ELSE 0 END,

        CASE
            WHEN FullTimeResult = 'A' THEN 3
            WHEN FullTimeResult = 'D' THEN 1
            ELSE 0
        END

    FROM epl_final
),

LeagueTable AS
(
    SELECT
        Season,
        Team,

        COUNT(*) AS MatchesPlayed,

        SUM(Wins) AS Wins,

        SUM(Draws) AS Draws,

        SUM(Losses) AS Losses,

        SUM(GoalsFor) AS GoalsFor,

        SUM(GoalsAgainst) AS GoalsAgainst,

        SUM(GoalsFor) - SUM(GoalsAgainst)
            AS GoalDifference,

        SUM(Points) AS TotalPoints,

        AVG(Shots) AS AvgShots,

        AVG(Corners) AS AvgCorners,

        AVG(Fouls) AS AvgFouls

    FROM TeamMatches

    GROUP BY
        Season,
        Team
)

SELECT
    *,
    
    RANK() OVER
    (
        PARTITION BY Season
        ORDER BY
            TotalPoints DESC,
            GoalDifference DESC,
            GoalsFor DESC
    ) AS TeamRank

FROM LeagueTable

ORDER BY
    Season,
    TeamRank;

-----------------home vs away analysis

WITH TeamVenue AS
(
    SELECT
        Season,
        HomeTeam AS Team,

        1 AS HomeMatches,

        CASE
            WHEN FullTimeResult = 'H' THEN 1
            ELSE 0
        END AS HomeWins,

        0 AS AwayMatches,

        0 AS AwayWins

    FROM epl_final

    UNION ALL

    SELECT
        Season,
        AwayTeam AS Team,

        0 AS HomeMatches,

        0 AS HomeWins,

        1 AS AwayMatches,

        CASE
            WHEN FullTimeResult = 'A' THEN 1
            ELSE 0
        END AS AwayWins

    FROM epl_final
)

SELECT
    Season,
    Team,

    SUM(HomeMatches) AS HomeMatches,
    SUM(HomeWins) AS HomeWins,

    SUM(AwayMatches) AS AwayMatches,
    SUM(AwayWins) AS AwayWins

FROM TeamVenue

GROUP BY
    Season,
    Team

ORDER BY
    Season,
    Team;
----------------------------------combining the new data into original dataset
SELECT *,
    Season,
    MatchDate,

    DENSE_RANK() OVER (
        PARTITION BY Season
        ORDER BY MatchDate
    ) AS Matchday,

    HomeTeam,
    AwayTeam,
    FullTimeResult,

    CASE
        WHEN FullTimeResult = 'H' THEN 3
        WHEN FullTimeResult = 'D' THEN 1
        ELSE 0
    END AS HomePoints,

    CASE
        WHEN FullTimeResult = 'A' THEN 3
        WHEN FullTimeResult = 'D' THEN 1
        ELSE 0
    END AS AwayPoints

FROM epl_final
---------------------------Stroing the newly created column into a the old epl
SELECT
    Season,
    MatchDate,

    DENSE_RANK() OVER (
        PARTITION BY Season
        ORDER BY MatchDate
    ) AS Matchday,

    HomeTeam,
    AwayTeam,
    FullTimeResult,

    CASE
        WHEN FullTimeResult = 'H' THEN 3
        WHEN FullTimeResult = 'D' THEN 1
        ELSE 0
    END AS HomePoints,

    CASE
        WHEN FullTimeResult = 'A' THEN 3
        WHEN FullTimeResult = 'D' THEN 1
        ELSE 0
    END AS AwayPoints

INTO EPL_New

FROM epl_final;


  
 SELECT * FROM EPL_New


 --------------------------COMBINING DATA

 SELECT
    Season,
    MatchDate,
    HomeTeam AS team,
    AwayTeam AS opponent,
    'Home' AS venue,

    FullTimeHomeGoals AS goals_for,
    FullTimeAwayGoals AS goals_against,

    CASE
        WHEN FullTimeResult = 'H' THEN 3
        WHEN FullTimeResult = 'D' THEN 1
        ELSE 0
    END AS points,

    CASE
        WHEN FullTimeResult = 'H' THEN 'W'
        WHEN FullTimeResult = 'D' THEN 'D'
        ELSE 'L'
    END AS result,

    HomeShots AS shots,
    HomeShotsOnTarget AS shots_on_target,
    HomeCorners AS corners,
    HomeFouls AS fouls,
    HomeYellowCards AS yellow_cards,
    HomeRedCards AS red_cards

    INTO EPL_Edit

FROM epl_final



SELECT * FROM  EPL_Edit 

