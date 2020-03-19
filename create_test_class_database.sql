CREATE TABLE user (
    user_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    firstname TEXT NOT NULL,
    surname TEXT NOT NULL,
    email TEXT NOT NULL,
    access_level TEXT NOT NULL,
    mobile_number TEXT,
    suspended BOOLEAN NOT NULL,
    password TEXT NOT NULL
);

CREATE TABLE bookmark (
    bookmark_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    description TEXT,
    author TEXT NOT NULL,
    date_created DATE NOT NULL,
    rating INTEGER,
    num_of_ratings INTEGER,
    reported BOOLEAN NOT NULL
);

CREATE TABLE comment (
    comment_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    author TEXT NOT NULL,
    date_created DATE NOT NULL,
    bookmark_id INTEGER REFERENCES bookmark(bookmark_id)
);

CREATE TABLE tag (
    tag_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    tag TEXT NOT NULL
);

CREATE TABLE bookmark_tag (
    bookmark_tag_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    bookmark_id INTEGER REFERENCES bookmark(bookmark_id)
    -- tag_id INTEGER REFERENCES tag(tag_id)
);

-- Users test data
INSERT INTO user VALUES(1, "Logan", "Miller", "lmiller6@sheffield.ac.uk", "admin", "07123456789", 0, "password");
INSERT INTO user VALUES(2, "James", "Acaster", "jamesa@gmail.com", "employee", "07111222333", 0, "pWORD1");
INSERT INTO user VALUES(3, "Jimmy", "Carr", "jimbo69@hotmail.com", "registered", "07328197892", 1, "CAPITALlower314");

-- Bookmark test data
INSERT INTO bookmark VALUES(1, "Lab results", "/lab.html", "Details of february's lab", "Logan Miller", '2020-2-10', 4, 2, 0);
INSERT INTO bookmark VALUES(2, "My website", "https://www.jimmycarr.com/", "Link to my personal data", "Jimmy Carr", '2020-3-19', 5, 31, 0);
INSERT INTO bookmark VALUES(3, "Funny jokes", "jokes.txt", "Top 100 jokes", "Jimmy Carr", '2019-12-9', 2, 10, 0);