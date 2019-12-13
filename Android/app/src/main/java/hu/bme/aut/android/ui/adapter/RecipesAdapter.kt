package hu.bme.aut.android.ui.adapter

import android.content.Context
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.util.Base64
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import hu.bme.aut.android.ui.activity.MainActivity
import hu.bme.aut.android.model.Recipe
import hu.bme.aut.android.dataManager.network.RecipeService
import kotlinx.android.synthetic.main.row_recipe.view.*

class RecipesAdapter(private val context: Context) :
    RecyclerView.Adapter<RecipesAdapter.ViewHolder>() {

    private var recipes: MutableList<Recipe> = mutableListOf()
    private val layoutInflater = LayoutInflater.from(context)
    internal var itemClickListener: RecipeItemClickListener? = null

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = layoutInflater
            .inflate(hu.bme.aut.android.R.layout.row_recipe, parent, false)
        return ViewHolder(view)
    }


    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val recipe = recipes[position]

        if (MainActivity.isNetworkAvailable) {
            if (recipe.imgURL.contains("http")) {
                Glide.with(context)
                    .load(recipe.imgURL)
                    .into(holder.image)
            } else {
                RecipeService().getImage(recipe.imgURL).addOnSuccessListener {
                    Glide.with(context)
                        .load(it)
                        .into(holder.image)
                }
            }
        } else {
            val array = Base64.decode(recipe.image, Base64.DEFAULT)
            Glide.with(context)
                .load(array)
                .into(holder.image)
        }

        holder.recipe = recipe
        holder.name.text = recipe.name
        holder.category.text = recipe.category
    }

    fun addAllRecipe(recipe: List<Recipe>?) {
        recipe ?: return
        recipes = mutableListOf()
        recipes.addAll(recipe)
        notifyDataSetChanged()
    }
    fun getRow(position: Int): Recipe{
        return  recipes[position]
    }
    fun deleteRow(position: Int) {
        recipes.removeAt(position)
        notifyItemRemoved(position)
    }

    override fun getItemCount() = recipes.size

    inner class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val image: ImageView = view.recipe_img
        val name: TextView = view.recipe_name
        val category: TextView = view.category

        var recipe: Recipe? = null

        init {
            view.setOnClickListener {
                recipe?.let { recipe -> itemClickListener?.onItemClick(recipe) }
            }
            view.setOnLongClickListener {view ->
                itemClickListener?.onItemLongClick(adapterPosition, view)
                true
            }

        }
    }

    interface RecipeItemClickListener {
        fun onItemClick(recipe: Recipe)
        fun onItemLongClick(position: Int, view: View): Boolean
    }

}