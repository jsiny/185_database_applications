INSERT INTO expenses (amount, memo, created_on)
VALUES (-9999.99, 'Smallest value', CURRENT_DATE);

INSERT INTO expenses (amount, memo, created_on)
VALUES (-10000.00, 'Too small', CURRENT_DATE);

-- ERROR:  numeric field overflow
-- DETAIL:  A field with precision 6, scale 2 must round to an absolute value less than 10^4.