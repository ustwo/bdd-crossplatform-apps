package com.ustwo.sample.data;

/**
 * Created by emma@ustwo.com on 1/8/15.
 *
 * An object representing the basic of information for a commit. We need to do a different request for the full information
 */
public class CommitSummary {
    public String sha;
    public Commit commit;

    public class Commit {
        public Author author;
        public String message;
    }

    public class Author {
        public String date;
    }
}
