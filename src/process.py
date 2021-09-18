import pandas as pd

conversion = {
    "object": "TEXT",
    "float64": "NUMERIC",
    "int64": "INTEGER"
}

tables = {"AllstarFull": "all_star",
          "Appearances": "appearances",
          "AwardsManagers": "manager_award",
          "AwardsPlayers": "player_award",
          "AwardsShareManagers": "manager_award_vote",
          "AwardsSharePlayers": "player_award_vote",
          "Batting": "batting",
          "BattingPost": "batting_postseason",
          "CollegePlaying": "player_college",
          "Fielding": "fielding",
          "FieldingOF": "fielding_outfield",
          "FieldingPost": "fielding_postseason",
          "HallOfFame": "hall_of_fame",
          "HomeGames": "home_game",
          "Managers": "manager",
          "ManagersHalf": "manager_half",
          "Master": "player",
          "Parks": "park",
          "Pitching": "pitching",
          "PitchingPost": "pitching_postseason",
          "Salaries": "salary",
          "Schools": "college",
          "SeriesPost": "postseason",
          "Teams": "team",
          "TeamsFranchises": "team_franchise",
          "TeamsHalf": "team_half"}

sql = """.separator ","

"""

replace_column_names = {
    "2B": "double",
    "3B": "triple",
    "gameNum": "game_num",
    "startingPos": "starting_pos",
    "pointsWon": "points_won",
    "pointsMax": "points_max",
    "votesFirst": "votes_first",
    "InnOuts": "inn_outs",
    "VotedBy": "voted_by",
    "plyrMgr": "plyr_mgr",
    "birthYear": "birth_year",
    "birthMonth": "birth_month",
    "birthDay": "birth_day",
    "birthCountry": "birth_country",
    "birthState": "birth_state",
    "birthCity": "birth_city",
    "deathYear": "death_year",
    "deathMonth": "death_month",
    "deathDay": "death_day",
    "deathCountry": "death_country",
    "deathState": "death_state",
    "deathCity": "death_city",
    "nameFirst": "name_first",
    "nameLast": "name_last",
    "nameGiven": "name_given",
    "finalGame": "final_game",
    "teamIDwinner": "team_id_winner",
    "lgIDwinner": "league_id_winner",
    "teamIDloser": "team_id_loser",
    "lgIDloser": "league_id_loser",
    "lgID": "league_id",
    "DivWin": "div_win",
    "WCWin": "wc_win",
    "LgWin": "lg_win",
    "WSWin": "ws_win",
    "franchID": "franchise_id",
    "franchName": "franchise_name",
    "NAassoc": "na_assoc",
    "teamIDBR": "team_id_br",
    "teamIDlahman45": "team_id_lahman45",
    "teamIDretro": "team_id_retro",
    "schoolID": "college_id",
    "yearID": "year"
}

for table in sorted(tables):
    print(table)
    data = pd.read_csv("input/baseballdatabank-master/core/%s.csv" % table, low_memory=False)

    for replace_col in replace_column_names:
        data.columns = [col if col != replace_col else replace_column_names[replace_col] for col in data.columns]

    data.columns = [col.replace("ID", "_id") for col in data.columns]
    data.columns = [col.replace("year.key", "year") for col in data.columns]
    data.columns = [col.replace(".key",  "_id") for col in data.columns]
    data.columns = [col.replace(".key",  "_id") for col in data.columns]
    data.columns = [col.replace(".",  "_") for col in data.columns]
    data.columns = [col.lower() for col in data.columns]

    data.to_csv("output/%s.csv" % tables[table], index=False)
    data = pd.read_csv("output/%s.csv" % tables[table], low_memory=False)

    sql += """CREATE TABLE %s (
%s);
.import "working/no_header/%s.csv" %s

""" % (tables[table],
       ",\n".join(["    %s %s%s" % (key,
                                   conversion[str(data.dtypes[key])],
                                   " PRIMARY KEY" if key=="Id" else "")
                   for key in data.dtypes.keys()]), tables[table], tables[table])

open("src/import.sql", "w").write(sql)
