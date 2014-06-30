jacob_bowling_passare
=====================

Jacob Wellington's Coding Exercise

Setup
==
1. Install bundle
2. `RAILS_ENV=dev Bundle install` (you don't have to specify the environment if you have postgres installed)
3. `rails s`

Assumptions
==
-	I’m not going to use bootstrap.
-	There is no way to administrate users or cards. (No CRUD admin panel)
-	I’ll deploy it to Heroku on a free account. I’m not doing any system administration.
-	Only the features within the scope above and those in the “Expectations” section of the “Passare Coding Exercise” document are included.
-	The front end won’t look good and won’t be branded.
-	This does not need to scale to over 5 concurrent users. I won’t worry about caching. The only optimization I will make is making Rails use a single sql query for retrieving game/frame/comments.
- There is no front end validation.
- Tests are not needed to validate templates.



Heroku
==
You can see current the deployed version [here](http://jacob-wellington-bowling.herokuapp.com/). I will deploy to heroku every time I push up to the private repo.

Trello
==
You can see what I'm currently working on and what I think is ready for review on [trello](https://trello.com/b/7nO6vHV0/bowling-scorekeeper)

