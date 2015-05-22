package com.ustwo.sample;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
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
public class CommitListActivity extends ActionBarActivity implements AdapterView.OnItemClickListener {
    private static final String TAG = CommitListActivity.class.getSimpleName();

    private RestAdapter mRestAdapter;
    private GitHub mGitHubService;

    private ProgressDialog mProgressDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_commit_list);

        mRestAdapter = new RestAdapter.Builder()
                .setEndpoint(getString(R.string.app_endpoint_url))
                .build();
        mGitHubService = mRestAdapter.create(GitHub.class);

        getListView().setOnItemClickListener(this);

        refresh();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.commit_list_menu, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        if (id == R.id.commit_list_button_refresh) {
            refresh();
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    private void refresh() {
        mProgressDialog = ProgressDialog.show(this, "", getString(R.string.shared_loading), true, false);
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
                updateRepositoryInfo(repositoryInfo);
                retrieveCommitList();
            }

            @Override
            public void failure(RetrofitError error) {
                showErrorMessage();
                dismissProgressDialog();

                Log.e(TAG, "Failed to get repository information", error);
            }
        });
    }

    private void updateRepositoryInfo(RepositoryInfo repositoryInfo) {
        ((TextView) findViewById(R.id.commit_list_textview_title)).setText(repositoryInfo.description);

        ImageView privacyStateView = (ImageView) findViewById(R.id.commit_list_imageview_privacy_state);
        privacyStateView.setImageResource(repositoryInfo.isPrivate ? R.drawable.ic_private : R.drawable.ic_public);
        privacyStateView.setContentDescription(
                getString(repositoryInfo.isPrivate ? R.string.commit_list_repo_private : R.string.commit_list_repo_public));

        getSupportActionBar().setTitle(repositoryInfo.name);
    }

    private void showErrorMessage() {
        getListView().setVisibility(View.GONE);

        getStatusInformationTextView().setVisibility(View.VISIBLE);
        getStatusInformationTextView().setText(R.string.commit_list_error);
    }

    private void retrieveCommitList() {
        mGitHubService.commitList(DEFAULT_REPOSITORY_USER, DEFAULT_REPOSITORY_NAME, new Callback<List<CommitSummary>>() {
            @Override
            public void success(List<CommitSummary> commits, Response response) {
                if (commits.isEmpty()) {
                    getListView().setVisibility(View.GONE);
                    getStatusInformationTextView().setVisibility(View.VISIBLE);
                } else {
                    getListView().setAdapter(new CommitsAdapter(getApplicationContext(), commits));
                }
                dismissProgressDialog();
            }

            @Override
            public void failure(RetrofitError error) {
                showErrorMessage();
                dismissProgressDialog();

                Log.e(TAG, "Failed to get commits", error);
            }
        });
    }

    private TextView getStatusInformationTextView() {
        return (TextView) findViewById(R.id.commit_list_textview_status_information);
    }

    private ListView getListView() {
        return (ListView) findViewById(R.id.commit_list_listview_commits);
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        CommitSummary commit = (CommitSummary) (parent.getAdapter()).getItem(position);

        Intent intent = new Intent(this, CommitDetailActivity.class);
        intent.putExtra(INTENT_KEY_COMMIT_SHA, commit.sha);
        startActivity(intent);
    }
}
