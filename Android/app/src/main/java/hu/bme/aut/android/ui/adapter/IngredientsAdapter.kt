package hu.bme.aut.android.ui.adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import hu.bme.aut.android.R
import kotlinx.android.synthetic.main.row_ingredient.view.*

class IngredientsAdapter (context: Context) :
    RecyclerView.Adapter<IngredientsAdapter.ViewHolder>() {
    private val ingredients: MutableList<Pair<String, String>> = mutableListOf()
    private val layoutInflater = LayoutInflater.from(context)


    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = layoutInflater
            .inflate(R.layout.row_ingredient, parent, false)
        return ViewHolder(view)
    }


    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val ingredient = ingredients[position]

        holder.name.text = ingredient.first
        holder.category.text = ingredient.second
    }

    fun addAllIngredient(ingredients: List<Pair<String,String>>?) {
        ingredients ?: return

        this.ingredients.addAll(ingredients)
        notifyDataSetChanged()
    }

    override fun getItemCount() = ingredients.size

    inner class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val name: TextView = view.name
        val category: TextView = view.value

    }
}