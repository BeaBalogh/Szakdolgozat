package hu.bme.aut.android.ui.adapter

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.google.firebase.storage.FirebaseStorage
import hu.bme.aut.android.R
import hu.bme.aut.android.model.Comment
import kotlinx.android.synthetic.main.row_comment.view.*
import kotlinx.android.synthetic.main.row_comment.view.ivMealNewComment
import kotlinx.android.synthetic.main.row_comment.view.tvUserNameNewComment
import kotlinx.android.synthetic.main.view_new_comment.view.*
import java.text.SimpleDateFormat
import java.util.*


class CommentsAdapter(context: Context) :
    RecyclerView.Adapter<CommentsAdapter.ViewHolder>() {
    private val comments: MutableList<Comment> = mutableListOf()
    private val layoutInflater = LayoutInflater.from(context)
    internal var itemClickListener: CommentItemClickListener? = null

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = layoutInflater
            .inflate(R.layout.row_comment, parent, false)
        return ViewHolder(view)
    }


    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val comment = comments[position]
        val storageReference = FirebaseStorage.getInstance().reference

        val pathReference = storageReference.child("images/" + comment.imgURL)
        pathReference.getBytes(Long.MAX_VALUE).addOnSuccessListener {
            val bmp = BitmapFactory.decodeByteArray(it, 0, it.size)
            holder.image.setImageBitmap(bmp)
            holder.image.isVisible = true
            holder.image.setOnClickListener {
                itemClickListener?.onImageClick(bmp)
            }
        }.addOnFailureListener {
            holder.image.isVisible = false
        }
        holder.name.text = comment.userName
        holder.text.text = comment.text
        holder.date.text = comment.date
        holder.rating.rating = comment.rating


    }

    fun addComment(comment: Comment?) {
        comment ?: return
        this.comments.add(comment)

        comments.sortWith(Comparator { c1, c2 ->
            getDate(c1.date).compareTo(getDate(c2.date))
        })

        notifyItemInserted(comments.indexOf(comment))

    }

    private fun getDate(date: String): String {
        val parser = SimpleDateFormat("MMM dd, yyyy HH:mm")
        val formatter = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")
        return formatter.format(parser.parse(date))
    }

    override fun getItemCount() = comments.size

    inner class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val name: TextView = view.tvUserNameNewComment
        val image: ImageView = view.ivMealNewComment
        val text: TextView = view.tvTextComment
        val date: TextView = view.tvDateComment
        val rating: RatingBar = view.ratingBar

    }

    interface CommentItemClickListener {
        fun onImageClick(bmp: Bitmap)
    }
}