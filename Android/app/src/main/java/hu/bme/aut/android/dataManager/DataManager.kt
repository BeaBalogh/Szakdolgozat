package hu.bme.aut.android.dataManager

import android.util.Base64
import android.util.Log
import com.google.android.gms.common.util.IOUtils
import hu.bme.aut.android.ui.activity.MainActivity
import hu.bme.aut.android.dataManager.database.RecipeDatabase
import hu.bme.aut.android.ui.fragment.RecipeListFragment
import hu.bme.aut.android.ui.fragment.SharedRecipeViewModel
import hu.bme.aut.android.model.Recipe
import hu.bme.aut.android.dataManager.network.RecipeInteractor
import hu.bme.aut.android.dataManager.network.RecipeService
import java.net.URL


object DataManager {
    var recipes: MutableList<Recipe> = mutableListOf()
    private var saved: MutableList<Recipe> = mutableListOf()
    var savedRecipes: MutableList<Recipe> = mutableListOf()
    var fr: RecipeListFragment? = null
    private val recipeInteractor = RecipeInteractor()
    private val recipeService = RecipeService()
    lateinit var db: RecipeDatabase
    var viewModel: SharedRecipeViewModel? = null


    fun addSaved(recipe: Recipe) {
        if (!saved.contains(recipe))
            saved.add(recipe)
        recipeService.saveRecipe(recipe)
    }

    fun deleteRecipe(recipe:Recipe){
        saved.remove(recipe)
        recipeService.deleteRecipe(recipe.id)
    }
    fun addRecipe(r: Recipe) {
        val recipe = Recipe(
            r.id,
            r.name,
            r.imgURL,
            r.ingredients,
            r.category,
            r.area,
            r.instruction,
            r.comments,
            r.image
        )
        if (MainActivity.isNetworkAvailable)
            if (recipe.imgURL.contains("http")) {
                Thread {
                    val b = IOUtils.toByteArray(URL(recipe.imgURL).openStream()) //idiom
                    recipe.image = Base64.encodeToString(b, Base64.DEFAULT)
                    URL(recipe.imgURL).openStream().close()

                    db.recipeDao().insertAll(recipe)
                }.start()

            } else {
                recipeService.getImage(recipe.imgURL).addOnSuccessListener {
                    Log.d("IMAGEURL", recipe.imgURL)
                    recipe.image = Base64.encodeToString(it, Base64.DEFAULT)
                    Thread {
                        db.recipeDao().insertAll(recipe)
                    }.start()
                }
            }

    }

    fun loadRandom(): Boolean {
        if (MainActivity.isNetworkAvailable && recipes.isEmpty()) {
            recipeInteractor.random(onSuccess = this::returnList)
        }

        return true
    }

    fun loadRecipes(name: String): Boolean {
        if (name != "")
            recipeInteractor.serachByName(name, onSuccess = this::returnList)
        return true
    }

    fun loadSaved(): Boolean {
        if (saved.isEmpty()) {
            if (MainActivity.isNetworkAvailable) {
                val get = recipeService.getRecipes()
                get.addOnSuccessListener { snapshot ->
                    for (data in snapshot.documents) {
                        val recipe = data.toObject(Recipe::class.java)
                        if (recipe != null) {
                            saved.add(recipe)
                        }
                    }
                }
            } else {
                Thread {
                    try {
                        val list = db.recipeDao().loadAll()
                        saved.addAll(list)
                    } catch (e: Exception) {
                    }
                }.start()
            }
        }
        return true
    }

    fun loadList(idList: List<String>): Boolean {
        savedRecipes.clear()
        for (recipe in saved) {
            if (idList.contains(recipe.id)) {
                savedRecipes.add(recipe)
                addRecipe(recipe)
            }
        }

        fr?.addRecipes()
        return true
    }

    fun loadRecipes(): Boolean {
        fr?.addRecipes()
        return true
    }

    private fun returnList(list: List<Recipe>) {
        recipes = list.toMutableList()
        fr?.addRecipes()
    }

}