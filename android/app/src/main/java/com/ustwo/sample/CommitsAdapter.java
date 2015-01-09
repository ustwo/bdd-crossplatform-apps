package com.ustwo.sample;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.ustwo.sample.data.CommitSummary;

import java.util.List;

/**
 * Created by emma@ustwo.com on 1/8/15.
 */
public class CommitsAdapter extends BaseAdapter {
    private final LayoutInflater mLayoutInflater;
    private final List<CommitSummary> mCommits;

    public CommitsAdapter(Context context, List<CommitSummary> commits) {
        mLayoutInflater = LayoutInflater.from(context);
        mCommits = commits;
    }

    @Override
    public int getCount() {
        return mCommits.size();
    }

    @Override
    public Object getItem(int position) {
        return mCommits.get(position);
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View v = convertView;
        ViewHolder holder;
        if (v == null) {
            v = mLayoutInflater.inflate(R.layout.item_commit, null);

            holder = new ViewHolder();
            holder.message = (TextView) v.findViewById(R.id.commit_message);
            holder.date = (TextView) v.findViewById(R.id.commit_date);

            v.setTag(holder);
        } else {
            holder = (ViewHolder) v.getTag();
        }

        CommitSummary commit = (CommitSummary) getItem(position);
        holder.message.setText(commit.commit.message);
        holder.date.setText(commit.commit.author.date);

        return v;
    }

    class ViewHolder {
        public TextView message;
        public TextView date;
    }
}
