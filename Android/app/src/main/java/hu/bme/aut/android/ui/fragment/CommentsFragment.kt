package hu.bme.aut.android.ui.fragment

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.net.ConnectivityManager
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.core.app.ActivityCompat
import androidx.core.net.toUri
import androidx.core.view.children
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProviders
import androidx.recyclerview.widget.RecyclerView
import com.github.dhaval2404.imagepicker.ImagePicker
import com.google.firebase.firestore.DocumentSnapshot
import hu.bme.aut.android.R
import hu.bme.aut.android.ui.activity.MainActivity
import hu.bme.aut.android.ui.adapter.CommentsAdapter
import hu.bme.aut.android.model.Comment
import hu.bme.aut.android.dataManager.network.RecipeService
import hu.bme.aut.android.reciver.ConnectivityReceiver
import kotlinx.android.synthetic.main.view_new_comment.*
import java.text.SimpleDateFormat
import java.util.*


class CommentsFragment : Fragment(), CommentsAdapter.CommentItemClickListener,
    ConnectivityReceiver.ConnectivityReceiverListener {

    private lateinit var recipeService: RecipeService
    private lateinit var commentsAdapter: CommentsAdapter
    private lateinit var viewModelShared: SharedRecipeViewModel

    private lateinit var imageView: ImageView
    private lateinit var etCommentText: TextView
    private lateinit var btnSend: Button
    private lateinit var btnCancel: Button
    private lateinit var newComment: RelativeLayout
    private lateinit var ratingBar: RatingBar
    private var id = ""
    private var userName = ""
    private var commentText = ""
    private var imageName = ""
    private var fileUri: Uri? = null
    private var withImage = false
    private var connReciver = ConnectivityReceiver()


    override fun onNetworkConnectionChanged(isConnected: Boolean) {
        for (child in newComment.children) {
            child.isEnabled = isConnected
        }

    }


    override fun onAttach(context: Context) {
        super.onAttach(context)
        activity!!.registerReceiver(
            connReciver,
            IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION)
        )
        ConnectivityReceiver.connectivityReceiverListener = this

    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putString("fileUri", fileUri.toString())

    }

    override fun onDestroy() {
        super.onDestroy()
        activity!!.unregisterReceiver(connReciver)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val rootView = inflater.inflate(R.layout.fragment_comments, container, false)
        val recyclerView = rootView.findViewById(R.id.comments_list) as RecyclerView

        recipeService = RecipeService()
        commentsAdapter = CommentsAdapter(context!!)
        viewModelShared = ViewModelProviders.of(activity!!).get(SharedRecipeViewModel::class.java)


        id = viewModelShared.selectedRecipe.id
        userName = recipeService.getUserName().toString()

        btnSend = rootView.findViewById(R.id.btnSendComment)
        btnCancel = rootView.findViewById(R.id.btnCancelNewComment)
        imageView = rootView.findViewById(R.id.ivMealNewComment)
        etCommentText = rootView.findViewById(R.id.etTextNewComment)
        (rootView.findViewById(R.id.tvUserNameNewComment) as TextView).text = userName
        newComment = rootView.findViewById(R.id.layoutNewComment)
        ratingBar= rootView.findViewById(R.id.rbNewComment)

        if (savedInstanceState != null) {
            fileUri = savedInstanceState.getString("fileUri", null).toUri()
            imageView.setImageURI(fileUri)
            savedInstanceState.remove("fileUri")
        }

        for (child in newComment.children) {
            child.isEnabled = MainActivity.isNetworkAvailable
        }
        loadComments()
        commentsAdapter.itemClickListener = this
        recyclerView.adapter = commentsAdapter
        btnCancel.isVisible = false
        imageView.setOnClickListener {
            imagePicker()
        }
        btnSend.setOnClickListener {
            commentText = etCommentText.text.toString()
            if (fileUri != null || commentText != "") {
                Toast.makeText(context, "Sent!", Toast.LENGTH_LONG).show()
                btnSend.isEnabled = false
                send()
            } else
                Toast.makeText(context, "Empty comment!", Toast.LENGTH_LONG).show()
        }
        btnCancel.setOnClickListener {
            imageView.setImageResource(R.drawable.ic_add_a_photo)
            withImage = false
            imageName = ""
        }
        return rootView
    }

    private fun send() {

        val sdf = SimpleDateFormat(getString(R.string.date_pattern))
        val currentDate = sdf.format(Date())

        val comment = Comment(
            id = "",
            userName = userName,
            imgURL = imageName,
            date = currentDate,
            text = commentText,
            rating = ratingBar.rating
        )
        recipeService.uploadComment(comment, id, fileUri).addOnSuccessListener {

            loadComment(it.id)
            clear()
        }.addOnFailureListener { e ->
            Log.w("firestore", "Error adding document", e)
        }
    }

    private fun clear() {
        imageView.setImageResource(R.drawable.ic_add_a_photo)
        fileUri = null
        etTextNewComment.text = null
        btnSend.isEnabled = true
        btnCancel.isVisible = false
    }

    private fun loadComment(commentID: String) {
        if (MainActivity.isNetworkAvailable) {
            recipeService.loadComment(id, commentID).addOnSuccessListener { document ->
                val comment =document.toObject(Comment::class.java)
                commentsAdapter.addComment(comment)
            }
        }
    }


    private fun loadComments() {
        recipeService.loadComments(id).addOnSuccessListener { documents ->
            for (document in documents) {
                val comment = document.toObject(Comment::class.java)
                commentsAdapter.addComment(comment)
                viewModelShared.addComment(comment)
            }
        }
    }


    private fun imagePicker() {
        //system OS is < Marshmallow
        ImagePicker.with(this)
            .crop(1f, 1f)                //Crop Square image(Optional)
            .compress(1024)            //Final image size will be less than 1 MB(Optional)
            .start()
        withImage = true
        btnSend.isEnabled = false

    }

    override fun onImageClick(bmp: Bitmap) {
        val imageViewer = ImageViewerFragment.newInstance(bmp)
        imageViewer.show(fragmentManager!!, "IMAGEVIEWER")
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        // Result code is RESULT_OK only if the user selects an Image
        if (resultCode == Activity.RESULT_OK) {
            fileUri = data?.data
            imageView.setImageURI(fileUri)
            //You can get File object from intent
//            val file = ImagePicker.getFile(data)

            //You can also get File Path from intent
//            val filePath = ImagePicker.getFilePath(data)
            btnCancel.isVisible = true
            imageName = System.currentTimeMillis().toString()
            btnSend.isEnabled = true

        }
    }


}
