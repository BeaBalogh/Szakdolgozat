package hu.bme.aut.android.ui.activity

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.EditText
import android.widget.Toast
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInAccount
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.common.api.ApiException
import com.google.android.material.snackbar.Snackbar
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.GoogleAuthProvider
import com.google.firebase.auth.UserProfileChangeRequest
import hu.bme.aut.android.R
import hu.bme.aut.android.ui.fragment.RecipeListFragment
import kotlinx.android.synthetic.main.activity_login.*
import kotlinx.android.synthetic.main.screen_login.*
import kotlinx.android.synthetic.main.screen_register.*


class LoginActivity : BaseActivity(), View.OnClickListener {

    private lateinit var firebaseAuth: FirebaseAuth
    private lateinit var googleSignInClient: GoogleSignInClient
    companion object {
        private const val TAG = "GoogleActivity"
        private const val RC_SIGN_IN = 9001
        private var current = "main"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
            .requestIdToken(getString(R.string.default_web_client_id))
            .requestEmail()
            .build()
        googleSignInClient = GoogleSignIn.getClient(this, gso)
        firebaseAuth = FirebaseAuth.getInstance()

        val user = FirebaseAuth.getInstance().currentUser
        if (user != null) {
            val i = Intent(this, MainActivity::class.java)
            i.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            startActivity(i)
        } else {
            if (savedInstanceState != null) {
                when (savedInstanceState.getString("view")){
                    "main" -> setContentView(R.layout.activity_login)
                    "login" -> setContentView(R.layout.screen_login)
                    "regist" -> setContentView(R.layout.screen_register)
                }
            } else setContentView(R.layout.activity_login)
        }

    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putString("view", current)

    }
    private fun signIn() {
        val signInIntent = googleSignInClient.signInIntent
        startActivityForResult(signInIntent, RC_SIGN_IN)
    }

    public override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == RC_SIGN_IN) {
            val task = GoogleSignIn.getSignedInAccountFromIntent(data)
            try {
                val account = task.getResult(ApiException::class.java)
                firebaseAuthWithGoogle(account!!)
            } catch (e: ApiException) {
                Log.w(TAG, "Google sign in failed", e)
                Toast.makeText(this, "Gooogle Auth failed", Toast.LENGTH_LONG)

            }
        }
    }

    private fun firebaseAuthWithGoogle(acct: GoogleSignInAccount) {
        Log.d(TAG, "firebaseAuthWithGoogle:" + acct.id!!)
        showProgressDialog()

        val credential = GoogleAuthProvider.getCredential(acct.idToken, null)
        firebaseAuth.signInWithCredential(credential)
            .addOnCompleteListener(this) { task ->
                if (task.isSuccessful) {
                    Log.d(TAG, "signInWithCredential:success")
                    val i = Intent(this@LoginActivity, MainActivity::class.java)
                    i.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                    startActivity(i)
                } else {
                    Log.w(TAG, "signInWithCredential:failure", task.exception)
                    Snackbar.make(main_layout, "Authentication Failed.", Snackbar.LENGTH_SHORT)
                        .show()
                }
                hideProgressDialog()
            }
    }

    private fun loginClick() {
        if (!validateLoginForm()) {
            return
        }
        showProgressDialog()
        signInWithGoogle(etEmail.text.toString(), etPassword.text.toString())

    }
    private fun signInWithGoogle(email: String, password: String){
        firebaseAuth
            .signInWithEmailAndPassword(email, password)
            .addOnSuccessListener {
                hideProgressDialog()

                val i = Intent(this@LoginActivity, RecipeListFragment::class.java)
                i.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                startActivity(i)
                finish()
            }
            .addOnFailureListener { exception ->
                hideProgressDialog()

                toast(exception.localizedMessage)
            }
    }

    private fun registerClick() {
        if (!validateRegisterForm()) {
            return
        }
        showProgressDialog()
        val displayName = StringBuilder()
        displayName.append(etFirstName.text)
            .append(" ")
            .append(etLastName.text)

        firebaseAuth
            .createUserWithEmailAndPassword(etEmail.text.toString(), etPassword.text.toString())
            .addOnSuccessListener { result ->
                hideProgressDialog()

                val firebaseUser = result.user
                val profileChangeRequest = UserProfileChangeRequest.Builder()
                    .setDisplayName(displayName.toString())
                    .build()
                firebaseUser?.updateProfile(profileChangeRequest)

                toast("Registration successful")
                signInWithGoogle(etEmail.text.toString(), etPassword.text.toString())
            }
            .addOnFailureListener { exception ->
                hideProgressDialog()

                toast(exception.message)
            }
    }

    private fun EditText.validateNonEmpty(): Boolean {
        if (text.isEmpty()) {
            error = "Required"
            return false
        }
        return true
    }

    private fun validateLoginForm() = etLoginEmail.validateNonEmpty() && etLoginPassword.validateNonEmpty()
    private fun validateRegisterForm() =
        etEmail.validateNonEmpty() && etPassword.validateNonEmpty() && etFirstName.validateNonEmpty() && etLastName.validateNonEmpty()

    override fun onClick(v: View) {
        when (v.id) {
            R.id.btnGoogleLogin -> signIn()
            R.id.btnToLogin -> {
                setContentView(R.layout.screen_login)
                current = "login"
            }
            R.id.btnToRegister -> {
                setContentView(R.layout.screen_register)
                current = "regist"
            }
            R.id.btnBack -> {
                setContentView(R.layout.activity_login)
                current = "main"
            }
            R.id.btnLogin -> loginClick()
            R.id.btnRegister -> registerClick()

        }
    }

}
