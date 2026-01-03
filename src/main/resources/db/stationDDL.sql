use rms1;
drop table if exists station;
create table station
(
    station_id   int          not null auto_increment,
    station_name varchar(255) not null,
    station_code     varchar(255) not null unique,
    latitude     double       not null,
    longitude    double       not null,
    platform_count int          not null,
    primary key (station_id)
);