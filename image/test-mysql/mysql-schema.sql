create database test;
use test;
CREATE TABLE `user`
(
    `id`     bigint       NOT NULL primary key,
    username varchar(64)  not null,
    password varchar(256) not null
);