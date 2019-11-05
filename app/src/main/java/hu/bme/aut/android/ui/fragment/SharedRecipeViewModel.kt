package hu.bme.aut.android.ui.fragment

import androidx.lifecycle.ViewModel
import hu.bme.aut.android.dataManager.DataManager
import hu.bme.aut.android.model.Comment
import hu.bme.aut.android.model.Recipe
import hu.bme.aut.android.model.User


class SharedRecipeViewModel : ViewModel() {

    var selectedRecipe = Recipe()

    var user = User()

    fun addComment(comment: Comment) {
        selectedRecipe.comments.add(comment.id)
    }

    fun isFavorite(): Boolean {
        return user.favorites.contains(selectedRecipe.id)
    }

    fun isCooked(): Boolean {
        return user.cooked.contains(selectedRecipe.id)
    }

    fun addFavoriteRecipe() {
        user.favorites.add(selectedRecipe.id)
        saveRecipe()
    }

    fun removeFavoriteRecipe() {
        user.favorites.remove(selectedRecipe.id)
    }

    fun addCookedRecipe() {
        user.cooked.add(selectedRecipe.id)
        saveRecipe()
    }

    fun removeCookedRecipe() {
        user.cooked.remove(selectedRecipe.id)
    }

    fun addMyRecipe(recipe: Recipe) {
        user.myRecipes.add(recipe.id)
        saveRecipe()
    }

    fun removeMyRecipe(recipe: Recipe) {
        user.myRecipes.remove(recipe.id)
    }

    fun loadRecipes(): Boolean {
        return DataManager.loadRecipes()
    }

    fun loadFavorites(): Boolean {
        return DataManager.loadList(user.favorites)
    }

    fun loadCooked(): Boolean {
        return DataManager.loadList(user.cooked)
    }

    fun loadMyRecipes(): Boolean {
        return DataManager.loadList(user.myRecipes)
    }

    private fun saveRecipe() {
        DataManager.addRecipe(selectedRecipe)
        DataManager.addSaved(selectedRecipe)
    }


}