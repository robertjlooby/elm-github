module GitHub.Users exposing (User, get, getAvatarUrl, getCurrentUser)

import Http
import Json.Decode exposing (Decoder, bool, field, int, map, map2, nullable, string, succeed)


baseUrl : String
baseUrl =
    "https://api.github.com"


get : String -> Http.Request User
get userName =
    Http.request
        { method = "GET"
        , headers = [ Http.header "Accept" "application/vnd.github.v3+json" ]
        , url = baseUrl ++ "/users/" ++ userName
        , body = Http.emptyBody
        , expect = Http.expectJson userDecoder
        , timeout = Nothing
        , withCredentials = False
        }


getCurrentUser : String -> Http.Request User
getCurrentUser accessToken =
    Http.request
        { method = "GET"
        , headers =
            [ Http.header "Accept" "application/vnd.github.v3+json"
            , Http.header "Authorization" ("token " ++ accessToken)
            ]
        , url = baseUrl ++ "/user"
        , body = Http.emptyBody
        , expect = Http.expectJson userDecoder
        , timeout = Nothing
        , withCredentials = False
        }


userDecoder : Decoder User
userDecoder =
    succeed UserRecord
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
        |> map2 (|>) (field "name" (nullable string))
        |> map2 (|>) (field "company" (nullable string))
        |> map2 (|>) (field "blog" (nullable string))
        |> map2 (|>) (field "location" (nullable string))
        |> map2 (|>) (field "email" (nullable string))
        |> map2 (|>) (field "hireable" (nullable bool))
        |> map2 (|>) (field "bio" (nullable string))
        |> map2 (|>) (field "public_repos" int)
        |> map2 (|>) (field "public_gists" int)
        |> map2 (|>) (field "followers" int)
        |> map2 (|>) (field "following" int)
        |> map2 (|>) (field "created_at" string)
        |> map2 (|>) (field "updated_at" string)
        |> map User


type alias UserRecord =
    { login : String
    , id : Int
    , avatarUrl : String
    , gravatarId : String
    , url : String
    , htmlUrl : String
    , followersUrl : String
    , followingUrl : String
    , gistsUrl : String
    , starredUrl : String
    , subscriptionsUrl : String
    , organizationsUrl : String
    , reposUrl : String
    , eventsUrl : String
    , receivedEventsUrl : String
    , type_ : String
    , siteAdmin : Bool
    , name : Maybe String
    , company : Maybe String
    , blog : Maybe String
    , location : Maybe String
    , email : Maybe String
    , hireable : Maybe Bool
    , bio : Maybe String
    , publicRepos : Int
    , publicGists : Int
    , followers : Int
    , following : Int
    , createdAt : String
    , updatedAt : String
    }


type User
    = User UserRecord


getAvatarUrl : User -> String
getAvatarUrl (User user) =
    user.avatarUrl
