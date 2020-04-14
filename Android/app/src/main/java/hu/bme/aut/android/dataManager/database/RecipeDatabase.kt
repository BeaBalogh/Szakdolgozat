package hu.bme.aut.android.dataManager.database

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import hu.bme.aut.android.entities.Recipe

@Database(entities = [Recipe::class], version = 1)
@TypeConverters(StringMapConverter::class)
abstract class RecipeDatabase : RoomDatabase() {
    abstract fun recipeDao(): RecipeDao
}
