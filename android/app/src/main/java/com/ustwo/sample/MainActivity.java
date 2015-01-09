package com.ustwo.sample;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.ustwo.sample.data.CommitSummary;
import com.ustwo.sample.data.GitHub;
import com.ustwo.sample.data.RepositoryInfo;

import java.util.List;

import retrofit.Callback;
import retrofit.RestAdapter;
import retrofit.RetrofitError;
import retrofit.client.Response;

import static com.ustwo.sample.Constants.DEFAULT_REPOSITORY_NAME;
import static com.ustwo.sample.Constants.DEFAULT_REPOSITORY_USER;
import static com.ustwo.sample.Constants.INTENT_KEY_COMMIT_SHA;

/**
 * Created by emma@ustwo.com on 1/8/15.
 */
public class MainActivity extends ActionBarActivity implements AdapterView.OnItemClickListener {
    private static final String TAG = MainActivity.class.getSimpleName();

    private final RestAdapter mRestAdapter = new RestAdapter.Builder()
            .setEndpoint("https://api.github.com")
            .build();
    private final GitHub mGitHubService = mRestAdapter.create(GitHub.class);

    private ProgressDialog mProgressDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);

        getListView().setOnItemClickListener(this);

        refresh();
    }

    private void refresh() {
        mProgressDialog = ProgressDialog.show(this, "", getString(R.string.loading), true, false);
        retrieveRepositoryInfo();
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

    private void retrieveRepositoryInfo() {
        mGitHubService.repository(DEFAULT_REPOSITORY_USER, DEFAULT_REPOSITORY_NAME, new Callback<RepositoryInfo>() {
            @Override
            public void success(RepositoryInfo repositoryInfo, Response response) {
                View header = LayoutInflater.from(MainActivity.this).inflate(R.layout.listview_header, null);
                getListView().addHeaderView(header);
                ((TextView) header.findViewById(R.id.header_title)).setText(repositoryInfo.description);

                retrieveCommitList();
                Log.d(TAG, repositoryInfo.description);
            }

            @Override
            public void failure(RetrofitError error) {
                dismissProgressDialog();
                Log.e(TAG, "Failed to get repository information", error);
            }
        });
    }

    private void retrieveCommitList() {
        mGitHubService.commitList(DEFAULT_REPOSITORY_USER, DEFAULT_REPOSITORY_NAME, new Callback<List<CommitSummary>>() {
            @Override
            public void success(List<CommitSummary> commits, Response response) {
                getListView().setAdapter(new CommitsAdapter(getApplicationContext(), commits));
                dismissProgressDialog();
            }

            @Override
            public void failure(RetrofitError error) {
                dismissProgressDialog();
                Log.e(TAG, "Failed to get commits", error);
            }
        });
    }

    private ListView getListView() {
        return (ListView) findViewById(R.id.main_listview);
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        CommitSummary commit = (CommitSummary) (parent.getAdapter()).getItem(position);

        Intent intent = new Intent(this, DetailActivity.class);
        intent.putExtra(INTENT_KEY_COMMIT_SHA, commit.sha);
        startActivity(intent);
    }
}
