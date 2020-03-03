CREATE TABLE user (
    user_id INTEGER NOT NULL PRIMARY KEY,
    forname TEXT NOT NULL,
    surname TEXT NOT NULL,
    email TEXT NOT NULL,
    access_level TEXT NOT NULL,
    mobile_number TEXT,
    suspended BOOLEAN NOT NULL,
    password TEXT NOT NULL
);

CREATE TABLE bookmark (
    bookmark_id INTEGER NOT NULL PRIMARY KEY,
    title TEXT NOT NULL,
    image TEXT,
    content TEXT NOT NULL,
    description TEXT,
    author TEXT NOT NULL,
    date_created DATE NOT NULL,
    rating INTEGER,
    num_of_ratings INTEGER,
    reported BOOLEAN NOT NULL
);

CREATE TABLE comment (
    comment_id INTEGER NOT NULL PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    author TEXT NOT NULL,
    date_created DATE NOT NULL,
    bookmark_id INTEGER REFERENCES bookmark(bookmark_id) FORIEGN KEY
);

CREATE TABLE tag (
    tag_id INTEGER NOT NULL PRIMARY KEY,
    tag TEXT NOT NULL
);

CREATE TABLE bookmark_tag (
    bookmark_tag_id INTEGER NOT NULL PRIMARY KEY,
    bookmark_id INTEGER REFERENCES bookmark(bookmark_id) FORIEGN KEY
    tag_id INTEGER REFERENCES tag(tag_id) FORIEGN KEY
);


INSERT INTO user VALUES(1, "Jimmy", "Carr", "jimbo@gmail.com", "07382193828", "123");
INSERT INTO user VALUES(2, "James", "Acaster", "mra@hotmail.com", "07281829302", "my super secret password");

