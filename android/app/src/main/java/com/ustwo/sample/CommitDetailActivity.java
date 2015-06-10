/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 ustwo™
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */
package com.ustwo.sample;

import android.app.ProgressDialog;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.widget.TextView;

import com.ustwo.sample.data.Commit;
import com.ustwo.sample.data.GitHub;

import retrofit.Callback;
import retrofit.RestAdapter;
import retrofit.RetrofitError;
import retrofit.client.Response;

import static com.ustwo.sample.Constants.DEFAULT_REPOSITORY_NAME;
import static com.ustwo.sample.Constants.DEFAULT_REPOSITORY_USER;
import static com.ustwo.sample.Constants.INTENT_KEY_COMMIT_SHA;

/**
 * Created by emma on 1/8/15.
 */
public class CommitDetailActivity extends ActionBarActivity {
    private static final String TAG = CommitDetailActivity.class.getSimpleName();

    private ProgressDialog mProgressDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_commit_detail);

        mProgressDialog = ProgressDialog.show(this, "", getString(R.string.shared_loading), true, false);

        retrieveCommitInfo(getIntent().getStringExtra(INTENT_KEY_COMMIT_SHA));
    }

    @Override
    protected void onPause() {
        super.onPause();

        dismissProgressDialog();
    }

    private void dismissProgressDialog() {
        if (mProgressDialog != null) {
            mProgressDialog.dismiss();
            mProgressDialog = null;
        }
    }

    private void retrieveCommitInfo(String commit) {
        RestAdapter restAdapter = new RestAdapter.Builder()
                .setEndpoint(getString(R.string.app_endpoint_url))
                .build();
        
        GitHub service = restAdapter.create(GitHub.class);
        service.commit(DEFAULT_REPOSITORY_USER, DEFAULT_REPOSITORY_NAME, commit, new Callback<Commit>() {
            @Override
            public void success(Commit commit, Response response) {
                mProgressDialog.cancel();
                updateUI(commit);
            }

            @Override
            public void failure(RetrofitError error) {
                mProgressDialog.cancel();
                Log.e(TAG, "Failed to get full commit information", error);
            }
        });
    }

    private void updateUI(Commit commit) {
        ((TextView) findViewById(R.id.commit_detail_textview_name)).setText(commit.author.name);
        ((TextView) findViewById(R.id.commit_detail_textview_email)).setText(commit.author.email);
        ((TextView) findViewById(R.id.commit_detail_textview_date)).setText(commit.author.date);
        ((TextView) findViewById(R.id.commit_detail_textview_message)).setText(commit.message);
    }
}
