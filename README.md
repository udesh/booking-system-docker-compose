This project have below.
MySql server.
PhpMyAdmin
React app.
NodeJs API app.n

Docker commands to run the project.

Unzip the folder and enter to folder. 

* cd demo-booking-system

 * Run docker-compose up -d 

 For the first time it is taking some time to download mysql server , phpmyadmin nodejs and other dependancies.

If there is an error due to node dependancy issue please run below command on /server folder or /client folder
yarn install


1. React app runs on - http://localhost:3000
2. API runs on - http://localhost:8000 eg. http://localhost:8000/vendors
3. PhpMyAdmin runs on - http://localhost:8080/db_export.php?db=sampledb
   username - root password - root
   db - sampledb
