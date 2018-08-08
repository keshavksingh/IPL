
SELECT TOP 1 Season,Winner,MAX(WinnerCount) FROM (
SELECT DISTINCT Season,winner, COUNT(winner) OVER (Partition BY Season,winner ORDER BY Season) AS WinnerCount FROM matches)A
GROUP BY Season,Winner ORDER BY WinnerCount DESC
FROM matches GROUP BY Season,winner 


SELECT A1.Season,A1.MaXWinningTeam AS MaxMatchesWonBy,A1.WinnerCount,A2.IPLTournamentWinner FROM (
SELECT Season,Winner AS MaXWinningTeam, WinnerCount FROM (
SELECT Season,Winner, WinnerCount,ROW_NUMBER() OVER ( PARTITION BY Season ORDER BY Season,WinnerCount DESC) WinnerRank
FROM (
SELECT DISTINCT Season,winner, COUNT(winner) OVER (Partition BY Season,winner ORDER BY Season) AS WinnerCount FROM matches)A)B 
WHERE WinnerRank=1) A1
INNER JOIN 
(
SELECT m.Winner AS IPLTournamentWinner, m.Season FROM matches m INNER JOIN (
SELECT MAX(Id) AS FinalMatchId, Season FROM matches
GROUP BY Season) A 
ON m.Id=A.FinalMatchId) A2
ON A1.season=A2.season
ORDER BY A1.season 


ORDER BY Season,WinnerCount DESC\\\


use ipl;
SELECT A1.Season,A1.MaXWinningTeam AS MaxMatchesWonBy,A1.WinnerCount,A2.IPLTournamentWinner FROM (SELECT Season,Winner AS MaXWinningTeam, WinnerCount FROM (SELECT Season,Winner, WinnerCount,ROW_NUMBER() OVER ( PARTITION BY Season ORDER BY Season,WinnerCount DESC) WinnerRank FROM (SELECT DISTINCT Season,winner, COUNT(winner) OVER (Partition BY Season,winner ORDER BY Season) AS WinnerCount FROM matches)A)B WHERE WinnerRank=1) A1 INNER JOIN (SELECT m.Winner AS IPLTournamentWinner, m.Season FROM matches m INNER JOIN (SELECT MAX(Id) AS FinalMatchId, Season FROM matches GROUP BY Season) A  ON m.Id=A.FinalMatchId) A2 ON A1.season=A2.season ORDER BY A1.season 

--Impact of Toss on Winning Team
--Sum run scored by the winning team
SELECT * FROM matches where matches.id=66
SELECT * FROM deliveries

SELECT  A.TotalRuns AS TotalRunsOfWinningTeam,B.TotalRunsLoosingTeam,A.winner,A.season FROM (
SELECT SUM(d.total_runs) TotalRuns,d.match_id,m.winner,m.season FROM deliveries d INNER JOIN matches m ON d.match_id=m.id 
AND d.batting_team=m.winner
GROUP BY d.match_id,m.winner,m.season
)A
INNER JOIN (
SELECT SUM(d.total_runs) TotalRunsLoosingTeam,d.match_id,m.winner,m.season FROM deliveries d INNER JOIN matches m ON d.match_id=m.id 
AND d.batting_team= CASE WHEN m.winner=m.team1 THEN m.team2 ELSE m.team1 END
GROUP BY d.match_id,m.winner,m.season) B
ON A.match_id=B.match_id
ORDER BY A.season

SELECT SUM(d.total_runs) TotalRuns,m.winner,m.season FROM deliveries d INNER JOIN matches m ON d.match_id=m.id AND d.batting_team=m.winner GROUP BY d.match_id,m.winner,m.season ORDER BY m.season

SELECT  A.TotalRuns AS TotalRunsOfWinningTeam,B.TotalRunsLoosingTeam,A.winner,A.season FROM (SELECT SUM(d.total_runs) TotalRuns,d.match_id,m.winner,m.season FROM deliveries d INNER JOIN matches m ON d.match_id=m.id  AND d.batting_team=m.winner GROUP BY d.match_id,m.winner,m.season)A INNER JOIN (SELECT SUM(d.total_runs) TotalRunsLoosingTeam,d.match_id,m.winner,m.season FROM deliveries d INNER JOIN matches m ON d.match_id=m.id AND d.batting_team= CASE WHEN m.winner=m.team1 THEN m.team2 ELSE m.team1 END GROUP BY d.match_id,m.winner,m.season) B ON A.match_id=B.match_id ORDER BY A.season

--Impact of Toss

SELECT COUNT(*) Stats, 'TossWinnerIsMatchWinner' Situation FROM matches m  WHERE toss_winner=winner UNION ALL SELECT COUNT(*) C, 'TotalMatches' VAL FROM matches UNION ALL SELECT COUNT(*) C, 'TossWinnerIsMatchWinnerWhenChoseToBat' VAL FROM matches m  WHERE toss_winner=winner AND toss_decision='bat' UNION ALL SELECT COUNT(*) C, 'TossWinnerIsMatchWinnerrWhenChoseToField' VAL FROM matches m WHERE toss_winner=winner AND toss_decision='field'



--Look at Winning and Loosing Teams
-- 6,4,5,NoOfDistBowlersUSed, NoOfWicketsFell, TotalExtraRunGiven,TotalRunScored,RunRateMaintained
extra_runs
0


SELECT A.WinningTeam AS Team,A.TotalRunsAsWinningTeam,A.TotalBoundariesAsWinningTeam,A.TotalSixesAsWinningTeam,A.TotalExtraRunScoredAsWinningTeam
,B.TotalRunsAsLosingTeam,B.TotalBoundariesAsLosingTeam,B.TotalSixesAsLosingTeam,B.TotalExtraRunScoredAsLosingTeam FROM (
SELECT SUM(D.Total_Runs) AS TotalRunsAsWinningTeam,M.WinningTeam
,SUM(CASE WHEN batsman_runs IN (4,5) THEN 1 ELSE 0 END) TotalBoundariesAsWinningTeam
,SUM(CASE WHEN batsman_runs IN (6) THEN 1 ELSE 0 END) TotalSixesAsWinningTeam
,SUM(extra_runs) AS TotalExtraRunScoredAsWinningTeam
FROM deliveries D INNER JOIN 
(SELECT Id As MatchID,Winner AS WinningTeam, CASE WHEN winner=team1 THEN team2 ELSE team1 END AS LosingTeam FROM matches) M
ON D.match_id=M.MatchID AND M.WinningTeam=D.batting_team
GROUP BY M.WinningTeam)A
--ORDER BY M.WinningTeam
INNER JOIN 
(SELECT SUM(D.Total_Runs) AS TotalRunsAsLosingTeam,M.LosingTeam
,SUM(CASE WHEN batsman_runs IN (4,5) THEN 1 ELSE 0 END) TotalBoundariesAsLosingTeam
,SUM(CASE WHEN batsman_runs IN (6) THEN 1 ELSE 0 END) TotalSixesAsLosingTeam
,SUM(extra_runs) AS TotalExtraRunScoredAsLosingTeam
FROM deliveries D INNER JOIN 
(SELECT Id As MatchID,Winner AS WinningTeam, CASE WHEN winner=team1 THEN team2 ELSE team1 END AS LosingTeam FROM matches) M
ON D.match_id=M.MatchID AND M.LosingTeam=D.batting_team
GROUP BY M.LosingTeam) B
ON A.WinningTeam=B.LosingTeam
ORDER BY A.WinningTeam

SELECT * FROM deliveries

SELECT A.WinningTeam AS Team,A.TotalRunsAsWinningTeam,A.TotalBoundariesAsWinningTeam,A.TotalSixesAsWinningTeam,A.TotalExtraRunScoredAsWinningTeam,B.TotalRunsAsLosingTeam,B.TotalBoundariesAsLosingTeam,B.TotalSixesAsLosingTeam,B.TotalExtraRunScoredAsLosingTeam FROM (SELECT SUM(D.Total_Runs) AS TotalRunsAsWinningTeam,M.WinningTeam,SUM(CASE WHEN batsman_runs IN (4,5) THEN 1 ELSE 0 END) TotalBoundariesAsWinningTeam,SUM(CASE WHEN batsman_runs IN (6) THEN 1 ELSE 0 END) TotalSixesAsWinningTeam,SUM(extra_runs) AS TotalExtraRunScoredAsWinningTeam FROM deliveries D INNER JOIN (SELECT Id As MatchID,Winner AS WinningTeam, CASE WHEN winner=team1 THEN team2 ELSE team1 END AS LosingTeam FROM matches) M ON D.match_id=M.MatchID AND M.WinningTeam=D.batting_team GROUP BY M.WinningTeam)A INNER JOIN (SELECT SUM(D.Total_Runs) AS TotalRunsAsLosingTeam,M.LosingTeam,SUM(CASE WHEN batsman_runs IN (4,5) THEN 1 ELSE 0 END) TotalBoundariesAsLosingTeam,SUM(CASE WHEN batsman_runs IN (6) THEN 1 ELSE 0 END) TotalSixesAsLosingTeam,SUM(extra_runs) AS TotalExtraRunScoredAsLosingTeam FROM deliveries D INNER JOIN  (SELECT Id As MatchID,Winner AS WinningTeam, CASE WHEN winner=team1 THEN team2 ELSE team1 END AS LosingTeam FROM matches) M ON D.match_id=M.MatchID AND M.LosingTeam=D.batting_team GROUP BY M.LosingTeam) B ON A.WinningTeam=B.LosingTeam ORDER BY A.WinningTeam


SELECT A.WinningTeam AS Team,A.TotalRunsAsWinningTeam,A.TotalBoundariesAsWinningTeam,A.TotalSixesAsWinningTeam,A.TotalExtraRunScoredAsWinningTeam,B.TotalRunsAsLosingTeam,B.TotalBoundariesAsLosingTeam,B.TotalSixesAsLosingTeam,B.TotalExtraRunScoredAsLosingTeam FROM (SELECT SUM(D.Total_Runs) AS TotalRunsAsWinningTeam,M.WinningTeam,SUM(CASE WHEN batsman_runs IN (4,5) THEN 1 ELSE 0 END) TotalBoundariesAsWinningTeam,SUM(CASE WHEN batsman_runs IN (6) THEN 1 ELSE 0 END) TotalSixesAsWinningTeam,SUM(extra_runs) AS TotalExtraRunScoredAsWinningTeam FROM deliveries D INNER JOIN (SELECT Id As MatchID,Winner AS WinningTeam, CASE WHEN winner=team1 THEN team2 ELSE team1 END AS LosingTeam FROM matches) M ON D.match_id=M.MatchID AND M.WinningTeam=D.batting_team GROUP BY M.WinningTeam)A INNER JOIN (SELECT SUM(D.Total_Runs) AS TotalRunsAsLosingTeam,M.LosingTeam,SUM(CASE WHEN batsman_runs IN (4,5) THEN 1 ELSE 0 END) TotalBoundariesAsLosingTeam,SUM(CASE WHEN batsman_runs IN (6) THEN 1 ELSE 0 END) TotalSixesAsLosingTeam,SUM(extra_runs) AS TotalExtraRunScoredAsLosingTeam FROM deliveries D INNER JOIN  (SELECT Id As MatchID,Winner AS WinningTeam, CASE WHEN winner=team1 THEN team2 ELSE team1 END AS LosingTeam FROM matches) M ON D.match_id=M.MatchID AND M.LosingTeam=D.batting_team GROUP BY M.LosingTeam) B ON A.WinningTeam=B.LosingTeam ORDER BY A.WinningTeam



SELECT DISTINCT team1 FROM matches WHERE id IN (
select DISTINCT Match_Id from deliveries WHERE batting_team IN 
('Rising Pune Supergiant','Rising Pune Supergiants','Pune Warriors'))


SELECT * FROM deliveries
SELECT distinct team1 FROM matches where team1 like '%pune%'
SELECT distinct team1 FROM matches where team1 like '%Deccan%' OR team1 like '%hyderabad%'
team1,team2,toss_winner,winner

SELECT * FROM deliveries

batting_team
bowling_team

--Venue based analysis
SELECT * FROM matches
SELECT distinct city FROM matches



SELECT X.IPLTournamentWinner
,WonAtHome=SUM(CASE WHEN M.winner=X.IPLTournamentWinner THEN 1 ELSE 0 END)
,TotalPlayedAtHome=SUM(CASE WHEN (M.team1=X.IPLTournamentWinner OR M.team2 = X.IPLTournamentWinner) AND M.city=X.City THEN 1 ELSE 0 END)
,M.season
 FROM matches M INNER JOIN 
(SELECT CASE WHEN m.Winner ='Rajasthan Royals' THEN 'Jaipur'
            WHEN m.Winner ='Mumbai Indians' THEN 'Mumbai' 
			WHEN m.Winner ='Chennai Super Kings' THEN 'Chennai' 
			WHEN m.Winner ='Kolkata Knight Riders' THEN 'Kolkata' 
			ELSE m.winner END AS City, m.Winner AS IPLTournamentWinner, m.Season FROM matches m INNER JOIN (
SELECT MAX(Id) AS FinalMatchId, Season FROM matches
GROUP BY Season) A 
ON m.Id=A.FinalMatchId) X
ON M.city=X.City
AND (X.IPLTournamentWinner=M.team1 OR X.IPLTournamentWinner=M.team2)
AND M.season=X.season
GROUP BY M.season,X.IPLTournamentWinner
ORDER BY M.season,X.IPLTournamentWinner ASC


SELECT X.IPLTournamentWinner,WonAtHome=SUM(CASE WHEN M.winner=X.IPLTournamentWinner THEN 1 ELSE 0 END),TotalPlayedAtHome=SUM(CASE WHEN (M.team1=X.IPLTournamentWinner OR M.team2 = X.IPLTournamentWinner) AND M.city=X.City THEN 1 ELSE 0 END),M.season FROM matches M INNER JOIN (SELECT CASE WHEN m.Winner ='Rajasthan Royals' THEN 'Jaipur' WHEN m.Winner ='Mumbai Indians' THEN 'Mumbai' WHEN m.Winner ='Chennai Super Kings' THEN 'Chennai' WHEN m.Winner ='Kolkata Knight Riders' THEN 'Kolkata' ELSE m.winner END AS City, m.Winner AS IPLTournamentWinner, m.Season FROM matches m INNER JOIN (SELECT MAX(Id) AS FinalMatchId, Season FROM matches GROUP BY Season) A ON m.Id=A.FinalMatchId) X ON M.city=X.City AND (X.IPLTournamentWinner=M.team1 OR X.IPLTournamentWinner=M.team2) AND M.season=X.season GROUP BY M.season,X.IPLTournamentWinner ORDER BY M.season,X.IPLTournamentWinner ASC


SELECT * FROM matches where season=2014 AND city='kolkata'

Mumbai Indians	2017
Rajasthan Royals	2008
Hyderabad	2009
Chennai Super Kings	2010
Chennai Super Kings	2011
Kolkata Knight Riders	2012
Mumbai Indians	2013
Kolkata Knight Riders	2014
Mumbai Indians	2015
Hyderabad	2016

--RunRate Analysis
--Run rate of teams by Season while batting second -- while batting first 
SELECT * FROM (
SELECT d.batting_team,SUM(total_runs) AS Score,RunRatePerBall=CAST(SUM(CAST(total_runs AS FLOAT))/((MAX(CAST([over] AS FLOAT))-1)*6+CAST(MAX(ball) AS FLOAT)) AS FLOAT),COUNT(Player_Dismissed) As Wicket FROM deliveries d 
INNER JOIN matches m ON d.match_id=m.id
WHERE m.season=2008
AND d.batting_team IN (
SELECT DISTINCT team1 AS [Team] FROM matches WHERE Season=2008
UNION 
SELECT DISTINCT team2 AS [Team] FROM matches WHERE Season=2008)
AND d.inning=1
GROUP BY d.match_id,d.batting_team,d.inning
UNION ALL
SELECT d.batting_team+' While Chasing' AS batting_team ,SUM(total_runs) AS Score,RunRatePerBall=CAST(SUM(CAST(total_runs AS FLOAT))/((MAX(CAST([over] AS FLOAT))-1)*6+CAST(MAX(ball) AS FLOAT)) AS FLOAT),COUNT(Player_Dismissed) As Wicket FROM deliveries d 
INNER JOIN matches m ON d.match_id=m.id
WHERE m.season=2008
AND d.batting_team IN (
SELECT DISTINCT team1 AS [Team] FROM matches WHERE Season=2008
UNION 
SELECT DISTINCT team2 AS [Team] FROM matches WHERE Season=2008)
AND d.inning=2
GROUP BY d.match_id,d.batting_team,d.inning) A
ORDER BY batting_team


SELECT * FROM deliveries
--Wicket Analysis
--Top 10 Bowlers Analysis
--Name economy and wickets taken
--Top 10 Batsman Analysis
--Name - Total Run Scored, StrikeRate
--Best Filders
--Most Catches and team name

SELECT Bowler,TotalRunGiven AS TotalRunIncurred,Wickets,NoOfOversBowled,Economy = CAST(TotalRunGiven AS FLOAT)/CAST(NoOfOversBowled AS FLOAT) FROM (
SELECT SUM(total_runs) AS TotalRunGiven,d.bowler AS Bowler,COUNT(d.player_dismissed) AS Wickets
,COUNT( DISTINCT d.match_id*10+d.[Over]) AS NoOfOversBowled  FROM deliveries d
INNER JOIN matches m 
ON d.match_id=m.id AND m.season=2008
GROUP BY d.bowler) A ORDER BY  A.Wickets DESC

SELECT Bowler,TotalRunGiven AS TotalRunIncurred,Wickets,NoOfOversBowled,Economy = CAST(TotalRunGiven AS FLOAT)/CAST(NoOfOversBowled AS FLOAT) FROM (
SELECT SUM(total_runs) AS TotalRunGiven,d.bowler AS Bowler,COUNT(d.player_dismissed) AS Wickets
,COUNT( DISTINCT d.match_id*10+d.[Over]) AS NoOfOversBowled  FROM deliveries d
INNER JOIN matches m 
ON d.match_id=m.id AND m.season=2008
GROUP BY d.bowler) A ORDER BY  CAST(TotalRunGiven AS FLOAT)/CAST(NoOfOversBowled AS FLOAT) ASC


ORDER BY d.player_dismissed DESC

SELECT COUNT(d.player_dismissed),SUM(total_runs) AS TotalRunGiven,COUNT(DISTINCT d.match_id*10+d.[Over]) AS NoOfOversBowled 
SELECT d.* FROM deliveries d INNER JOIN matches m ON d.match_id=m.id WHERE m.season=2008
AND d.bowler='Sohail Tanvir'
275	Sohail Tanvir	24	12
395	SR Watson	20	17


--Great Defenders
SELECT * FROM matches

SELECT B.Defender AS Team,A.TotalMatchesPlayed,B.SuccessfullyDefendedCount FROM ( 
SELECT SUM(TotalMatchesPlayed) AS TotalMatchesPlayed,Team FROM (
SELECT COUNT(id) AS TotalMatchesPlayed,team1 AS Team FROM matches GROUP BY team1
UNION
SELECT COUNT(id) AS TotalMatchesPlayed,team2 AS Team FROM matches GROUP BY team2) A GROUP BY Team
)A 
INNER JOIN (SELECT Defender,SUM(SuccessfullyDefendedCount) AS SuccessfullyDefendedCount FROM (
SELECT Defender=CASE 
WHEN toss_decision='bat' THEN toss_winner
WHEN toss_decision='field' THEN CASE WHEN toss_winner=team1 THEN team2 ELSE team1 END END,SuccessfullyDefendedCount=COUNT(
CASE WHEN (
CASE 
WHEN toss_decision='bat' THEN toss_winner
WHEN toss_decision='field' THEN CASE WHEN toss_winner=team1 THEN team2 ELSE team1 END END=winner) THEN 1 ELSE 0 END)  
FROM matches 
GROUP BY 
(CASE 
WHEN toss_decision='bat' THEN toss_winner
WHEN toss_decision='field' THEN CASE WHEN toss_winner=team1 THEN team2 ELSE team1 END END ))X GROUP BY X.Defender
) B ON A.Team=B.Defender		 
					 
					 WHERE id  IN (61,67) team1='Chennai Super Kings'


SELECT * FROM matches WHERE team1='Chennai Super Kings'
SELECT * FROM matches WHERE team2='Chennai Super Kings'

131	Chennai Super Kings
147	Delhi Daredevils
30	Gujarat Lions
--Great Chasers

SELECT B.Chasers AS Team,A.TotalMatchesPlayed,B.SuccessfullyChasedCount FROM ( 
SELECT SUM(TotalMatchesPlayed) AS TotalMatchesPlayed,Team FROM (
SELECT COUNT(id) AS TotalMatchesPlayed,team1 AS Team FROM matches GROUP BY team1
UNION
SELECT COUNT(id) AS TotalMatchesPlayed,team2 AS Team FROM matches GROUP BY team2) A GROUP BY Team
)A 
INNER JOIN (
SELECT Chasers=CASE 
WHEN toss_decision='field' THEN toss_winner
WHEN toss_decision='bat' THEN CASE WHEN toss_winner=team1 THEN team2 ELSE team1 END END,SuccessfullyChasedCount=COUNT(CASE 
WHEN toss_decision='field' THEN toss_winner
WHEN toss_decision='bat' THEN CASE WHEN toss_winner=team1 THEN team2 ELSE team1 END END )  
FROM matches 
GROUP BY 
(CASE 
WHEN toss_decision='field' THEN toss_winner
WHEN toss_decision='bat' THEN CASE WHEN toss_winner=team1 THEN team2 ELSE team1 END END )
) B ON A.Team=B.Chasers


SELECT B.Defender AS Team,A.TotalMatchesPlayed,B.SuccessfullyDefendedCount FROM ( 
SELECT SUM(TotalMatchesPlayed) AS TotalMatchesPlayed,Team FROM (
SELECT COUNT(id) AS TotalMatchesPlayed,team1 AS Team FROM matches GROUP BY team1
UNION
SELECT COUNT(id) AS TotalMatchesPlayed,team2 AS Team FROM matches GROUP BY team2) A GROUP BY Team
)A 
INNER JOIN (
SELECT Defender=CASE 
WHEN toss_decision='bat' THEN toss_winner
WHEN toss_decision='field' THEN CASE WHEN toss_winner=team1 THEN team2 ELSE team1 END END,SuccessfullyDefendedCount=COUNT(CASE 
WHEN toss_decision='bat' THEN toss_winner
WHEN toss_decision='field' THEN CASE WHEN toss_winner=team1 THEN team2 ELSE team1 END END )  
FROM matches 
GROUP BY 
(CASE 
WHEN toss_decision='bat' THEN toss_winner
WHEN toss_decision='field' THEN CASE WHEN toss_winner=team1 THEN team2 ELSE team1 END END )
) B ON A.Team=B.Defender	






SELECT Defender,SUM(SuccessfullyDefended) AS SuccessfullyDefended
,SUM(BattedFirstCount) AS BattedFirstCount
,DefenceIndex=(CAST (SUM(SuccessfullyDefended) AS FLOAT))/(CAST (SUM(BattedFirstCount) AS FLOAT)) 
FROM (
SELECT Defender=CASE 
WHEN toss_decision='bat' THEN toss_winner
WHEN toss_decision='field' THEN CASE WHEN toss_winner=team1 THEN team2 ELSE team1 END END,winner AS Winner, CASE WHEN (CASE 
WHEN toss_decision='bat' THEN toss_winner
WHEN toss_decision='field' THEN CASE WHEN toss_winner=team1 THEN team2 ELSE team1 END END)=winner THEN 1 ELSE 0 END AS SuccessfullyDefended,1 AS BattedFirstCount
FROM matches ) A 
GROUP BY A.Defender
ORDER BY (CAST (SUM(SuccessfullyDefended) AS FLOAT))/(CAST (SUM(BattedFirstCount) AS FLOAT)) DESC


SELECT Chaser,SUM(SuccessfullyChased) AS SuccessfullyChased
,SUM(BattedSecondCount) AS BattedSecondCount
,ChaseIndex=(CAST (SUM(SuccessfullyChased) AS FLOAT))/(CAST (SUM(BattedSecondCount) AS FLOAT))  FROM (
SELECT Chaser=CASE 
WHEN toss_decision='field' THEN toss_winner
WHEN toss_decision='bat' THEN CASE WHEN toss_winner=team1 THEN team2 ELSE team1 END END,winner AS Winner, CASE WHEN (CASE 
WHEN toss_decision='field' THEN toss_winner
WHEN toss_decision='bat' THEN CASE WHEN toss_winner=team1 THEN team2 ELSE team1 END END)=winner THEN 1 ELSE 0 END AS SuccessfullyChased,1 AS BattedSecondCount
FROM matches ) A 
GROUP BY A.Chaser
ORDER BY (CAST (SUM(SuccessfullyChased) AS FLOAT))/(CAST (SUM(BattedSecondCount) AS FLOAT)) DESC




WHERE A.Defender='Chennai Super Kings'

GROUP BY 
(CASE 
WHEN toss_decision='bat' THEN toss_winner
WHEN toss_decision='field' THEN CASE WHEN toss_winner=team1 THEN team2 ELSE team1 END END )


/****************************************/
--working on the preparing the traning dataset

SELECT * FROM deliveries


CREATE CLUSTERED INDEX PK_CI ON deliveries(RID)
CREATE NONCLUSTERED INDEX NCI ON deliveries(match_id)

CREATE NONCLUSTERED INDEX NCI ON matches(id)

CREATE TABLE IPLTrainingData
(
Id INT IDENTITY (1,1)
,Team1 VARCHAR(500)
,Team2 VARCHAR(500)
,Venue VARCHAR(2000)
,Toss_Winner VARCHAR(100)
,Toss_Decision VARCHAR(100)
,Innings INT
,OverBallSequence INT
,TotalRuns INT
,TotalWicket INT
,TotalExtraRunsScored INT
,TotalSixes INT
,TotalFours INT
,TotalBoundaries INT
,NoOfDistinctBowlersUntilNow INT
,FaceOffInCurrentSeason INT
,FaceOffInAllSeason INT
,RunRate FLOAT
,TotalMatchesPlayedByBattingTeamAllSeason INT
,TotalMatchesWonByBattingTeamAllSeason INT
,TotalMatchesPlayedByBattingTeamCurrentSeason INT
,TotalMatchesWonByBattingTeamCurrentSeason INT
,MatchWinner VARCHAR(500)
)


DECLARE @Id INT =1 
WHILE (@Id IS NOT NULL)
BEGIN
INSERT INTO IPLTrainingData
SELECT M.team1 AS Team1,M.team2 AS Team2,Venue= (M.city+' '+M.venue),
Toss_Winner=M.toss_winner,Toss_Decision=M.toss_decision,Innings=D.inning,OverBallSequence=((D.[over]-1)*6)+D.ball,
Total_Runs= (SELECT SUM(D.total_runs) FROM deliveries D INNER JOIN  (SELECT match_id,inning FROM deliveries WHERE RID=@Id ) X
ON D.match_id=X.match_id AND D.inning=X.inning WHERE RID<=@Id
GROUP BY D.match_id,D.inning),
Total_Wickets=(SELECT COUNT(D.player_dismissed) FROM deliveries D INNER JOIN  (SELECT match_id,inning FROM deliveries WHERE RID=@Id ) X
ON D.match_id=X.match_id AND D.inning=X.inning WHERE RID<=@Id
GROUP BY D.match_id,D.inning),
TotalExtraRunsScored=(SELECT SUM(D.extra_runs) FROM deliveries D INNER JOIN  (SELECT match_id,inning FROM deliveries WHERE RID=@Id ) X
ON D.match_id=X.match_id AND D.inning=X.inning WHERE RID<=@Id
GROUP BY D.match_id,D.inning),
TotalSixes=ISNULL((SELECT ISNULL(COUNT(D.batsman_runs),0) FROM deliveries D INNER JOIN  (SELECT match_id,inning FROM deliveries WHERE RID=@Id ) X
ON D.match_id=X.match_id AND D.inning=X.inning WHERE RID<=@Id AND D.batsman_runs=6
GROUP BY D.match_id,D.inning),0),
TotalFours=ISNULL((SELECT ISNULL(COUNT(D.batsman_runs),0) FROM deliveries D INNER JOIN  (SELECT match_id,inning FROM deliveries WHERE RID=@Id ) X
ON D.match_id=X.match_id AND D.inning=X.inning WHERE RID<=@Id AND D.batsman_runs IN(4,5)
GROUP BY D.match_id,D.inning),0),
TotalBoundaries=ISNULL((SELECT ISNULL(COUNT(D.batsman_runs),0) FROM deliveries D INNER JOIN  (SELECT match_id,inning FROM deliveries WHERE RID=@Id ) X
ON D.match_id=X.match_id AND D.inning=X.inning WHERE RID<=@Id AND D.batsman_runs IN (4,5,6)
GROUP BY D.match_id,D.inning),0),
NoOfDistinctBowlersUntilNow=(SELECT COUNT(DISTINCT D.bowler) FROM deliveries D INNER JOIN  (SELECT match_id,inning FROM deliveries WHERE RID=@Id ) X
ON D.match_id=X.match_id AND D.inning=X.inning WHERE RID<=@Id
GROUP BY D.match_id,D.inning),
FaceOffInCurrentSeason=(
SELECT COUNT(*) FROM  
(SELECT DISTINCT m.id,m.team1,m.team2 FROM matches m INNER JOIN  (SELECT season FROM deliveries JOIN matches ON deliveries.match_id=matches.id  WHERE RID=@Id) X 
ON m.season=X.season
INNER JOIN deliveries DD ON m.id = DD.match_id AND DD.RID<=@Id)Y
INNER JOIN (SELECT batting_team, bowling_team FROM deliveries WHERE RID=@Id) D
ON (D.batting_team=Y.team1 AND D.bowling_team=Y.team2) OR (D.batting_team=Y.team2 AND D.bowling_team=Y.team1)
),
FaceOffInAllSeason=(
SELECT COUNT(*) FROM  
(SELECT DISTINCT m.id,m.team1,m.team2 FROM matches m
INNER JOIN deliveries DD ON m.id = DD.match_id AND DD.RID<=@Id)Y
INNER JOIN (SELECT batting_team, bowling_team FROM deliveries WHERE RID=@Id) D
ON (D.batting_team=Y.team1 AND D.bowling_team=Y.team2) OR (D.batting_team=Y.team2 AND D.bowling_team=Y.team1)
)

,RunRate = (
SELECT 
(SELECT CAST(SUM(D.total_runs) AS FLOAT) AS total_runs FROM deliveries D INNER JOIN  (SELECT match_id,inning FROM deliveries WHERE RID=@Id ) X
ON D.match_id=X.match_id AND D.inning=X.inning WHERE RID<=@Id
GROUP BY D.match_id,D.inning)/CAST((([over]-1)*6)+ball AS FLOAT) AS RunRate  FROM deliveries WHERE RID=@Id
),
TotalMatchesPlayedByBattingTeamAllSeason = (
SELECT COUNT(id) FROM matches M INNER JOIN (
SELECT match_id,batting_team FROM deliveries WHERE RID=@Id) D 
ON M.id <= D.match_id WHERE D.batting_team=M.team1 OR D.batting_team=M.team2
),
TotalMatchesWonByBattingTeamAllSeason = (
SELECT COUNT(id) FROM matches M INNER JOIN (
SELECT match_id,batting_team FROM deliveries WHERE RID=@Id) D 
ON M.id <= D.match_id WHERE D.batting_team=M.winner
),
TotalMatchesPlayedByBattingTeamCurrentSeason=(
SELECT COUNT(match_id) FROM(
SELECT DISTINCT match_id,batting_team,season FROM deliveries D INNER JOIN matches m ON D.match_id=m.id 
WHERE D.RID<=@Id AND M.season=(SELECT MM.season from matches MM INNER JOIN deliveries DD ON DD.match_id=MM.id WHERE DD.RID=@Id)
AND D.batting_team=(SELECT batting_team FROM deliveries WHERE RID=@Id)) D 
),
TotalMatchesWonByBattingTeamCurrentSeason=(
SELECT COUNT(D.match_id) FROM(
SELECT DISTINCT match_id,batting_team,season FROM deliveries D INNER JOIN matches m ON D.match_id=m.id 
WHERE D.RID<=@Id AND M.season=(SELECT MM.season from matches MM INNER JOIN deliveries DD ON DD.match_id=MM.id WHERE DD.RID=@Id)
AND D.batting_team=(SELECT batting_team FROM deliveries WHERE RID=@Id)
) D INNER JOIN matches mmm ON mmm.id=D.match_id WHERE D.batting_team=mmm.winner
)
,MatchWinner =(SELECT Winner FROM matches m INNER JOIN deliveries D ON m.id=D.match_id WHERE D.RID=@Id) 

FROM deliveries D 
INNER JOIN matches M 
ON D.match_id=M.id WHERE D.RID = @Id

SELECT @Id=MIN(RID) FROM deliveries WHERE RID>@Id
END

SELECT * FROM deliveries D INNER JOIN matches M ON D.match_id=M.id WHERE D.RID <= 5

SELECT * FROM matches

SELECT AA.winner,AA.season FROM (
SELECT M.Winner,M.Season FROM matches M INNER JOIN 
(SELECT MAX(id) ID,season FROM matches GROUP BY season) X ON M.id=X.Id) AA 
WHERE Season<(SELECT DISTINCT season from matches m INNER JOIN deliveries d ON m.id = d.match_id WHERE d.RID=1000)

SELECT COUNT(*) FROM deliveries
SELECT COUNT(*) FROM IPLTrainingData (NOLOCK)
SELECT * FROM IPLTrainingData (NOLOCK) WHERE MatchWinner IS NOT NULL ORDER BY Id 
SELECT * FROM matches WHERE id=34
SELECT * FROM deliveries WHERe match_id=34

SELECT * FROM IPLTrainingData WHERE ID=8008

SELECT DISTINCT m.* FROM IPLTrainingData (NOLOCK) I INNER  JOIN deliveries D ON I.ID=D.RID 
INNER JOIN matches m ON D.match_id=m.id
WHERE I.MatchWinner IS NULL ORDER BY I.Id 



SELECT DISTINCT Team1 FROM IPLTrainingData
SELECT DISTINCT Team2 FROM IPLTrainingData
SELECT DISTINCT MatchWinner FROM IPLTrainingData WHERE MatchWinner IS NOT NULL 
SELECT DISTINCT Toss_Winner FROM IPLTrainingData WHERE MatchWinner IS NOT NULL 
SELECT DISTINCT Toss_Decision FROM IPLTrainingData WHERE MatchWinner IS NOT NULL 
['bat','field']
'Pune','Mumbai Indians','Hyderabad','Gujarat Lions','Royal Challengers Bangalore','Kolkata Knight Riders','Kochi Tuskers Kerala','Rajasthan Royals','Kings XI Punjab','Delhi Daredevils','Chennai Super Kings'
SELECT DISTINCT (''''+Venue+''',') FROM IPLTrainingData WHERE MatchWinner IS NOT NULL 
['Visakhapatnam Dr. Y.S. Rajasekhara Reddy ACA-VDCA Cricket Stadium','Ranchi JSCA International Stadium Complex','Kanpur Green Park','Mumbai Brabourne Stadium','Delhi Feroz Shah Kotla','Port Elizabeth St George's Park','Abu Dhabi Sheikh Zayed Stadium','Chandigarh Punjab Cricket Association IS Bindra Stadium, Mohali','Mumbai Wankhede Stadium','Bangalore M Chinnaswamy Stadium','Dharamsala Himachal Pradesh Cricket Association Stadium','Chandigarh Punjab Cricket Association Stadium, Mohali','Nagpur Vidarbha Cricket Association Stadium, Jamtha','Dubai International Cricket Stadium','Durban Kingsmead','Hyderabad Rajiv Gandhi International Stadium, Uppal','Jaipur Sawai Mansingh Stadium','Sharjah Sharjah Cricket Stadium','East London Buffalo Park','Indore Holkar Cricket Stadium','Kimberley De Beers Diamond Oval','Kolkata Eden Gardens','Cape Town Newlands','Chennai MA Chidambaram Stadium, Chepauk','Ahmedabad Sardar Patel Stadium, Motera','Cuttack Barabati Stadium','Pune Subrata Roy Sahara Stadium','Raipur Shaheed Veer Narayan Singh International Stadium','Kochi Nehru Stadium','Rajkot Saurashtra Cricket Association Stadium','Pune Maharashtra Cricket Association Stadium','Johannesburg New Wanderers Stadium','Centurion SuperSport Park','Bloemfontein OUTsurance Oval','Mumbai Dr DY Patil Sports Academy']




SELECT * FROM IPLTrainingData ORDER BY ID

SELECT * FROM deliveries WHERE RID= 109378
SELECT * FROM matches where id=462
SELECT * FROM matches where CITY IS NULL




--UPDATE I SET I.Venue= M.venue
--FROM IPLTrainingData I INNER JOIN deliveries D ON I.Id=D.RID 
--INNER JOIN matches m ON D.match_id=m.id 
--WHERE I.Venue IS NULL


SELECT TOP 10 * FROM matches
SELECT TOP 10 * FROM deliveries