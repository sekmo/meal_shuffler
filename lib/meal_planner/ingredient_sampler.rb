# Responsible for yielding the possible ingredients for a new meal, given that we pass all the
# available ingredients, some rules, and the meals we currently have in our weekly plan.
module MealPlanner
  class IngredientSampler
    attr_reader :ingredients_book, :max_weekly_ingredient_frequency
    def initialize(ingredients_book, max_weekly_ingredient_frequency)
      @max_weekly_ingredient_frequency = max_weekly_ingredient_frequency
      @ingredients_book = ingredients_book
    end

    def sample(ingredient_kind, current_meals)
      if ingredient_kind == :carb
        (carbs_that_respect_the_weekly_frequency_rule(current_meals) &
          carbs_that_respect_the_last_2_meals_rule(current_meals)).sample
      elsif ingredient_kind == :protein
        (proteins_that_respect_the_weekly_frequency_rule(current_meals) &
          proteins_that_respect_the_last_2_meals_rule(current_meals)).sample
      else
        (veggies_that_respect_the_weekly_frequency_rule(current_meals) &
          veggies_that_respect_the_last_2_meals_rule(current_meals)).sample
      end
    end

    private

    def ingredients_in_our_current_meals_by_kind(kind, current_meals)
      current_meals.map(&kind).compact
    end

    def carbs_that_respect_the_weekly_frequency_rule(current_meals)
      ingredients_book.carbs.select do |carb|
        max_frequency_for_carb = max_weekly_ingredient_frequency.find { |rule| rule[:ingredient] == carb.name}&.fetch(:times)
        !max_frequency_for_carb || ingredients_in_our_current_meals_by_kind(:carb, current_meals).count(carb) < max_frequency_for_carb
      end
    end

    def proteins_that_respect_the_weekly_frequency_rule(current_meals)
      ingredients_book.proteins.select do |protein|
        max_frequency_for_protein = max_weekly_ingredient_frequency.find { |rule| rule[:ingredient] == protein.name}&.fetch(:times)
        !max_frequency_for_protein || ingredients_in_our_current_meals_by_kind(:protein, current_meals).count(protein) < max_frequency_for_protein
      end
    end

    def veggies_that_respect_the_weekly_frequency_rule(current_meals)
      ingredients_book.veggies.select do |veggie|
        max_frequency_for_veggie = max_weekly_ingredient_frequency.find { |rule| rule[:ingredient] == veggie.name}&.fetch(:times)
        !max_frequency_for_veggie || ingredients_in_our_current_meals_by_kind(:veggie, current_meals).count(veggie) < max_frequency_for_veggie
      end
    end

    def carbs_in_our_last_2_meals(current_meals)
      current_meals.last(2).map(&:carb).compact
    end

    def proteins_in_our_last_2_meals(current_meals)
      current_meals.last(2).map(&:protein).compact
    end

    def veggies_in_our_last_2_meals(current_meals)
      current_meals.last(2).map(&:veggie).compact
    end

    def carbs_that_respect_the_last_2_meals_rule(current_meals)
      ingredients_book.carbs - carbs_in_our_last_2_meals(current_meals)
    end

    def proteins_that_respect_the_last_2_meals_rule(current_meals)
      ingredients_book.proteins - proteins_in_our_last_2_meals(current_meals)
    end

    def veggies_that_respect_the_last_2_meals_rule(current_meals)
      ingredients_book.veggies - veggies_in_our_last_2_meals(current_meals)
    end
  end
end
