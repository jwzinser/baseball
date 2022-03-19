



docker run -d --name baseball -v /Users/juanzinser/Workspace/Workshop/baseball/src/teams:/docker-entrypoint-initdb.d/    -e POSTGRES_PASSWORD=Pass2020! -p 5435:5432    postgres

pgcli -h localhost -U postgres -p 5435