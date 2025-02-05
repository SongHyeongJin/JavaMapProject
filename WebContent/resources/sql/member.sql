USE mapprojectdb;

create table member ( 
    id varchar(100) binary not null,
    name varchar(100) binary not null,
    password varchar(100) binary not null,    
    primary key(id) 
) default CHARSET=utf8;

select * from member;
drop table member;
