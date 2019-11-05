package hu.bme.aut.android.dataManager.network.helper

import hu.bme.aut.android.model.Meal
import hu.bme.aut.android.model.Recipe

class RecipeMapper {
    companion object {
        fun mealConvertToRecipe(meal: Meal): Recipe {
            val ingredients = mutableMapOf<String, String>()
            ingredients[meal.strIngredient1] = meal.strMeasure1
            ingredients[meal.strIngredient2] = meal.strMeasure2
            ingredients[meal.strIngredient3] = meal.strMeasure3
            ingredients[meal.strIngredient4] = meal.strMeasure4
            ingredients[meal.strIngredient5] = meal.strMeasure5
            ingredients[meal.strIngredient6] = meal.strMeasure6
            ingredients[meal.strIngredient7] = meal.strMeasure7
            ingredients[meal.strIngredient8] = meal.strMeasure8
            ingredients[meal.strIngredient9] = meal.strMeasure9
            ingredients[meal.strIngredient10] = meal.strMeasure10
            ingredients[meal.strIngredient11] = meal.strMeasure11
            ingredients[meal.strIngredient12] = meal.strMeasure12
            ingredients[meal.strIngredient13] = meal.strMeasure13
            ingredients[meal.strIngredient14] = meal.strMeasure14
            ingredients[meal.strIngredient15] = meal.strMeasure15
            ingredients[meal.strIngredient16] = meal.strMeasure16
            ingredients[meal.strIngredient17] = meal.strMeasure17
            ingredients[meal.strIngredient18] = meal.strMeasure18
            ingredients[meal.strIngredient19] = meal.strMeasure19
            ingredients[meal.strIngredient20] = meal.strMeasure20
            ingredients.remove("")
            return Recipe(
                id = meal.idMeal,
                name = meal.strMeal,
                imgURL = meal.strMealThumb,
                ingredients = ingredients,
                category = meal.strCategory,
                area = meal.strArea,
                instruction = meal.strInstructions,
                comments = mutableListOf(),
                image = ""
            )
        }
    }
}