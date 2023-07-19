ALTER TABLE RecipeIngredients ADD COLUMN quantity TEXT;
ALTER TABLE RecipeIngredients ADD COLUMN specification TEXT;

INSERT INTO Sources (object_name, website_url, youtube_url, long_description, photo)
VALUES ('Sandwiches of History', 'https://www.sandwichesofhistory.com/', 'https://www.youtube.com/@SandwichesofHistory', 'Making sandwiches from old recipe books and plussing them up for the modern palate.', NULL);

