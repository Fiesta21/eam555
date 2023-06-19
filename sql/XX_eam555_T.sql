-----------------------------------------------
-- ООО «ИЦ ФосАгро», xx.xx.xxxx
-- Создал
--   user xx.xx.xxxx
-- Имя
--   XX_eam555_T.sql
-- Версия
--   1.0
-- Описание
--   Временная таблица 
-- Изменения
-----------------------------------------------
DECLARE
    v_find NUMBER;
BEGIN
    SELECT
        1
    INTO
        v_find
    FROM
        sys.all_objects ao
    WHERE
        1 = 1
        and ao.OWNER = 'XXPHA'
        and ao.OBJECT_NAME = 'XXPHA_eam555_T'
        and ao.OBJECT_TYPE = 'TABLE';
    EXECUTE IMMEDIATE 'DROP TABLE XXPHA.XXPHA_eam555_T';
EXCEPTION when no_data_found then
    NULL;
END;
/

CREATE GLOBAL TEMPORARY TABLE XXPHA.XXPHA_eam555_T -- Временная таблица 
(
      a            DATE                             -- ???
    , b            NUMBER                           -- ???
    , c            VARCHAR2( 40 )                   -- ???
) ON COMMIT PRESERVE ROWS;

COMMENT ON TABLE XXPHA.XXPHA_eam555_T is 'Версия 1.0. Временная таблица';

COMMENT ON COLUMN XXPHA.XXPHA_eam555_T.a is '???';

COMMENT ON COLUMN XXPHA.XXPHA_eam555_T.b is '???';

COMMENT ON COLUMN XXPHA.XXPHA_eam555_T.c is '???';
