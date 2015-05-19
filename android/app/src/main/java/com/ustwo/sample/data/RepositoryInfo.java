package com.ustwo.sample.data;

import com.google.gson.annotations.SerializedName;

/**
 * Created by emma@ustwo.com on 1/8/15.
 */
public class RepositoryInfo {
    public String name;
    public String description;

    @SerializedName("private")
    public boolean isPrivate;
}
