package hu.bme.aut.android.ui.fragment

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
        if (viewModelShared.isCooked()) {
            btnCooked.text = "already Cooked"
            btnCooked.isEnabled = false
        }

        ingredientsAdapter.addAllIngredient(viewModelShared.selectedRecipe.ingredients.toList())

//        val imgURL = viewModelShared.selectedRecipe.imgURL
//        Log.d("URL", imgURL)
////        if (imgURL.contains("http")) {
//            Glide.with(this.context!!)
//                .load(imgURL)
//                .into(this.imageView)
////        } else {
////            val array = Base64.decode(viewModelShared.selectedRecipe.image, Base64.DEFAULT)
////            Glide.with(this)
////                .load(array)
////                .into(this.imageView)
////        }

        recyclerView.adapter = ingredientsAdapter
        rootView.description.text = viewModelShared.selectedRecipe.instruction
        return rootView
    }

}

