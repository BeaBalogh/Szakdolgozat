package hu.bme.aut.android.ui.fragment

import android.content.Context
import android.graphics.Bitmap
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.SearchView
import androidx.core.os.bundleOf
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import androidx.recyclerview.widget.RecyclerView
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import hu.bme.aut.android.R
import hu.bme.aut.android.dataManager.DataManager
import hu.bme.aut.android.model.Categories
import hu.bme.aut.android.model.Recipe
import hu.bme.aut.android.ui.activity.MainActivity
import hu.bme.aut.android.ui.adapter.RecipesAdapter
import kotlinx.android.synthetic.main.app_bar_main.*


class RecipeListFragment : Fragment(), RecipesAdapter.RecipeItemClickListener,
    SwipeRefreshLayout.OnRefreshListener {


    private lateinit var adapter: RecipesAdapter
    private lateinit var title: String
    private val viewModel = DataManager.viewModel!!
    private lateinit var searchView: SearchView
    private lateinit var hasInternet: SwipeRefreshLayout
    private lateinit var noInternet: SwipeRefreshLayout
    private lateinit var recipeList: RecyclerView

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val rootView = inflater.inflate(R.layout.content_recipe_list, container, false)
        searchView = rootView.findViewById(R.id.search_widget)
        recipeList = rootView.findViewById(R.id.recipe_list)
        hasInternet = rootView.findViewById(R.id.has_internet)
        noInternet = rootView.findViewById(R.id.no_internet)
        searchView.visibility = View.GONE
        title = activity!!.toolbar?.title.toString()
        DataManager.fr = this
        DataManager.loadRandom()
        DataManager.loadSaved()
        when (title) {
            "Favorites" -> viewModel.loadFavorites()
            "My Recipes" -> viewModel.loadMyRecipes()
            "Cooked" -> viewModel.loadCooked()
            else -> {
                viewModel.loadRecipes()
                searchView.visibility = View.VISIBLE
                if (MainActivity.isNetworkAvailable)
                    noInternet.visibility = View.GONE
                else
                    hasInternet.visibility = View.GONE
            }
        }
        adapter.itemClickListener = this
        val categoriesList: ArrayList<String> = arrayListOf()
        Categories.values().forEach { category -> categoriesList.add(category.toString()) }
        categoriesList.add("Select category...")
        recipeList.adapter = adapter

        searchView.setOnQueryTextListener(object : SearchView.OnQueryTextListener {
            override fun onQueryTextSubmit(query: String): Boolean {
                if (MainActivity.isNetworkAvailable && query != null)
                    DataManager.loadRecipes(query)
                else if (MainActivity.isNetworkAvailable)
                    DataManager.loadRandom()
                return false
            }

            override fun onQueryTextChange(newText: String): Boolean {
                if (MainActivity.isNetworkAvailable)
                    DataManager.loadRecipes(newText)
                return false
            }
        })
        searchView.setOnCloseListener {
            if (MainActivity.isNetworkAvailable)
                DataManager.loadRandom()
            false
        }

        hasInternet.setOnRefreshListener(this)
        noInternet.setOnRefreshListener(this)
        return rootView
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        adapter = RecipesAdapter(context)


    }

    override fun onRefresh() {
        if (title == "Recipes") {
            hasInternet.isRefreshing = true
            noInternet.isRefreshing = true
            if (MainActivity.isNetworkAvailable) {
                DataManager.recipes.clear()
                hasInternet.visibility = View.VISIBLE
                noInternet.visibility = View.GONE
                DataManager.loadRandom()
            } else {
                hasInternet.visibility = View.GONE
                noInternet.visibility = View.VISIBLE
            }
        }
        hasInternet.isRefreshing = false
        noInternet.isRefreshing = false

    }

    override fun onItemClick(recipe: Recipe) {
        viewModel.selectedRecipe = recipe
        val bundle = bundleOf("recipeName" to recipe.name)
        when (activity!!.toolbar?.title.toString()) {
            "Favorites" -> {
                view?.findNavController()!!.navigate(
                    R.id.action_nav_favorites_list_to_nav_details,
                    bundle
                )
            }
            "My Recipes" -> {
                view?.findNavController()!!.navigate(
                    R.id.action_nav_myrecipe_list_to_nav_my_recipe_details,
                    bundle
                )
            }
            "Cooked" -> {
                if (recipe.id.length == 5)
                    view?.findNavController()!!.navigate(
                        R.id.action_nav_cooked_list_to_nav_details,
                        bundle
                    )
                else
                    view?.findNavController()!!.navigate(
                        R.id.action_nav_cooked_list_to_nav_my_recipe_details,
                        bundle
                    )

            }
            else -> {
                view?.findNavController()!!.navigate(
                    R.id.action_nav_home_to_nav_details,
                    bundle
                )
            }
        }
    }

    fun addRecipes() {
        val list = mutableListOf<Recipe>()
        if (activity!!.toolbar?.title.toString() == "Recipes")
            list.addAll(DataManager.recipes)
        else
            list.addAll(DataManager.savedRecipes)
        adapter.addAllRecipe(list)
    }

}
