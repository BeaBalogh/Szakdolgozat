package hu.bme.aut.android.dataManager.network

import android.net.Uri
import android.util.Log
import com.google.android.gms.tasks.Task
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.*
import com.google.firebase.storage.FirebaseStorage
import com.google.firebase.storage.StorageReference
import com.google.firebase.storage.UploadTask
import hu.bme.aut.android.model.Comment
import hu.bme.aut.android.model.Recipe
import hu.bme.aut.android.model.User


class RecipeService {
    private val firebaseAuth: FirebaseAuth = FirebaseAuth.getInstance()
    private val db: FirebaseFirestore = FirebaseFirestore.getInstance()
    private val storageReference: StorageReference = FirebaseStorage.getInstance().reference

    fun getUserName(): String? {
        return firebaseAuth.currentUser!!.displayName
    }

    fun getRecipes(): Task<QuerySnapshot> {
        val ref = db.collection("recipes")
        return ref.get()
    }

    fun getUserData(): Task<DocumentSnapshot> {
        return db.collection("users").document(firebaseAuth.currentUser!!.uid).get()
    }

    fun loadComments(id: String): Task<QuerySnapshot> {
        val docRef = db.collection("recipes").document(id)
            .collection("comments")
        return docRef.get()
    }

    fun loadComment(recipeId: String, id: String): Task<DocumentSnapshot> {
        val docRef = db.collection("recipes").document(recipeId)
            .collection("comments").document(id)
        return docRef.get()
    }


    fun createUser() {
        val ref = db.collection("users").document(firebaseAuth.currentUser!!.uid)
        ref.get().addOnFailureListener {
            val user = User()
            ref.set(user, SetOptions.merge())
        }

    }

    fun updateUserList(list: List<Any>, listName: String) {
        val ref = db.collection("users").document(firebaseAuth.currentUser!!.uid)
        ref.update(listName, list)
            .addOnFailureListener { exception ->
                Log.d("user", "get failed with ", exception)
            }
    }

    fun uploadRecipe(recipe: Recipe, fileUri: Uri): Task<Void> {
        val ref = db.collection("recipes").document()
        val upload = uploadImage(fileUri, recipe.imgURL)
        while (!upload.isComplete) {
            Thread.sleep(10)
        }
        recipe.id = ref.id
        return ref.set(recipe)
    }

    fun uploadComment(
        comment: Comment,
        recipeId: String,
        fileUri: Uri?
    ): Task<DocumentReference> {
        var upload: UploadTask? = null
        if (fileUri != null) {
            upload = uploadImage(fileUri, comment.imgURL)
        }
        val commentToUpload = hashMapOf(
            "userName" to comment.userName,
            "date" to comment.date,
            "text" to comment.text,
            "imgURL" to comment.imgURL
        )
        if (upload != null) {
            while (!upload.isComplete) {
                Thread.sleep(10)
            }
        }
        return db.collection("recipes").document(recipeId)
            .collection("comments")
            .add(commentToUpload)

    }

    private fun uploadImage(fileUri: Uri, fileName: String): UploadTask {
        val ref = storageReference.child("images/$fileName")
        return ref.putFile(fileUri)
    }

    fun getImage(imgURL: String): Task<ByteArray> {
        val storageReference = FirebaseStorage.getInstance().reference

        val pathReference = storageReference.child("images/$imgURL")
        return pathReference.getBytes(Long.MAX_VALUE)
    }

    fun saveRecipe(recipe: Recipe ) {
        if (recipe.id == "") {
            db.collection("recipes").add(recipe).addOnSuccessListener {
                recipe.id = it.id
                db.collection("recipes").document(recipe.id).set(recipe)
            }
        } else
            db.collection("recipes").document(recipe.id).set(recipe)
    }


}