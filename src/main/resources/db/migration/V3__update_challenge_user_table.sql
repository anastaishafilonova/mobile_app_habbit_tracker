ALTER TABLE challenge_user
    ADD COLUMN IF NOT EXISTS progress_days INT DEFAULT 0;

ALTER TABLE challenge_user
    ADD COLUMN IF NOT EXISTS last_check_date DATE;

ALTER TABLE challenge_user
    ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'ACTIVE';
