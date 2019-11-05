package hu.bme.aut.android.ui.fragment

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageButton
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentPagerAdapter
import androidx.lifecycle.ViewModelProviders
import androidx.viewpager.widget.ViewPager
import com.google.android.material.tabs.TabLayout
import hu.bme.aut.android.R
import hu.bme.aut.android.dataManager.network.RecipeService


class RecipeDetailFragment : Fragment() {

    private lateinit var recipeService: RecipeService
    private lateinit var viewModelShared: SharedRecipeViewModel
    private var btnFavorite: ImageButton? = null
    private var favorite = false
    private var id: String = ""


    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val rootView = inflater.inflate(R.layout.fragment_recipe_detail, container, false)
        val adapter = ViewPagerAdapter(childFragmentManager)
        val tabLayout: TabLayout
        val viewPager: ViewPager
        recipeService = RecipeService()
        viewModelShared = ViewModelProviders.of(activity!!).get(SharedRecipeViewModel::class.java)
        id = viewModelShared.selectedRecipe.id

        adapter.addFragment(DirectionsFragment(), "Recipe")
        adapter.addFragment(CommentsFragment(), "Comments")

        viewPager = rootView.findViewById(R.id.viewPager)
        viewPager.adapter = adapter
        tabLayout = rootView.findViewById(R.id.tabs)
        tabLayout.setupWithViewPager(viewPager)
        btnFavorite = rootView.findViewById(R.id.favorite)
        setFavoriteButton()
        btnFavorite?.setOnClickListener {
            if (viewModelShared.isFavorite()) {
                viewModelShared.removeFavoriteRecipe()
            } else {
                viewModelShared.addFavoriteRecipe()
            }
            recipeService.updateUserList(viewModelShared.user.favorites, "favorites")

            favorite = if (!favorite) {
                btnFavorite?.setImageResource(R.drawable.ic_favorite_red)
                true
            } else {
                btnFavorite?.setImageResource(R.drawable.ic_favorite_grey)
                false
            }
        }

        return rootView
    }

    private fun setFavoriteButton() {
        if (viewModelShared.isFavorite()) {
            favorite = true
            btnFavorite?.setImageResource(R.drawable.ic_favorite_red)
        } else {
            favorite = false
            btnFavorite?.setImageResource(R.drawable.ic_favorite_grey)
            Log.d("user", "nope")

        }
    }

    internal inner class ViewPagerAdapter(fm: FragmentManager) :
        FragmentPagerAdapter(fm) {

        private val fragmentList = mutableListOf<Fragment>()
        private val fragmentTitleList = mutableListOf<String>()

        override fun getItem(position: Int): Fragment {
            return fragmentList[position]
        }

        override fun getCount(): Int {
            return fragmentList.size
        }

        fun addFragment(fragment: Fragment, title: String) {
            fragmentList.add(fragment)
            fragmentTitleList.add(title)
        }

        override fun getPageTitle(position: Int): CharSequence {
            return fragmentTitleList[position]
        }
    }
}

