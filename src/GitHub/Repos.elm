module GitHub.Repos exposing (Repo, get)

import Http
import Json.Decode exposing (Decoder, bool, field, int, map, map2, nullable, string, succeed)


baseUrl : String
baseUrl =
    "https://api.github.com"


get : String -> String -> Http.Request Repo
get userName repoName =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Accept" "application/vnd.github.v3+json" ]
        , url = baseUrl ++ "/repos/" ++ userName ++ "/" ++ repoName
        , body = Http.emptyBody
        , expect = Http.expectJson repoDecoder
        , timeout = Nothing
        , withCredentials = False
        }


repoOwnerDecoder : Decoder RepoOwner
repoOwnerDecoder =
    succeed RepoOwner
        |> map2 (|>) (field "login" string)
        |> map2 (|>) (field "id" int)
        |> map2 (|>) (field "avatar_url" string)
        |> map2 (|>) (field "gravatar_id" string)
        |> map2 (|>) (field "url" string)
        |> map2 (|>) (field "html_url" string)
        |> map2 (|>) (field "followers_url" string)
        |> map2 (|>) (field "following_url" string)
        |> map2 (|>) (field "gists_url" string)
        |> map2 (|>) (field "starred_url" string)
        |> map2 (|>) (field "subscriptions_url" string)
        |> map2 (|>) (field "organizations_url" string)
        |> map2 (|>) (field "repos_url" string)
        |> map2 (|>) (field "events_url" string)
        |> map2 (|>) (field "received_events_url" string)
        |> map2 (|>) (field "type" string)
        |> map2 (|>) (field "site_admin" bool)


repoDecoder : Decoder Repo
repoDecoder =
    succeed RepoRecord
        |> map2 (|>) (field "id" int)
        |> map2 (|>) (field "name" string)
        |> map2 (|>) (field "full_name" string)
        |> map2 (|>) (field "owner" repoOwnerDecoder)
        |> map2 (|>) (field "private" bool)
        |> map2 (|>) (field "html_url" string)
        |> map2 (|>) (field "description" (nullable string))
        |> map2 (|>) (field "fork" bool)
        |> map2 (|>) (field "url" string)
        |> map2 (|>) (field "forks_url" string)
        |> map2 (|>) (field "keys_url" string)
        |> map2 (|>) (field "collaborators_url" string)
        |> map2 (|>) (field "teams_url" string)
        |> map2 (|>) (field "hooks_url" string)
        |> map2 (|>) (field "issue_events_url" string)
        |> map2 (|>) (field "events_url" string)
        |> map2 (|>) (field "assignees_url" string)
        |> map2 (|>) (field "branches_url" string)
        |> map2 (|>) (field "tags_url" string)
        |> map2 (|>) (field "blobs_url" string)
        |> map2 (|>) (field "git_tags_url" string)
        |> map2 (|>) (field "git_refs_url" string)
        |> map2 (|>) (field "trees_url" string)
        |> map2 (|>) (field "statuses_url" string)
        |> map2 (|>) (field "languages_url" string)
        |> map2 (|>) (field "stargazers_url" string)
        |> map2 (|>) (field "contributors_url" string)
        |> map2 (|>) (field "subscribers_url" string)
        |> map2 (|>) (field "subscription_url" string)
        |> map2 (|>) (field "commits_url" string)
        |> map2 (|>) (field "git_commits_url" string)
        |> map2 (|>) (field "comments_url" string)
        |> map2 (|>) (field "issue_comment_url" string)
        |> map2 (|>) (field "contents_url" string)
        |> map2 (|>) (field "compare_url" string)
        |> map2 (|>) (field "merges_url" string)
        |> map2 (|>) (field "archive_url" string)
        |> map2 (|>) (field "downloads_url" string)
        |> map2 (|>) (field "issues_url" string)
        |> map2 (|>) (field "pulls_url" string)
        |> map2 (|>) (field "milestones_url" string)
        |> map2 (|>) (field "notifications_url" string)
        |> map2 (|>) (field "labels_url" string)
        |> map2 (|>) (field "releases_url" string)
        |> map2 (|>) (field "deployments_url" string)
        |> map2 (|>) (field "created_at" string)
        |> map2 (|>) (field "updated_at" string)
        |> map2 (|>) (field "pushed_at" string)
        |> map2 (|>) (field "git_url" string)
        |> map2 (|>) (field "ssh_url" string)
        |> map2 (|>) (field "clone_url" string)
        |> map2 (|>) (field "svn_url" string)
        |> map2 (|>) (field "homepage" string)
        |> map2 (|>) (field "size" int)
        |> map2 (|>) (field "stargazers_count" int)
        |> map2 (|>) (field "watchers_count" int)
        |> map2 (|>) (field "language" string)
        |> map2 (|>) (field "has_issues" bool)
        |> map2 (|>) (field "has_downloads" bool)
        |> map2 (|>) (field "has_wiki" bool)
        |> map2 (|>) (field "has_pages" bool)
        |> map2 (|>) (field "forks_count" int)
        |> map2 (|>) (field "mirror_url" (nullable string))
        |> map2 (|>) (field "open_issues_count" int)
        |> map2 (|>) (field "forks" int)
        |> map2 (|>) (field "open_issues" int)
        |> map2 (|>) (field "watchers" int)
        |> map2 (|>) (field "default_branch" string)
        |> map2 (|>) (field "network_count" int)
        |> map2 (|>) (field "subscribers_count" int)
        |> map Repo


type alias RepoOwner =
    { login : String
    , id : Int
    , avatar_url : String
    , gravatar_id : String
    , url : String
    , html_url : String
    , followers_url : String
    , following_url : String
    , gists_url : String
    , starred_url : String
    , subscriptions_url : String
    , organizations_url : String
    , repos_url : String
    , events_url : String
    , received_events_url : String
    , type_ : String
    , site_admin : Bool
    }


type alias RepoRecord =
    { id : Int
    , name : String
    , full_name : String
    , owner : RepoOwner
    , private : Bool
    , html_url : String
    , description : Maybe String
    , fork : Bool
    , url : String
    , forks_url : String
    , keys_url : String
    , collaborators_url : String
    , teams_url : String
    , hooks_url : String
    , issue_events_url : String
    , events_url : String
    , assignees_url : String
    , branches_url : String
    , tags_url : String
    , blobs_url : String
    , git_tags_url : String
    , git_refs_url : String
    , trees_url : String
    , statuses_url : String
    , languages_url : String
    , stargazers_url : String
    , contributors_url : String
    , subscribers_url : String
    , subscription_url : String
    , commits_url : String
    , git_commits_url : String
    , comments_url : String
    , issue_comment_url : String
    , contents_url : String
    , compare_url : String
    , merges_url : String
    , archive_url : String
    , downloads_url : String
    , issues_url : String
    , pulls_url : String
    , milestones_url : String
    , notifications_url : String
    , labels_url : String
    , releases_url : String
    , deployments_url : String
    , created_at : String
    , updated_at : String
    , pushed_at : String
    , git_url : String
    , ssh_url : String
    , clone_url : String
    , svn_url : String
    , homepage : String
    , size : Int
    , stargazers_count : Int
    , watchers_count : Int
    , language : String
    , has_issues : Bool
    , has_downloads : Bool
    , has_wiki : Bool
    , has_pages : Bool
    , forks_count : Int
    , mirror_url : Maybe String
    , open_issues_count : Int
    , forks : Int
    , open_issues : Int
    , watchers : Int
    , default_branch : String
    , network_count : Int
    , subscribers_count : Int
    }


type Repo
    = Repo RepoRecord
