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
package com.ustwo.sample.data;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by emma@ustwo.com on 1/8/15.
 * <p/>
 * Object representing a single commit, containing full information about it
 */
public class Commit implements Parcelable {
    public CommitDetail commit;
    public String sha;

    public Commit(final Parcel in) {
        final String[] data = new String[5];
        in.readStringArray(data);

        sha = data[0];
        commit = new CommitDetail();
        commit.message = data[1];
        commit.author = new Author();
        commit.author.name = data[2];
        commit.author.email = data[3];
        commit.author.date = data[4];
    }

    public static class CommitDetail {
        public Author author;
        public String message;
    }

    public static class Author {
        public String name;
        public String email;
        public String date;
    }

    @Override public int describeContents() {
        return 0;
    }

    @Override public void writeToParcel(final Parcel dest, final int flags) {
        dest.writeStringArray(new String[] {sha, commit.message, commit.author.name, commit.author.email, commit.author.date});
    }

    public static final Parcelable.Creator CREATOR = new Parcelable.Creator() {
        public Commit createFromParcel(Parcel in) {
            return new Commit(in);
        }

        public Commit[] newArray(int size) {
            return new Commit[size];
        }
    };
}
