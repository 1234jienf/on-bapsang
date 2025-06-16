-- init_schema.sql
CREATE DATABASE IF NOT EXISTS bapsang;
USE bapsang;
CREATE TABLE IF NOT EXISTS recipe (
  recipe_id BIGINT PRIMARY KEY,
  name VARCHAR(255),
  description TEXT
);
CREATE TABLE IF NOT EXISTS recipe_ingredient_master (
  ingredient_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) UNIQUE,
  type VARCHAR(100)
);
CREATE TABLE IF NOT EXISTS recipe_ingredient (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  recipe_id BIGINT,
  ingredient_id BIGINT,
  amount VARCHAR(100),
  FOREIGN KEY (recipe_id) REFERENCES Recipe(recipe_id),
  FOREIGN KEY (ingredient_id) REFERENCES RecipeIngredientMaster(ingredient_id)
);