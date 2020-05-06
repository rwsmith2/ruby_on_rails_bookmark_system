CREATE TABLE user (
    user_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    firstname TEXT NOT NULL,
    surname TEXT NOT NULL,
    username TEXT NOT NULL,
    email TEXT NOT NULL,
    access_level TEXT NOT NULL,
    mobile_number TEXT,
    suspended BOOLEAN NOT NULL,
    password TEXT NOT NULL
);
--bookmark table
CREATE TABLE bookmark (
    --primary key for table
    bookmark_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    description TEXT,
    author TEXT NOT NULL,
    author_id INTEGER NOT NULL,
    date_created DATE NOT NULL,
    rating INTEGER,
    num_of_ratings INTEGER,
    reported BOOLEAN NOT NULL,
    bookmark_tag_one TEXT,
    bookmark_tag_two TEXT,
    bookmark_tag_three TEXT
);

CREATE TABLE comment (
    comment_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    author TEXT NOT NULL,
    date_created DATE NOT NULL,
    bookmark_id INTEGER REFERENCES bookmark(bookmark_id)
);

CREATE TABLE request (
    request_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,
    content TEXT NOT NULL,
    read  BOOLEAN NOT NULL
);

CREATE TABLE tag (
    tag_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    tag TEXT NOT NULL
);

CREATE TABLE bookmark_tag (
    bookmark_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT REFERENCES bookmark(bookmark_id)
 
);
-- Users test data
INSERT INTO user VALUES(1, "Logan", "Miller","role1", "lmiller6@sheffield.ac.uk", "admin", "07123456789", 0, "password");
INSERT INTO user VALUES(2, "James", "Acaster","role2" ,"jamesa@gmail.com", "employee", "07111222333", 0, "pWORD1");
INSERT INTO user VALUES(3, "Jimmy", "Carr", "role3","jimbo69@hotmail.com", "registered", "07328197892", 1, "CAPITALlower314");
INSERT INTO user VALUES(4, "Admin", "Account","admin", "admin@gmail.com", "admin", "01189998819991197253", 0, "admin");
INSERT INTO user VALUES(5, "User", "Account", "user","user@gmail.com", "employee", "01189998819991197253", 0, "user");
INSERT INTO user VALUES(6, "qwe", "qwe", "role4","qwe@gmail.com", "registered", "21312", 0, "123");

-- Bookmark test data
INSERT INTO bookmark VALUES(1, "Lab results", "/lab.html", "Details of february's lab", "Logan Miller",1, '2020-2-10', 4, 2, 0,null, null,null);
INSERT INTO bookmark VALUES(2, "My website", "https://www.jimmycarr.com/", "Link to my personal data", "James Acaster",2, '2020-3-19', 5, 31, 0,null, null,null);
INSERT INTO bookmark VALUES(3, "Funny jokes", "jokes.txt", "Top 100 jokes", "Jimmy Carr",3, '2019-12-9', 0, 0, 0,null, null,null);

--Comment test data
INSERT INTO comment VALUES(1,"Test comment","Test!!!","Logan Miller","2020-3-28",2);

--Request test data
INSERT INTO request VALUES(1, "role1", "test", 1);

--Tag test data
INSERT INTO tag VALUES(1,"Lab");
INSERT INTO tag VALUES(2,"Website");
INSERT INTO tag VALUES(3,"Fun");
