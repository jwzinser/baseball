input/baseball.zip:
	mkdir -p input
	curl http://seanlahman.com/files/database/baseballdatabank-master_2016-03-02.zip -o input/baseball.zip

input/baseballdatabank-master/README.txt: input/baseball.zip
	cd input; unzip baseball.zip
	touch input/baseballdatabank-master/README.txt

src/import.sql: input/baseballdatabank-master/README.txt
	mkdir -p working
	mkdir -p output
	python src/process.py
output/all_star.csv: src/import.sql
output/appearances.csv: src/import.sql
output/manager_award.csv: src/import.sql
output/player_award.csv: src/import.sql
output/manager_award_vote.csv: src/import.sql
output/player_award_vote.csv: src/import.sql
output/batting.csv: src/import.sql
output/batting_postseason.csv: src/import.sql
output/player_college.csv: src/import.sql
output/fielding.csv: src/import.sql
output/fielding_outfield.csv: src/import.sql
output/fielding_postseason.csv: src/import.sql
output/hall_of_fame.csv: src/import.sql
output/home_game.csv: src/import.sql
output/manager.csv: src/import.sql
output/manager_half.csv: src/import.sql
output/player.csv: src/import.sql
output/park.csv: src/import.sql
output/pitching.csv: src/import.sql
output/pitching_postseason.csv: src/import.sql
output/salary.csv: src/import.sql
output/college.csv: src/import.sql
output/postseason.csv: src/import.sql
output/team.csv: src/import.sql
output/team_franchise.csv: src/import.sql
output/team_half.csv: src/import.sql

working/no_header/all_star.csv: output/all_star.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/appearances.csv: output/appearances.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/manager_award.csv: output/manager_award.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/player_award.csv: output/player_award.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/manager_award_vote.csv: output/manager_award_vote.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/player_award_vote.csv: output/player_award_vote.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/batting.csv: output/batting.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/batting_postseason.csv: output/batting_postseason.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/player_college.csv: output/player_college.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/fielding.csv: output/fielding.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/fielding_outfield.csv: output/fielding_outfield.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/fielding_postseason.csv: output/fielding_postseason.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/hall_of_fame.csv: output/hall_of_fame.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/home_game.csv: output/home_game.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/manager.csv: output/manager.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/manager_half.csv: output/manager_half.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/player.csv: output/player.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/park.csv: output/park.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/pitching.csv: output/pitching.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/pitching_postseason.csv: output/pitching_postseason.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/salary.csv: output/salary.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/college.csv: output/college.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/postseason.csv: output/postseason.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/team.csv: output/team.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/team_franchise.csv: output/team_franchise.csv
	mkdir -p working/no_header
	tail +2 $^ > $@
working/no_header/team_half.csv: output/team_half.csv
	mkdir -p working/no_header
	tail +2 $^ > $@

output/database.sqlite: working/no_header/all_star.csv working/no_header/appearances.csv working/no_header/manager_award.csv working/no_header/player_award.csv working/no_header/manager_award_vote.csv working/no_header/player_award_vote.csv working/no_header/batting.csv working/no_header/batting_postseason.csv working/no_header/player_college.csv working/no_header/fielding.csv working/no_header/fielding_outfield.csv working/no_header/fielding_postseason.csv working/no_header/hall_of_fame.csv working/no_header/home_game.csv working/no_header/manager.csv working/no_header/manager_half.csv working/no_header/player.csv working/no_header/park.csv working/no_header/pitching.csv working/no_header/pitching_postseason.csv working/no_header/salary.csv working/no_header/college.csv working/no_header/postseason.csv working/no_header/team.csv working/no_header/team_franchise.csv working/no_header/team_half.csv 
	-rm output/database.sqlite
	sqlite3 -echo $@ < src/import.sql
db: output/database.sqlite

output/readme.txt: input/baseballdatabank-master/README.txt
	mkdir -p output
	python src/readme.py

output/hashes.txt: output/database.sqlite output/readme.txt
	-rm output/hashes.txt
	echo "Current git commit:" >> output/hashes.txt
	git rev-parse HEAD >> output/hashes.txt
	echo "\nCurrent input/ouput md5 hashes:" >> output/hashes.txt
	md5 output/*.txt >> output/hashes.txt
	md5 output/*.csv >> output/hashes.txt
	md5 output/*.sqlite >> output/hashes.txt
	md5 input/baseball.zip >> output/hashes.txt
	md5 input/baseballdatabank-master/*.txt >> output/hashes.txt
	md5 input/baseballdatabank-master/core/* >> output/hashes.txt
hashes: output/hashes.txt

release: output/hashes.txt
	cp -r output baseball
	zip -r -X output/baseball_`date -u +'%Y-%m-%d-%H-%M-%S'` baseball/*
	rm -rf baseball

all: release

clean:
	rm -rf src/import.sql
	rm -rf working
	rm -rf output
