# Responsible of keeping all the ingredients, organized in categories. It's initialized with a json.
module MealPlanner
  class IngredientsBook
    def initialize(ingredients_json)
      ingredients = JSON.parse(ingredients_json, symbolize_names: true)

      @all_ingredients_by_kind = {}
      [:carb, :protein, :veggie].each do |kind|
        @all_ingredients_by_kind[kind] = ingredients
          .filter { |ingredient| ingredient[:kind] == kind.to_s }
          .map do |ingredient|
            Ingredient.new(
              name: ingredient[:name],
              kind: ingredient[:kind],
              quantity_for_lunch: ingredient[:quantity_for_lunch],
              quantity_for_dinner: ingredient[:quantity_for_dinner]
            )
          end
      end
    end

    def carbs
      @all_ingredients_by_kind[:carb]
    end

    def proteins
      @all_ingredients_by_kind[:protein]
    end

    def veggies
      @all_ingredients_by_kind[:veggie]
    end
  end
end