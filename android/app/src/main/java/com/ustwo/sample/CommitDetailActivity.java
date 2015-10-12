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

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.widget.TextView;

import com.ustwo.sample.data.Commit;

/**
 * Created by emma on 1/8/15.
 */
public class CommitDetailActivity extends ActionBarActivity {
    private static final String EXTRA_KEY_COMMIT = "key_commit_sha";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_commit_detail);

        final Commit commit = getIntent().getParcelableExtra(EXTRA_KEY_COMMIT);
        updateUI(commit);
    }

    private void updateUI(final Commit commit) {
        final Commit.CommitDetail commitDetail = commit.commit;
        final Commit.Author author = commitDetail.author;

        ((TextView) findViewById(R.id.commit_detail_textview_name)).setText(author.name);
        ((TextView) findViewById(R.id.commit_detail_textview_email)).setText(author.email);
        ((TextView) findViewById(R.id.commit_detail_textview_date)).setText(author.date);
        ((TextView) findViewById(R.id.commit_detail_textview_message)).setText(commitDetail.message);
    }

    public static Intent getIntent(final Context context, final Commit commit) {
        final Intent intent = new Intent(context, CommitDetailActivity.class);
        intent.putExtra(EXTRA_KEY_COMMIT, commit);
        return intent;
    }
}
