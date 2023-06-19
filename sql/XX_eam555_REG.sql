-----------------------------------------------
-- ООО «ИЦ ФосАгро», xx.xx.xxxx
-- Создал 
--  Фио  xx.xx.xxxx
-- Имя
--   XX_eam555_REG.sql
-- Версия
--   1.0
-- Описание
--   Добавить описание
-- Изменения
-----------------------------------------------
SET SERVEROUTPUT ON

DECLARE
    g_appl_short_name       CONSTANT VARCHAR2( 8 )   := 'XXPHA';

    g_cust_name             CONSTANT VARCHAR2( 128 ) := 'Добавить имя';
    g_cust_file_name        CONSTANT VARCHAR2( 32 )  := 'XXPHA_eam555_PKG.main';
    g_cust_short_name       CONSTANT VARCHAR2( 16 )  := 'XXPHA_eam555';

    g_cust_desc             CONSTANT VARCHAR2( 128 ) := 'Добавить описание';

    g_cust_execution_method CONSTANT VARCHAR2( 32 )  := 'PL/SQL Stored Procedure';

    g_resp_list             VARCHAR2( 128 )          := 'Системный администратор';

    -- Список зависимых и независимых наборов значений для выборки входных параметров
    g_value_set_name1       CONSTANT VARCHAR2( 32 )  := 'XXPHA_eam555_PERIOD';        -- Набор значений "Период с", "Период по"
    g_value_set_name2       CONSTANT VARCHAR2( 32 )  := 'XXPHA_HR_OU_SECURED';        -- Набор значений "Операционная единица"

    TYPE XXPHA_eam555_PROCESS_TYPE IS TABLE OF VARCHAR2( 256 ) INDEX BY BINARY_INTEGER;

    t_perms_values XXPHA_eam555_PROCESS_TYPE;                                                                  -- Список полномочий по умолчанию

    vr_no                   INTEGER;                                                                          -- Счётчик параметров cancurrenta
BEGIN
    -- Коллекция полномочий по умолчанию
    t_perms_values( 1 ) := 'Системный администратор';

    dbms_output.enable( 1000000 );

    fnd_flex_val_api.set_session_mode( session_mode => 'customer_data' );                                     -- ???

    --1) Создание заголовка параллельной программы
    XXPHA_CREATE_CONC.bild_header( p_appl_short_name         => g_appl_short_name
                                   , p_cust_short_name       => g_cust_short_name
                                   , p_cust_name             => g_cust_name
                                   , p_cust_desc             => g_cust_desc
                                   , p_cust_file_name        => g_cust_file_name
                                   , p_cust_execution_method => g_cust_execution_method
                                   , p_output_type           => 'XML'                                        -- Отчёт не нужен
                                   , p_resp_list             => g_resp_list
                                   , p_delete_conc           => 'Y'                                          --При 'Y' идёт пересоздание параллельной программы
                                 );

    -- 2.1) Создание зависимого набора значений "Период с", "Период по"
    XXPHA_CREATE_CONC.bild_table_value_set( p_value_set_name        => g_value_set_name1
                                            , p_description         => 'Период'
                                            , p_table               => 'apps.xxpha_calendar_v v'
                                            , p_value_column_name   => 'v.period_num'
                                            , p_value_column_type   => 'C'
                                            , p_value_column_size   => 25
                                            , p_meaning_column_name => NULL
                                            , p_meaning_column_type => NULL
                                            , p_meaning_column_size => NULL
                                            , p_id_column_name      => 'v.start_date'
                                            , p_id_column_type      => 'D'
                                            , p_id_column_size      => 10
                                            , p_enable_longlist     => 'N'
                                            , p_where_order_by      => 'WHERE ' || CHR( 10 ) ||
                                                                       '    1 = 1 ' || CHR( 10 ) ||
                                                                       '    and start_date >= to_date( ''2017/01/01'', ''YYYY/MM/DD'' ) ' || CHR( 10 ) ||
                                                                       'ORDER BY ' || CHR( 10 ) ||
                                                                       '    v.start_date '
                                            , p_additional_columns  => NULL
                                            , p_maximum_size        => 200
                                          );

    --3.2) Добавление параметра 'Операционная единица'
    XXPHA_CREATE_CONC.add_parametr( p_parameter               => 'P_OU'
                                    , p_description           => 'Операционная единица'
                                    , p_value_set             => g_value_set_name2
                                    , p_default_type          => NULL
                                    , p_default_value         => NULL
                                    , p_required              => 'Y'
                                    , p_display               => 'Y'
                                    , p_display_size          => 15
                                    , p_description_size      => 19
                                    , p_conc_description_size => 19
                                    , p_prompt                => 'Введите операционную единицу'
                                    , p_token                 => NULL
                                  );

    --3.1) Добавление параметра 'Период с'
    XXPHA_CREATE_CONC.add_parametr( p_parameter               => 'P_PERIOD_BEGIN'
                                    , p_description           => 'Период с'
                                    , p_value_set             => g_value_set_name1
                                    , p_default_type          => 'S'
                                    , p_default_value         => 'SELECT to_char( sysdate, ''yyyy_Mon'' ) period_num FROM sys.dual'
                                    , p_required              => 'Y'
                                    , p_display               => 'Y'
                                    , p_display_size          => 8
                                    , p_description_size      => 19
                                    , p_conc_description_size => 19
                                    , p_prompt                => 'Период с'
                                    , p_token                 => NULL
                                  );

    --Создание XML 'XSL-XML'
    XXPHA_CREATE_CONC.bild_xml( 'XSL-XML' );

    -- Если разработка не стояла нигде, то процедура, устанавливающая разработку на фиксированные полномочия
    BEGIN
        dbms_output.put_line( 'Add program to responsibilities.' );
        if t_perms_values.count > 0 then
            vr_no := t_perms_values.first;
            loop
                XXPHA_CREATE_CONC.add_resp_to_conc( p_conc_name => g_cust_short_name, p_pesp_name => t_perms_values( vr_no ) );
                vr_no := t_perms_values.next( vr_no );
                exit when vr_no is NULL;
            end loop;
        end if;
    EXCEPTION when others then
        -- Ну, не удалось в полномочия поставить, ничего страшного, может уже и нет полномочий, чтоб администраторы лишний раз не волновались из-за ошибок.
        NULL;
    END;

    COMMIT;
EXCEPTION when others then
    dbms_output.put_line( substr( 'Error: ' || fnd_program.message, 1, 255 ) );
    dbms_output.put_line( SQLERRM );
    dbms_output.put_line( dbms_utility.format_error_backtrace );
    dbms_output.put_line( APPS.FND_PROGRAM.message );
    dbms_output.put_line( APPS.FND_FLEX_VAL_API.message );
    RAISE;
END;
/
SHOW ERRORS