package hu.bme.aut.android.ui.fragment

import android.graphics.Bitmap
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import androidx.fragment.app.DialogFragment
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import hu.bme.aut.android.R


class ImageViewerFragment : DialogFragment() {

    private var bitmapimage: Bitmap? = null

    companion object {

        fun newInstance(bitmap: Bitmap): ImageViewerFragment {
            val f = ImageViewerFragment()
            val args = Bundle()
            args.putParcelable("BitmapImage", bitmap)
            f.arguments = args

            return f
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        bitmapimage = arguments?.getParcelable("BitmapImage")

        val style = STYLE_NORMAL
        val theme = 0
        setStyle(style, theme)

    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        dialog?.window?.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        val rootView = inflater.inflate(R.layout.fragment_image_viewer, container, false)
        val imageView = (rootView.findViewById(R.id.imageViewer) as ImageView)

        if (bitmapimage != null)
            imageView.setImageBitmap(bitmapimage)
        return rootView
    }

}