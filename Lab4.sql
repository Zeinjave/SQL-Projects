select * from Customers;

CREATE OR REPLACE TRIGGER trg_salary_diff
AFTER INSERT OR UPDATE OR DELETE ON Customers
FOR EACH ROW
DECLARE
    salary_diff NUMBER;
BEGIN
    IF INSERTING THEN
        DBMS_OUTPUT.PUT_LINE('INSERT: New Salary = ' || :NEW.salary);

    ELSIF DELETING THEN
        DBMS_OUTPUT.PUT_LINE ('DELETE: Old Salary = ' || :OLD.salary);

    ELSIF UPDATING THEN
        salary_diff := :NEW.salary - :OLD.salary;
        DBMS_OUTPUT.PUT_LINE ('UPDATE: Salary difference = ' || salary_diff);
    END IF;
END;
/

DECLARE
    -- Declare variables to hold address and customers count
    v_address VARCHAR2(100);
    v_count NUMBER;

    -- Cursor to get address and count of customers grouped by address
    CURSOR adrss_cursor IS
        SELECT address, COUNT(id) AS cust_count
        FROM customers
        GROUP BY address;
    BEGIN
        -- Open cursor
        OPEN adrss_cursor;

        -- Loop each row
        LOOP
            FETCH adrss_cursor INTO v_address, v_count;
            EXIT WHEN adrss_cursor%NOTFOUND;

            -- Print address and count
            DBMS_OUTPUT.PUT_LINE('Address: ' || v_address || ' - Customer Count: ' || v_count);
        END LOOP;

    -- Close cursor
    CLOSE adrss_cursor;
END;
/