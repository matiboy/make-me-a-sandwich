CREATE TABLE Ingredients (
  id INTEGER PRIMARY KEY,
  object_name TEXT,
  category TEXT
);
CREATE TABLE Sources (
  id INTEGER PRIMARY KEY,
  object_name TEXT,
  website_url TEXT,
  youtube_url TEXT,
  long_description TEXT,
  short_description TEXT,
  photo BLOB
);
CREATE TABLE Recipes (
  id INTEGER PRIMARY KEY,
  object_name TEXT,
  video_url TEXT,
  website_url TEXT,
  score REAL(3,1),
  plus_up INTEGER,
  plus_up_score REAL(3,1),
  publish_date DATE,
  photo BLOB,
  source_id INTEGER,
  FOREIGN KEY (source_id) REFERENCES Sources (id)
);
CREATE TABLE RecipeIngredients (
  recipe_id INTEGER,
  ingredient_id INTEGER,
  PRIMARY KEY (recipe_id, ingredient_id),
  FOREIGN KEY (recipe_id) REFERENCES Recipes (id),
  FOREIGN KEY (ingredient_id) REFERENCES Ingredients (id)
);
CREATE INDEX idx_ingredients_object_name ON Ingredients (object_name);
