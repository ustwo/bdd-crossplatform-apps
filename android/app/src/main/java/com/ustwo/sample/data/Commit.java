package com.ustwo.sample.data;

/**
 * Created by emma@ustwo.com on 1/8/15.
 */
public class Commit {
    public String message;
    public Author author;

    public class Author {
        public String name;
        public String email;
        public String date;
    }
}
