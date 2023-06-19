CREATE OR REPLACE PACKAGE XXPHA_eam555_PKG IS
/* $Id: XX_eam555_PKG.sql 1.0 xx/xx/xxxx-00:00 login $ */

-----------------------------------------------------------------------------
-- Процедура ручного запуска.
-----------------------------------------------------------------------------
PROCEDURE main( p_errbuf            OUT NOCOPY VARCHAR2                                        -- описание ошибки
                , p_retcode         OUT NOCOPY VARCHAR2                                        -- код ошибки
              );

END XXPHA_eam555_PKG;
/
CREATE OR REPLACE PACKAGE BODY XXPHA_eam555_PKG IS
/* $Id: XX_eam555_PKG.sql 1.0 xx/xx/xxxx-00:00 login $ */

    g_org_id           CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'ORG_ID' ) );                        -- Операционная единица на пользователе минуя профиль защиты
    g_resp_id          CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'RESP_ID' ) );                       -- Полномочие
    g_user_id          CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'USER_ID' ) );                       -- Пользователь
    g_login_id         CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'LOGIN_ID' ) );                      -- Логин
    g_mfg_org          CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'MFG_ORGANIZATION_ID' ) );           -- Текущая организация
    g_ou_security      CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'XLA_MO_SECURITY_PROFILE_LEVEL' ) ); -- Профиль защиты операционных единиц
    g_org_security     CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'PER_SECURITY_PROFILE_ID' ) );       -- Профиль защиты организаций
    g_errbuf                    VARCHAR2( 4000 ) := NULL;                                                          -- Описание ошибки
    g_retcode                   VARCHAR2( 1 )    := '0';                                                           -- Код ошибки

    -- Для отладки в реальном времени
/*
   PROCEDURE xxpha_log( p_msg    IN VARCHAR2
                         , p_type IN VARCHAR2 DEFAULT 'T'
                       )
    is
    BEGIN
        xxpha_pnaumov_pkg.gb_log_mark := 'eam555';
        xxpha_pnaumov_pkg.insert_log_table( p_msg );
    END xxpha_log;
*/

-----------------------------------------------------------------------------
-- Процедура ручного запуска.
-----------------------------------------------------------------------------
PROCEDURE main( p_errbuf            OUT NOCOPY VARCHAR2                                        -- описание ошибки
                , p_retcode         OUT NOCOPY VARCHAR2                                        -- код ошибки                                                                             
              )
is
    v_instance_name       VARCHAR2( 256 );                                                     -- Имя экземпляра, на котором запущена параллельная программа
    v_report_start        DATE             := sysdate;                                         -- Дата начала отчёта
BEGIN

    xxpha_log( 'Начало работы разработки.', 'T' );
    xxpha_log( 'Версия 1.0', 'T' );
    xxpha_log( 'Дата изменения xx.xx.xxxx', 'T' );

    xxpha_log( 'Входные параметры:', 'T' );
 
    xxpha_log( 'Полномочия                          => ' || g_resp_id, 'T' );
    xxpha_log( ' ', 'S' );
    xxpha_log( 'Операционная единица                => ' || g_org_id, 'T' );
    xxpha_log( 'Пользователь                        => ' || g_user_id, 'T' );
    xxpha_log( 'Логин                               => ' || g_login_id, 'T' );
    xxpha_log( 'Организация                         => ' || g_mfg_org, 'T' );
    xxpha_log( 'Профиль защиты операционная единица => ' || g_ou_security, 'T' );
    xxpha_log( 'Профиль защиты организация          => ' || g_org_security, 'T' );

    BEGIN
        SELECT
            t.instance_name
        INTO
            v_instance_name -- Имя экземпляра, на котором запущена параллельная программа
        FROM
            apps.fnd_database_instances t;

        xxpha_log( 'Инстанс                             => ' || v_instance_name, 'T' );
    EXCEPTION when others then
        BEGIN
            SELECT
                a.value
            INTO
                v_instance_name -- Имя экземпляра, на котором запущена параллельная программа
            FROM
                v$parameter a
            WHERE
                1 = 1
                and a.name = 'local_listener';

            xxpha_log( 'Инстанс                             => ' || v_instance_name, 'T' );
        EXCEPTION when others then
            xxpha_log( 'Инстанс не найден.', 'T' );
        END;
    END;

    -- Настройка параметров возврата
    p_errbuf  := g_errbuf;
    p_retcode := g_retcode;

    xxpha_log( ' ' );
    xxpha_log( 'Конец работы разработки.', 'T' );

EXCEPTION when others then
    p_errbuf := sqlerrm;
    p_retcode := '2'; --Ошибка

    xxpha_log( 'Ошибка в работе разработки.', 'T' );
    xxpha_log( ' ', 'E' );
END main;

END XXPHA_eam555_PKG;
/
SHOW ERRORS