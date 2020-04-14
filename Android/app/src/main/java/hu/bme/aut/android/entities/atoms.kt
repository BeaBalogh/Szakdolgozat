package hu.bme.aut.android.entities

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.Ignore
import androidx.room.PrimaryKey

enum class Categories {
    Beef, Breakfast, Chicken, Dessert, Goat, Lamb, Miscellaneous, Pasta, Pork, Seafood, Side,
    Starter, Vegan, Vegetarian
}

@Entity( tableName = "recipe")
data class Recipe(
    @PrimaryKey var id: String = "",
    @ColumnInfo(name = "name") var name: String = "",
    @ColumnInfo(name = "imgURL") var imgURL: String = "",
    @ColumnInfo(name = "ingredients") var ingredients: Map<String, String> = mutableMapOf(),
    @ColumnInfo(name = "category") var category: String? = "",
    @Ignore var area: String? = "",
    @ColumnInfo(name = "instruction") var instruction: String? = "",
    @Ignore val comments: MutableList<String> = mutableListOf(),
    @ColumnInfo(name="image") var image: String = ""
)

data class Comment(
    var id: String = "",
    val userName: String = "",
    val text: String = "",
    val imgURL: String = "",
    val date: String = "",
    val rating: Float = 0.toFloat()
)

data class User(
    val favorites: MutableList<String> = mutableListOf(),
    val cooked: MutableList<String> = mutableListOf(),
    val myRecipes: MutableList<String> = mutableListOf()
)

