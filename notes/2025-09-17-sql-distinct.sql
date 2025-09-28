-- tables
CREATE TABLE questions (
    id SERIAL PRIMARY KEY,
    question VARCHAR(256) NOT NULL,
    options VARCHAR(64)[] NOT NULL
);

CREATE TABLE answers (
    response_id SERIAL NOT NULL,
    question_id INTEGER REFERENCES questions(id),
    answer VARCHAR(64),
    PRIMARY KEY (response_id, question_id)
);

-- toy data
INSERT INTO questions (question, options)
VALUES
    ('How old are you?', ARRAY['0-17', '18+']),
    ('What is your favorite season?', ARRAY['Winter', 'Spring', 'Summer', 'Fall']),
    ('What programming language do you like the best?', ARRAY['C', 'Java', 'Python']);

INSERT INTO answers (response_id, question_id, answer)
VALUES
    (0, 1, '0-17'),
    (0, 2, 'Fall'),
    (1, 1, '18+'),
    (1, 2, 'Spring'),
    (2, 1, '18+'),
    (2, 2, 'Winter'),
    (3, 1, '18+'),
    (3, 2, 'Fall'),
    (4, 1, '18+'),
    (4, 2, 'Spring');

-- select all adults
SELECT response_id FROM answers WHERE question_id = 1 AND answer = '18+';

-- count responses for adults
WITH adults AS (SELECT response_id FROM answers WHERE question_id = 1 AND answer = '18+')
SELECT COUNT(*) AS response_count, question_id, answer FROM
    (SELECT * FROM adults JOIN answers ON adults.response_id = answers.response_id)
GROUP BY question_id, answer
ORDER BY response_count DESC;

-- try to get max count along with the answer
WITH
    adults AS (SELECT response_id FROM answers WHERE question_id = 1 AND answer = '18+'),
    counts AS (SELECT COUNT(*) AS response_count, question_id, answer FROM
            (SELECT * FROM adults JOIN answers ON adults.response_id = answers.response_id)
        GROUP BY question_id, answer
        ORDER BY response_count DESC)
SELECT answer, questions.question, MAX(response_count) 
    FROM counts JOIN questions ON counts.question_id = questions.question_id;

-- 
WITH
    adults AS (SELECT response_id FROM answers WHERE question_id = 1 AND answer = '18+'),
    counts AS (SELECT COUNT(*) AS response_count, question_id, answer FROM
            (SELECT * FROM adults JOIN answers ON adults.response_id = answers.response_id)
        GROUP BY question_id, answer
        ORDER BY response_count DESC)
SELECT DISTINCT ON (question_id) question, answer, response_count
    FROM counts JOIN questions ON counts.question_id = questions.id;