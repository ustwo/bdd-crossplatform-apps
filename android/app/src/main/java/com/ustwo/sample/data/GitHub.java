package com.ustwo.sample.data;

import java.util.List;

import retrofit.Callback;
import retrofit.http.GET;
import retrofit.http.Path;

/**
 * Created by emma@ustwo.com on 1/8/15.
 */
public interface GitHub {
    @GET("/repos/{username}/{repo}")
    void repository(@Path("username") String username,
                    @Path("repo") String repo,
                    Callback<RepositoryInfo> commit);

    @GET("/repos/{username}/{repo}/commits")
    void commitList(@Path("username") String username,
                    @Path("repo") String repo,
                    Callback<List<CommitSummary>> commit);

    @GET("/repos/{username}/{repo}/git/commits/{commit}")
    void commit(@Path("username") String username,
                @Path("repo") String repo,
                @Path("commit") String commit,
                Callback<Commit> user);
}
