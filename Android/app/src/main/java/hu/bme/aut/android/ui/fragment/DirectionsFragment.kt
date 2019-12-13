package hu.bme.aut.android.ui.fragment

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.RecyclerView
import hu.bme.aut.android.R
import hu.bme.aut.android.ui.adapter.IngredientsAdapter
import androidx.lifecycle.ViewModelProviders
import hu.bme.aut.android.dataManager.network.RecipeService
import kotlinx.android.synthetic.main.content_recipe_detail.view.*


class DirectionsFragment : Fragment() {


    private lateinit var ingredientsAdapter: IngredientsAdapter
    private lateinit var viewModelShared: SharedRecipeViewModel
    private lateinit var recipeService: RecipeService
//    private lateinit var imageView: ImageView

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        val rootView = inflater.inflate(R.layout.content_recipe_detail, container, false)
        val recyclerView = rootView.findViewById(R.id.ingredients_list) as RecyclerView
        val btnCooked: Button = rootView.findViewById(R.id.btnCooked)
        val btnShare: Button = rootView.findViewById(R.id.btnShare)
//        imageView = rootView.findViewById(R.id.ivMealDetails)
        recipeService = RecipeService()
        ingredientsAdapter = IngredientsAdapter(context!!)
        viewModelShared =
            ViewModelProviders.of(activity!!).get(SharedRecipeViewModel::class.java)
        btnCooked.setOnClickListener {
            viewModelShared.addCookedRecipe()
            recipeService.updateUserList(viewModelShared.user.cooked, "cooked")
            btnCooked.isEnabled = false

        }
        btnShare.setOnClickListener {
            val recipe = viewModelShared.selectedRecipe
            var ingredients = ""
            for (item in recipe.ingredients.keys){
                ingredients += item + "\t" + recipe.ingredients[item] + "\n"
            }

            val sendIntent: Intent = Intent().apply {
                action = Intent.ACTION_SEND
                putExtra(Intent.EXTRA_TEXT, recipe.name + "\n\n" + ingredients + "\n" + recipe.instruction)
                type = "text/plain"
            }
            startActivity(sendIntent)
        }
        if (viewModelShared.isCooked()) {
            btnCooked.text = "already Cooked"
            btnCooked.isEnabled = false
        }

        ingredientsAdapter.addAllIngredient(viewModelShared.selectedRecipe.ingredients.toList())

        recyclerView.adapter = ingredientsAdapter
        rootView.description.text = viewModelShared.selectedRecipe.instruction
        return rootView
    }

}

