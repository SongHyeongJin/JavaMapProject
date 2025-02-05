USE mapprojectdb;

create table record (
    num int not null auto_increment,
    id varchar(100) binary not null,
    address varchar(100) not null,
    lat double not null,
    lng double not null,
    Date date not null,
    subject varchar(100) not null,
    context Text,    
    PRIMARY KEY (num),
    FOREIGN KEY (id) REFERENCES member(id) ON DELETE CASCADE
) default CHARSET=utf8;

select * from record;
drop table record;