package com.sherlock.ffmpegdemo;

import android.os.Environment;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

public class MainActivity extends AppCompatActivity implements SurfaceHolder.Callback {
    static {
        try {
            System.loadLibrary("ffmpeg");
            System.loadLibrary("ffmpeg-videoplayer");
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    private SurfaceView mSurfaceView;
    private SurfaceHolder mSurfaceHolder;

    private static final String TEST_VIDEO_FILE = Environment.getExternalStorageDirectory() + "/test.mp4";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mSurfaceView = (SurfaceView) findViewById(R.id.sv_video);
        mSurfaceHolder = mSurfaceView.getHolder();
        mSurfaceHolder.addCallback(this);
    }

    public static native int play(String filePath, Object surface);

    @Override
    public void surfaceCreated(SurfaceHolder holder) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                play(TEST_VIDEO_FILE, mSurfaceHolder.getSurface());
            }
        }).start();
    }

    @Override
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {

    }

    @Override
    public void surfaceDestroyed(SurfaceHolder holder) {

    }
}
