ALTER TABLE Recipes ADD COLUMN plus_up_ingredient_id INTEGER;

INSERT INTO Recipes (object_name, video_url, website_url, score, plus_up, plus_up_score, plus_up_ingredient_id, publish_date, source_id)
VALUES ('Bacon, Cheese, and Ketchup Sandwich', 'https://www.youtube.com/watch?v=2jMlN1I2Nkw', NULL, 7, "Overeasy egg", 8.5, 8, '2023-05-12', 1);
