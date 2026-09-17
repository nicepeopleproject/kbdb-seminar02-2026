-- =====================================================================
--  V1 — первая версия схемы вашего проекта.
--  Применить:  make migrate        Снести и применить заново:  make migrate-reset
--  После применения V1 НЕ редактируется — изменения идут в V2, V3, ...
-- =====================================================================
create schema if not exists project;
set search_path = project;

-- Справочники — первыми: на них ссылаются остальные таблицы.
-- create table unit_kind (
--     code  text primary key,          -- 'gas_compressor', 'pump', ...
--     name  text not null
-- );

-- Основные сущности.
-- create table station (
--     id      int  generated always as identity primary key,
--     code    text not null unique,
--     name    text not null,
--     region  text not null
-- );
-- comment on table station is 'Площадка, на которой стоит оборудование';

-- create table unit (
--     id            int  generated always as identity primary key,
--     code          text not null unique,
--     station_id    int  not null references station(id),
--     kind          text not null references unit_kind(code),
--     model         text not null,
--     commissioned  date not null,
--     created_at    timestamptz not null default now()
-- );

-- Таблицы связи для M:N — с составным ключом и атрибутами связи.
-- create table maintenance_part (
--     maintenance_id int not null references maintenance(id),
--     part_id        int not null references part(id),
--     qty            int not null check (qty > 0),
--     primary key (maintenance_id, part_id)
-- );

-- Тестовые данные — 3–5 строк, чтобы схему можно было «пощупать».
-- insert into station (code, name, region) values ('N', 'Северная', 'Ямал');
