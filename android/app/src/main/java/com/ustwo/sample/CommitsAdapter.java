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
            holder.message = (TextView) v.findViewById(R.id.commit_list_row_textview_message);
            holder.date = (TextView) v.findViewById(R.id.commit_list_row_textview_date);

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
