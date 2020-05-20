Running the system:

    When you “git pull” our code from git lab, first run “bundle install”(it may takes over one minute) to install all the gems
    needed from the “gemfile”.(In case something goes wrong, we will list all the gems needed: sinatra, thin, sqlite3, minitest,
    capybara, cucumber, rspec, simplecov).

    Then, follow the instructions below:
        To start the system, open the codio terminal and git pull from out and enter the code “ruby app.rb”.
        This will start the system, with the home page being the first page visible at the start. This will include options to:
            Log in
            Register 
            View bookmarks as a guest 

    When logging in, use the respective usernames and passwords:

    Username:    Password:     Role:
    admin        admin         admin
    user         user          user (employee)
    role1        role1         admin 
    role2        role2         user (employee)
    role3        role3         suspended user(registered)
    role4        role4         registered
    Non          non           guest → no user information required 
    
To run the unit tests:

    Delete database/test_class_database.sqlite (if it exists)
    Run “sqlite3 database/test_class_database.sqlite < create_test_class_database.sql”
    Run “ruby users_test_class.rb” or “ruby bookmark_test_class.rb” run the tests.
    NB:You must follow these steps every time to ensure test data has not been changed
    
To run the system tests:

    Delete database/bookmark_system.sqlite
    Run "sqlite3 database/bookmark_system.sqlite < create_databases.sql" 
    Run "cucumber features" to run the tests.
    NB:You must follow these steps every time to ensure test data has not been changed.

