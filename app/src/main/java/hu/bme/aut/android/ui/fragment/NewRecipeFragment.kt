package hu.bme.aut.android.ui.fragment

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.core.app.ActivityCompat
import androidx.core.net.toUri
import androidx.core.view.children
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProviders
import com.github.dhaval2404.imagepicker.ImagePicker
import hu.bme.aut.android.R
import hu.bme.aut.android.model.Categories
import hu.bme.aut.android.model.Recipe
import hu.bme.aut.android.dataManager.network.RecipeService
import kotlinx.android.synthetic.main.fragment_new_recipe.view.*
import kotlinx.android.synthetic.main.row_new_ingredient.view.*


class NewRecipeFragment : Fragment(), AdapterView.OnItemSelectedListener {

    private val PICK_FROM_GALLERY = 1
    private var imageName = ""
    private var category = ""
    private var fileUri: Uri? = null

    private lateinit var rootView: View
    private lateinit var ingredientsLayout: LinearLayout
    private lateinit var imageView: ImageView
    private lateinit var btnSave: Button
    private lateinit var spinner: Spinner

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        rootView = inflater.inflate(R.layout.fragment_new_recipe, container, false)
        ingredientsLayout = rootView.findViewById(R.id.layoutIngredients)
        imageView = rootView.findViewById(R.id.ivNewRecipe)
        btnSave = rootView.findViewById(R.id.btnSave)
        spinner = rootView.findViewById(R.id.spinner_category)

        if (savedInstanceState != null) {
            fileUri = savedInstanceState.getString("fileUri", null).toUri()
            imageView.setImageURI(fileUri)

            spinner.setSelection(savedInstanceState.getInt("spinner", 0))
        }
        val btnAdd: Button = rootView.findViewById(R.id.btnAddNewLine)

        btnSave.isEnabled = false
        spinner.onItemSelectedListener = this
        spinner.adapter = ArrayAdapter<Categories>(
            context!!,
            android.R.layout.simple_list_item_1,
            Categories.values()
        )

        btnAdd.setOnClickListener {
            val layoutInflater =
                context!!.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
            val addView = layoutInflater.inflate(R.layout.row_new_ingredient, null)
            val buttonRemove = addView.findViewById(R.id.btnDeleteRow) as Button
            buttonRemove.setOnClickListener {
                (addView.parent as LinearLayout).removeView(addView)
            }
            ingredientsLayout.addView(addView, ingredientsLayout.childCount)
        }
        btnSave.setOnClickListener {
            btnSave.isEnabled = false
            saveRecipe()
        }
        imageView.setOnClickListener {
            imagePicker()
        }
        return rootView
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putInt("spinner", spinner.selectedItemPosition)
        outState.putString("fileUri", fileUri.toString())

    }

    private fun saveRecipe() {
        Toast.makeText(context, "Recipe saved", Toast.LENGTH_LONG).show()
        val viewModelShared =
            ViewModelProviders.of(activity!!).get(SharedRecipeViewModel::class.java)

        val ingredientsMap = mutableMapOf<String, String>()
        for (view in ingredientsLayout.children) {
            ingredientsMap[view.etIngredientName.text.toString()] =
                view.etIngredientMeasure.text.toString()
        }
        val recipe = Recipe(
            name = rootView.etRecipeName.text.toString(),
            imgURL = imageName,
            ingredients = ingredientsMap,
            category = category,
            instruction = rootView.etDescription.text.toString()
        )
        val recipeService = RecipeService()
        fileUri?.let {
            recipeService.uploadRecipe(recipe, it).addOnSuccessListener {
                viewModelShared.addMyRecipe(recipe)
                recipeService.updateUserList(viewModelShared.user.myRecipes, "myRecipes")
                btnSave.isEnabled = true
                clear()

            }
        }
    }

    private fun clear() {
        imageView.setImageResource(R.drawable.ic_add_a_photo)
        rootView.etRecipeName.setText("")
        rootView.etDescription.setText("")
        for (child in ingredientsLayout.children) {
            ingredientsLayout.removeView(child)
        }
        imageName = ""
    }

    override fun onNothingSelected(parent: AdapterView<*>?) {
    }

    override fun onItemSelected(parent: AdapterView<*>, view: View?, pos: Int, id: Long) {
        if (view != null)
            category = parent.adapter.getItem(pos).toString()
    }

    private fun imagePicker() {
        if (ActivityCompat.checkSelfPermission(
                context!!,
                Manifest.permission.READ_EXTERNAL_STORAGE
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                activity!!,
                arrayOf(
                    Manifest.permission.READ_EXTERNAL_STORAGE,
                    Manifest.permission.WRITE_EXTERNAL_STORAGE
                ),
                PICK_FROM_GALLERY
            )

        }
        if (ActivityCompat.checkSelfPermission(
                context!!,
                Manifest.permission.READ_EXTERNAL_STORAGE
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                activity!!,
                arrayOf(
                    Manifest.permission.READ_EXTERNAL_STORAGE,
                    Manifest.permission.WRITE_EXTERNAL_STORAGE
                ),
                PICK_FROM_GALLERY
            )

        } else {
            //system OS is < Marshmallow
            ImagePicker.with(this)
                .crop(1f, 1f)
                .compress(1024)
                .start()
            btnSave.isEnabled = false
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (resultCode == Activity.RESULT_OK) {
            fileUri = data?.data
            imageView.setImageURI(fileUri)

            imageName = System.currentTimeMillis().toString()
            btnSave.isEnabled = true

        }
    }
}