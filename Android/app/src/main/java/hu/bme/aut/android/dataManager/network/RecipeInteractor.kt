package hu.bme.aut.android.dataManager.network

import android.os.Handler
import com.google.gson.GsonBuilder
import hu.bme.aut.android.dataManager.network.helper.RecipeMapper
import hu.bme.aut.android.entities.Meals
import hu.bme.aut.android.entities.Recipe
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory


class RecipeInteractor {

    private val mealAPI: TheMealDbAPI

    init {
        val gson = GsonBuilder()
            .setLenient()
            .create()

        val retrofit = Retrofit.Builder()
            .baseUrl(TheMealDbAPI.BASE_URL)
            .addConverterFactory(GsonConverterFactory.create(gson))
            .build()

        this.mealAPI = retrofit.create(TheMealDbAPI::class.java)
    }

    private fun runCallOnBackgroundThread(
        call: Call<Meals>,
        onSuccess: (List<Recipe>) -> Unit
    ) {
        val handler = Handler()
        Thread {
            try {
                val response = call.execute().body()
                val recipeList = mutableListOf<Recipe>()
                if (response?.meals != null)
                    for (item in response.meals) {
                        recipeList.add(RecipeMapper.mealConvertToRecipe(item))
                    }
                handler.post { onSuccess(recipeList) }

            } catch (e: Exception) {
                e.printStackTrace()
            }
        }.start()
    }

    fun serachByName(
        name: String,
        onSuccess: (List<Recipe>) -> Unit
    ) {
        val getRecipeRequest = mealAPI.searchByName(name)
        runCallOnBackgroundThread(getRecipeRequest, onSuccess)
    }

    fun random(
        onSuccess: (List<Recipe>) -> Unit
    ) {
        val getRecipeRequest = mealAPI.random()
        runCallOnBackgroundThread(getRecipeRequest, onSuccess)
    }


   }
