package hu.bme.aut.android.dataManager.network

import hu.bme.aut.android.model.Meals
import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Query

interface TheMealDbAPI {
    companion object {
        const val BASE_URL = "https://www.themealdb.com/api/json/v2/1/"
    }

//    @GET("lookup.php?")
//    fun detailsByID(@Query("i") id: String): Call<Meals>
//
//    @GET("search.php?")
//    fun listAllByLetter(@Query("f") letter: String): Call<Meals>

    @GET("search.php?")
    fun searchByName(@Query("s") name: String): Call<Meals>

    @GET("randomselection.php")
    fun random(): Call<Meals>

//    @GET("latest.php")
//    fun latestMeals(): Call<Meals>
//
//    @GET("list.php?i=list")
//    fun listAllIngredients(): Call<List<ResponseBody>>
//
//    @GET("filter.php?")
//    fun searchByIngredient(@Query("i") ingredient: String): Call<Meals>
//
//    @GET("filter.php?")
//    fun searchByCategory(@Query("c") category: String): Call<Meals>
//
//    @GET("filter.php?")
//    fun searchByArea(@Query("a") area: String): Call<Meals>


}
