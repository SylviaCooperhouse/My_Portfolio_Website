CREATE OR REPLACE FUNCTION schema.track_daily_user_count(p_start_date timestamp without time zone DEFAULT NULL::timestamp without time zone, p_end_date timestamp without time zone DEFAULT NULL::timestamp without time zone)
 RETURNS TABLE(transaction_date timestamp without time zone, records_removed integer, records_created integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
    DECLARE
        v_start_date_input                  timestamp without time zone;
        v_end_date_input                    timestamp without time zone;
        v_current_date                      timestamp without time zone;
        v_temp_date                         timestamp without time zone;
        
        v_start_record_num                  integer;
        v_end_record_num                    integer;
        v_user_count                        integer;
        
        v_inserted_records                  integer;
        v_deleted_records                   integer;
        v_records                           integer;
        
BEGIN
    -- Handle input date parameters
    IF p_start_date IS NULL THEN
        SELECT MAX(user_date) - interval '1 day' INTO p_start_date_input FROM schema.track_daily_user_count WHERE user_count > 0;
    END IF;
    
    v_start_date_input = p_start_date;
    
    IF p_end_date IS NULL THEN
        p_end_date := now()::date;
    END IF;
    
    v_end_date_input = p_end_date + interval '1 day';
    v_inserted_records = 0;
    v_deleted_records = 0;
    
    RAISE NOTICE 'Processing % - %', v_start_date_input, v_end_date_input;
    
    -- Loop through dates
    WHILE v_start_date_input < v_end_date_input AND v_start_date_input < NOW()::DATE LOOP
        v_current_date = v_start_date_input + interval '1 day' - interval '1 millisecond';
        
        RAISE NOTICE 'Processing % - %', v_start_date_input, v_current_date;
        
        -- Retrieve record information
        SELECT
            MIN(start_record_num),
            MAX(end_record_num)
        INTO
            v_start_record_num,
            v_end_record_num
        FROM
            record_information
        WHERE
            record_date >= v_start_date_input and 
            record_date <= v_current_date;
        
        RAISE NOTICE 'Processing: % - %, % - %', v_start_date_input, v_current_date, v_start_record_num, v_end_record_num;

        -- Insert user data
        INSERT INTO schema.track_daily_user_count (user_date, 
                                            user_count,
                                            action1,
                                            action2) 
        SELECT v_start_date_input::date,
               COUNT(distinct r.user_id) AS user_count,
               SUM(CASE WHEN r.action = 'action1' THEN 1 ELSE 0 END) AS action1,
               SUM(CASE WHEN r.action = 'action2' THEN 1 ELSE 0 END) AS action2
        FROM
               records r
        WHERE
               r.record_num BETWEEN v_start_record_num AND v_end_record_num
        ON CONFLICT (user_date) 
        DO UPDATE 
        SET user_count = excluded.user_count,
            action1 = excluded.action1,
            action2 = excluded.action2;

        GET DIAGNOSTICS v_records = row_count;
        v_inserted_records = v_inserted_records + v_records;

        -- Clean up old records
        DELETE FROM schema.user_signup_statistics WHERE signup_date BETWEEN v_start_date_input AND v_current_date;

        INSERT INTO schema.user_signup_statistics
        SELECT user_register_date AS signup_date,
               COUNT(1) FILTER (WHERE action1 = true) AS users_with_action1,
               COUNT(1) FILTER (WHERE action1 = false) AS users_without_action1,
               ROUND(COUNT(1) FILTER (WHERE action1 = 'true')::NUMERIC / COUNT(1)::NUMERIC, 6) AS conversion_rate
        FROM schema.new_user_signup_statistics
        WHERE user_register_date BETWEEN v_start_date_input AND v_current_date 
        GROUP BY 1;

        GET DIAGNOSTICS v_records = row_count;
        v_inserted_records = v_inserted_records + v_records;

        -- Return results for the current date
        RETURN QUERY
        SELECT v_start_date_input, v_deleted_records, v_inserted_records;

        v_start_date_input := v_start_date_input + interval '1 days';
    END LOOP;
        
END;
END;
$function$