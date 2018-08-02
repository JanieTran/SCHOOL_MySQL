drop table if exists wrote_book, wrote_chapter, chapter, book, author, publisher;

create table author (
  author_id     integer,
  first_name    varchar(30),
  middle_name   varchar(30),
  last_name     varchar(30),
  email         varchar(50),
  phone         varchar(15),
  address       varchar(50),
  constraint pk_author primary key (author_id)
);

create table publisher (
  publisher_id  integer,
  name          varchar(30),
  email         varchar(50),
  phone         varchar(15),
  address       varchar(50),
  constraint pk_publisher primary key (publisher_id)
);

create table book (
  book_id       integer,
  isbn          varchar(13),
  title         varchar(50),
  publisher     integer,
  pub_date      date,
  edition       integer,
  constraint pk_book primary key (book_id),
  constraint fk_book_from_publisher
      foreign key (publisher) references publisher(publisher_id)
          on delete cascade on update cascade
);

create table chapter (
  chapter_number  integer,
  book            integer,
  title           varchar(50),
  contents        varchar(1000),
  constraint pk_chapter primary key (chapter_number, book),
  constraint fk_chapter_in_book
      foreign key (book) references book(book_id)
          on delete cascade on update cascade
);

create table wrote_book (
  author          integer,
  book            integer,
  constraint pk_wrote_book primary key (author, book),
  constraint fk_wrote_book_from_author
      foreign key (author) references author(author_id)
          on delete cascade on update cascade,
  constraint fk_wrote_book_from_book
      foreign key (book) references book(book_id)
          on delete cascade on update cascade
);

create table wrote_chapter (
  author      integer,
  chapter     integer,
  book        integer,
  constraint pk_wrote_chapter primary key (author, chapter, book),
  constraint fk_wrote_chapter_from_author
      foreign key (author) references author(author_id)
          on delete cascade on update cascade,
  constraint fk_wrote_chapter_from_chapter
      foreign key (chapter, book) references chapter(chapter_number, book)
          on delete cascade on update cascade
);

insert into author (author_id, first_name, middle_name, last_name, email, phone, address) values
    (1001, 'Agatha', 'Mary Clarissa', 'Christie', 'agatha.christie@gmail.com', '18901509', 'Oxfordshire, England'),
    (1002, 'Dan', 'Gerhard', 'Brown', 'dan.brown@gmail.com', '19642206', 'New Hampshire, US');

insert into publisher (publisher_id, name, email, phone, address) values
    (2001, 'St Martin Press', 'publicity@stmartins.com', '212-674-6132', 'New York, US'),
    (2002, 'Pocket Books', 'publicity@pocketbooks.com', '121-467-1236', 'New York, US');

insert into book (book_id, isbn, title, publisher, pub_date, edition) values
    (3001, '0312330871', 'And Then There Were None', 2001, '2004-04-03', 10),
    (3002, '1416524797', 'Angels and Demons', 2002, '2006-04-01', 6);

insert into chapter (chapter_number, book, title, contents) values
    (4001, 3001, 'Chapter 1', 'Justice Wargrave, a recently retired judge, is taking a train to the seaside town of Sticklehaven, where he is to catch a boat to Indian Island.'),
    (4002, 3002, 'Chapter 2', 'Langdon tried to gather his thoughts. His book was virtually unknown in mainstream literary circles, but it had developed quite a following on—line');

insert into wrote_book (author, book) values
    (1001, 3001),
    (1002, 3002);

insert into wrote_chapter (author, chapter, book) values
    (1001, 4001, 3001),
    (1002, 4002, 3002);

commit;