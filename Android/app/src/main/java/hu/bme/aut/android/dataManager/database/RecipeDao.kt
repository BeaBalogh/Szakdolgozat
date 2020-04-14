package hu.bme.aut.android.dataManager.database

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import hu.bme.aut.android.entities.Recipe

@Dao
interface RecipeDao {

    @Query("SELECT * FROM recipe")
    fun loadAll(): List<Recipe>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insertAll(vararg recipe: Recipe)


}