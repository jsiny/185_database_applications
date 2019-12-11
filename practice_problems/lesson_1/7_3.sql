DELETE FROM expenses
 WHERE amount < 0;

ALTER TABLE expenses
  ADD CONSTRAINT positive_amount
      CHECK (amount >= 0.01);